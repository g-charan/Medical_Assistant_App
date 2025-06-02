import "package:app/common/widgets/custom_button.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:app/data/presentation/widgets/login/login_form.dart";
import "package:app/common/widgets/custom_divider.dart";

class LoginWidget extends StatefulWidget {
  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<LoginWidget> {
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
              "Welcome Back",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text("Sign up your account"),
            const SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [LoginForm()],
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                context.go('/');
              },

              text: "Login",
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 20,
              child: Center(child: Text("Don't have an account? Sign Up")),
            ),
            const SizedBox(height: 20),
            DividerExample(),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                context.go('/second');
              },

              text: "Sign in with google",
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () {
                context.go('/second');
              },

              text: "Sign in with facebook",
            ),
          ],
        ),
      ),
    );
  }
}
