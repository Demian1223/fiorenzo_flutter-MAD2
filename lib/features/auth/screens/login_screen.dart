import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/auth/providers/auth_provider.dart';
import 'package:mad2/features/auth/screens/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true; // Track visibility state
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'FIORENZO',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType:
                          TextInputType.emailAddress, // Optimized Keyboard
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter email';
                        if (!v.contains('@')) return 'Invalid email format';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field with Toggle
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? 'Enter password' : null,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          activeColor: Colors.black,
                          onChanged: (v) => setState(() => _rememberMe = v!),
                        ),
                        Text(
                          'Remember Me',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  // Close keyboard
                                  FocusScope.of(context).unfocus();

                                  final success = await auth.login(
                                    _emailController.text.trim(),
                                    _passwordController.text,
                                    rememberMe: _rememberMe,
                                  );

                                  if (success && mounted) {
                                    // Navigate to Home/Main Screen
                                    Navigator.of(
                                      context,
                                    ).pushNamedAndRemoveUntil(
                                      '/',
                                      (route) => false,
                                    );
                                  } else if (mounted) {
                                    // Ensure keyboard is closed so SnackBar is visible
                                    FocusScope.of(context).unfocus();

                                    ScaffoldMessenger.of(
                                      context,
                                    ).clearSnackBars(); // Clear previous
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                auth.authError ??
                                                    'Login failed. Please check credentials.',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Colors.red[900],
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        margin: const EdgeInsets.all(16),
                                        duration: const Duration(seconds: 4),
                                      ),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.zero, // Luxury sharp corners
                          ),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'LOGIN',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'CREATE AN ACCOUNT',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
