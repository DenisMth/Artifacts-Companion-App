import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    await _storage.write(
      key: "access_token",
      value: token,
    );
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(
      key: "access_token",
    );
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(
      key: "refresh_token",
      value: token,
    );
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(
      key: "refresh_token",
    );
  }

  Future<void> deleteTokens() async {
    await _storage.delete(
      key: "access_token",
    );

    await _storage.delete(
      key: "refresh_token",
    );
  }
}

// class SecureStorageService {
//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();

//     await prefs.setString(
//       "access_token",
//       token,
//     );
//   }

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();

//     return prefs.getString("access_token");
//   }

//   Future<void> deleteToken() async {
//     final prefs = await SharedPreferences.getInstance();

//     await prefs.remove("access_token");
//   }
// }