import "package:app/common/widgets/custom_inputs.dart";
import "package:flutter/material.dart";

class RegistrationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email'),
        MinimalTextField(hintText: 'Type Something', prefixIcon: Icons.email),
        Text("Password"),
        MinimalTextField(hintText: 'Type Something', prefixIcon: Icons.lock),
        Text("Password"),
        MinimalTextField(hintText: 'Type Something', prefixIcon: Icons.lock),
      ],
    );
  }
}
