import 'package:flutter/material.dart';
import 'storage/secure_storage.dart';
import 'auth/login_page.dart';
import 'screens/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = SecureStorageService();
  final token = await storage.getToken();


  runApp(
    MyApp(
      loggedIn: token != null,
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