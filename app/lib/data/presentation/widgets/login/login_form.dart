import "package:app/common/widgets/custom_inputs.dart";
import "package:flutter/material.dart";

class LoginForm extends StatelessWidget {
  // 1. Add fields to accept the controllers from the parent widget.
  final TextEditingController emailController;
  final TextEditingController passwordController;

  // 2. Add a constructor to require these controllers.
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email'), // Changed from 'Name' to 'Email'
        MinimalTextField(
          // 3. Pass the email controller to the first text field.
          controller: emailController,
          hintText: 'Enter your email', // More specific hint text
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress, // Good for email fields
        ),
        const SizedBox(height: 16), // Added spacing
        const Text("Password"),
        MinimalTextField(
          // 4. Pass the password controller to the second text field.
          controller: passwordController,
          hintText: 'Enter your password', // More specific hint text
          prefixIcon: Icons.lock,
          obscureText: true, // Hides the password text
        ),
      ],
    );
  }
}
