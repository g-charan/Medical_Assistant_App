import "package:app/common/widgets/custom_button.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:app/data/presentation/widgets/registration/registration_form.dart";

class InputBoxExample extends StatefulWidget {
  @override
  RegistrationScreen createState() => RegistrationScreen();
}

class RegistrationScreen extends State<InputBoxExample> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose(); // Remember to dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
            // Handle save action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign Up",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text("Create an account"),
            const SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [RegistrationForm()],
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                context.go('/login');
              },

              text: "Register 2",
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 20,
              child: Center(child: Text("Have an account? Sign In")),
            ),
            const SizedBox(height: 60),
            SizedBox(
              height: 20,
              child: Center(child: Text("By signing up, you agree to our ")),
            ),
            SizedBox(
              height: 20,
              child: Center(child: Text("Terms and Privacy Policy.")),
            ),
          ],
        ),
      ),
    );
  }
}
