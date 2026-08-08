import 'package:flutter/material.dart';
import 'storage/secure_storage.dart';
import 'auth/login_page.dart';
import 'screens/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final accessToken = await storage.getAccessToken();
  final refreshToken = await storage.getRefreshToken();

  runApp(
    MyApp(
      loggedIn: accessToken != null && refreshToken != null,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn,});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artifacts Companion App',
      home: loggedIn ? const HomePage() : const LoginPage(),
    );
  }
}