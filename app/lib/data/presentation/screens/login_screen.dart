// lib/presentation/screens/login_screen.dart (or wherever your widget is)

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/data/presentation/providers/auth_provider.dart'; // Your provider
import 'package:app/data/presentation/widgets/ui/login/login_form.dart'; // Your form widget
import 'package:app/common/widgets/custom_button.dart';
import 'package:app/common/widgets/custom_divider.dart';

// 1. Change to ConsumerStatefulWidget
class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({super.key});

  @override
  // 2. Update the createState method
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

// 3. Change State to ConsumerState
class _LoginWidgetState extends ConsumerState<LoginWidget> {
  // 4. Create controllers for email and password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 5. Create the sign-in function
  void _signIn() async {
    // Basic validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    try {
      // Use 'ref' to read the provider and call the signInUser method
      await ref
          .read(authServiceProvider)
          .signInUser(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      // Navigation will be handled by your AuthGate/StreamProvider automatically
      // on successful login. No need for context.go() here.
    } catch (e) {
      // Show an error message if login fails
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Welcome Back",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const Text("Sign in to your account"), // Corrected text
            const SizedBox(height: 40),
            // 6. Pass the controllers to your LoginForm
            LoginForm(
              emailController: _emailController,
              passwordController: _passwordController,
            ),
            const SizedBox(height: 20),
            // 7. Call the _signIn function from the button
            CustomButton(
              onPressed: _signIn, // <-- Use the new function
              text: "Login",
            ),
            const SizedBox(height: 40),
            // FIX: Made the "Sign Up" text a clickable link
            Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  children: <TextSpan>[
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to the registration screen.
                          // Ensure you have a route like '/register' in your app_routes.dart
                          context.go('/register');
                        },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            DividerExample(),
            const SizedBox(height: 20),
            // ... other buttons
          ],
        ),
      ),
    );
  }
}
