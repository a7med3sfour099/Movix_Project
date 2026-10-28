import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/features/settings/views/settings_view.dart';

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
              text: 'Setting',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsView()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
