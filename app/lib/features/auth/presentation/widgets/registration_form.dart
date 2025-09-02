import "package:app/core/widgets/custom_inputs.dart";
import "package:flutter/material.dart";

class RegistrationForm extends StatelessWidget {
  // 1. Add fields to accept the controllers
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  // 2. Add a constructor to require these controllers
  const RegistrationForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email'),
        MinimalTextField(
          // 3. Pass the controllers to the fields
          controller: emailController,
          hintText: 'Enter your email',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        const Text("Password"),
        MinimalTextField(
          controller: passwordController,
          hintText: 'Enter your password',
          prefixIcon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        const Text("Confirm Password"), // Update label
        MinimalTextField(
          controller: confirmPasswordController,
          hintText: 'Confirm your password',
          prefixIcon: Icons.lock,
          obscureText: true,
        ),
      ],
    );
  }
}
