import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/secure_storage.dart';

class AuthService {
  final SecureStorageService storage;

  AuthService(this.storage);

  final String baseUrl = 'https://artifacts-api.marchosius.be';

  String lastError = '';

  Future<bool> refreshAccessToken() async {
    final refreshToken = await storage.getRefreshToken();

    if (refreshToken == null) {
      lastError = "No refresh token";
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refresh_token': refreshToken,
        }),
      );

      // if (response.statusCode != 200) {
      //   await storage.deleteTokens();
      //   return false;
      // }
      if (response.statusCode != 200) {
        lastError =
          'HTTP ${response.statusCode}\n'
          'Response:\n${response.body}';

        return false;
      }

      final data = jsonDecode(response.body);

      final newAccessToken = data['access_token'];

      if (newAccessToken == null) {
        lastError =
          'HTTP 200 but no access_token\n'
          'Response:\n${response.body}';
        // await storage.deleteTokens();
        return false;
      }

      await storage.saveAccessToken(newAccessToken);

      lastError = 'Refresh successful';

      return true;
    } catch (e) {
      lastError = 'Exception:\n$e';
      return false;
    }
  }
}