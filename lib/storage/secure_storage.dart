import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(
      key: "access_token",
      value: token,
    );
  }

  Future<String?> getToken() async {
    return await _storage.read(
      key: "access_token",
    );
  }

  Future<void> deleteToken() async {
    await _storage.delete(
      key: "access_token",
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