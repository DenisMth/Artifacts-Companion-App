import 'package:flutter/material.dart';
import 'storage/secure_storage.dart';
import 'auth/auth_service.dart';
import 'auth/login_page.dart';
import 'screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artifacts Companion App',
      home: const AuthGate(),
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

  String debugInfo = 'Starting authentication check...';

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    try {
      setState(() {
        debugInfo = 'Checking for refresh token...';
      });

      final refreshToken = await storage.getRefreshToken();

      if (!mounted) return;

      setState(() {
        debugInfo =
            'Refresh token exists: ${refreshToken != null}\n'
            'Refresh token length: ${refreshToken?.length ?? 0}';
      });

      if (refreshToken == null) {
        setState(() {
          loggedIn = false;
          debugInfo += '\nNo refresh token found → LOGIN';
        });

        return;
      }

      setState(() {
        debugInfo += '\nAttempting to refresh access token...';
      });

      final authService = AuthService(storage);

      final success = await authService.refreshAccessToken();

      if (!mounted) return;

      setState(() {
        loggedIn = success;

        debugInfo +=
            '\nRefresh result: $success\n'
            '${authService.lastError}\n'
            '${success ? "Access token refreshed → HOME" : "Refresh failed → LOGIN"}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loggedIn = false;
        debugInfo = 'ERROR:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loggedIn == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Authentication Debug'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              debugInfo,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    if (loggedIn!) {
      return const HomePage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Debug'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              debugInfo,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            const LoginPage(),
          ],
        ),
      ),
    );
  }
}