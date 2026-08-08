import 'dart:convert';

import 'package:http/http.dart' as http;

import '../storage/secure_storage.dart';

class ApiClient {
  final SecureStorageService storage =
      SecureStorageService();

  final String baseUrl =
      "https://artifacts-api.marchosius.be";

  Future<http.Response> post(
    String path, {
    Object? body,
  }) async {

    String? accessToken =
        await storage.getAccessToken();

    var response = await http.post(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: body,
    );

    // Access token expired.
    if (response.statusCode == 401) {

      final refreshed = await _refreshAccessToken();

      if (!refreshed) {
        await storage.deleteTokens();
        return response;
      }

      accessToken =
          await storage.getAccessToken();

      response = await http.post(
        Uri.parse("$baseUrl$path"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: body,
      );
    }

    return response;
  }

  Future<bool> _refreshAccessToken() async {
    final refreshToken =
        await storage.getRefreshToken();

    if (refreshToken == null) {
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/refresh"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "refresh_token": refreshToken,
        }),
      );

      if (response.statusCode != 200) {
        return false;
      }

      final data = jsonDecode(response.body);

      final newAccessToken =
          data["access_token"];

      if (newAccessToken == null) {
        return false;
      }

      await storage.saveAccessToken(
        newAccessToken,
      );

      return true;

    } catch (_) {
      return false;
    }
  }
}