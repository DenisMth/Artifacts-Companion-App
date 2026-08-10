import 'package:flutter/material.dart';
import 'storage/secure_storage.dart';
import 'auth/login_page.dart';
import 'screens/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, 
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artifacts Companion App',
      home: const AuthGate()
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final SecureStorageService storage = SecureStorageService();

  bool? loggedIn;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    try {
      final accessToken = await storage.getAccessToken();
      final refreshToken = await storage.getRefreshToken();

      if (!mounted) return;

      setState(() {
        loggedIn = accessToken != null && refreshToken != null;
      });
    } catch (e) {
      debugPrint('Failed to load authentication: $e');

      if (!mounted) return;

      setState(() {
        loggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Still checking storage.
    if (loggedIn == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Storage has been checked.
    if (loggedIn!) {
      return const HomePage();
    }

    return const LoginPage();
  }
}