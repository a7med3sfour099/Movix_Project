import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/features/auth/views/change_password_view.dart';
import 'package:movixapp/features/auth/views/forget_password.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CustomElevatedbutton(
              text: 'Forget Password',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgetPassword()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
