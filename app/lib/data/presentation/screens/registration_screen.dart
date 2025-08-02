import 'package:app/common/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/data/presentation/providers/auth_provider.dart';
import 'package:app/data/presentation/widgets/ui/registration/registration_form.dart';

// 1. Convert to ConsumerStatefulWidget
class RegistrationWidget extends ConsumerStatefulWidget {
  const RegistrationWidget({super.key});

  @override
  ConsumerState<RegistrationWidget> createState() => _RegistrationWidgetState();
}

// 2. Convert to ConsumerState
class _RegistrationWidgetState extends ConsumerState<RegistrationWidget> {
  // 3. Add controllers for all form fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController =
      TextEditingController(); // The missing controller

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Dispose the new controller
    super.dispose();
  }

  // 4. Create the sign-up function with password validation
  void _signUp() async {
    // Add validation for matching passwords
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Use ref to read the provider and call the signUpUser method
      await ref
          .read(authServiceProvider)
          .signUpUser(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // On success, show a confirmation message.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Success! Please check your email to confirm.'),
          ),
        );
        context.go('/login');
      }
    } catch (e) {
      // Show an error message if sign-up fails
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
              "Sign Up",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const Text("Create an account"),
            const SizedBox(height: 40),
            // 5. Pass all controllers to your RegistrationForm
            RegistrationForm(
              emailController: _emailController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
            ),
            const SizedBox(height: 20),
            CustomButton(onPressed: _signUp, text: "Register"),
            const SizedBox(height: 40),
            Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  children: <TextSpan>[
                    const TextSpan(text: "Have an account? "),
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.go('/login');
                        },
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            const Center(child: Text("By signing up, you agree to our ")),
            const Center(child: Text("Terms and Privacy Policy.")),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
