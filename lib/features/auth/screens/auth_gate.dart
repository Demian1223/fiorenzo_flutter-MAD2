import 'package:flutter/material.dart';
import 'package:mad2/features/auth/providers/auth_provider.dart';
import 'package:mad2/features/auth/screens/login_screen.dart';
import 'package:mad2/features/main/screens/main_shell.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    // Load session once on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).loadSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isAppLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (auth.isAuthenticated) {
      return const MainShell();
    } else {
      return const LoginScreen();
    }
  }
}
