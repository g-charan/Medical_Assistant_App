// lib/presentation/screens/login_screen.dart

import 'package:app/core/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// Your provider
// Assuming you have an assets folder with logos
// e.g., assets/logos/google.svg, assets/logos/apple.svg, etc.
// For this example, we'll use Icons.
// import 'package:flutter_svg/flutter_svg.dart';

// 1. Changed to ConsumerStatefulWidget for Riverpod integration
class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({super.key});

  @override
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  // 2. Controllers for the form fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // ADDED: State variable to track loading state
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. Sign-in logic using Riverpod
  void _signIn() async {
    // Validate the form before proceeding
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Disable button
      });

      // ADDED: A 3-second delay to simulate a network request
      await Future.delayed(const Duration(seconds: 3));

      try {
        // Use 'ref' to call the signInUser method from your auth provider
        await ref
            .read(authServiceProvider)
            .signInUser(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
        // On successful login, AuthGate/StreamProvider should handle navigation.
      } catch (e) {
        // Show a user-friendly error message if login fails
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to log in: ${e.toString()}')),
          );
        }
      } finally {
        // ADDED: Ensure the button is re-enabled even if login fails
        if (mounted) {
          setState(() {
            _isLoading = false; // Re-enable button
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define colors and styles based on the screenshot for easy reuse
    const primaryColor = Color(0xFF3A5B43); // Dark Green from the button
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
    );
    final focusedOutlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: primaryColor, width: 2.0),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 4. Close button at the top left
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () {
                      // Navigate back or to the home screen
                      // Adjust the route as needed, e.g., context.go('/')
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // 5. Main Title
                const Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),

                // 6. Email Text Field
                const Text(
                  'Your email',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    focusedBorder: focusedOutlineBorder,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 7. Password Text Field
                const Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    focusedBorder: focusedOutlineBorder,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // 8. Main Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // UPDATED: Use the _isLoading state to disable the button
                    onPressed: _isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      // ADDED: Style for the disabled state
                      disabledBackgroundColor: primaryColor.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    // UPDATED: Show a loading indicator or the text
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // 9. "Trouble logging in?" Button
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to a password reset or help screen
                      // context.go('/password-reset');
                    },
                    child: const Text(
                      'Trouble logging in?',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // 10. "Or log in with" Divider
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Or log in with',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 30),

                // 11. Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(icon: Icons.apple), // Placeholder
                    const SizedBox(width: 20),
                    _buildSocialButton(
                      icon: Icons.g_mobiledata_outlined,
                    ), // Placeholder for Google
                    const SizedBox(width: 20),
                    _buildSocialButton(icon: Icons.facebook), // Placeholder
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for social login buttons
  Widget _buildSocialButton({required IconData icon}) {
    return OutlinedButton(
      onPressed: () {
        // TODO: Implement social login logic (e.g., Apple, Google, Facebook)
      },
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        side: BorderSide(color: Colors.grey.shade400, width: 1.5),
      ),
      child: Icon(icon, color: Colors.black, size: 28),
    );
  }
}
