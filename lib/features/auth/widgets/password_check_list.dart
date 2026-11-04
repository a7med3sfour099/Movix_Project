import 'package:flutter/widgets.dart';
import 'package:movixapp/features/auth/widgets/password_req.dart';

class PasswordChecklist extends StatelessWidget {
  final String password;
  const PasswordChecklist({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PasswordRequirement(
          text: "At least 8 characters",
          isChecked: password.length >= 8,
        ),

        PasswordRequirement(
          text: "At least one uppercase letter",
          isChecked: RegExp(r'[A-Z]').hasMatch(password),
        ),

        PasswordRequirement(
          text: "At least one lowercase letter",
          isChecked: RegExp(r'[a-z]').hasMatch(password),
        ),

        PasswordRequirement(
          text: "At least one number and one special character",
          isChecked:
              RegExp(r'[0-9]').hasMatch(password) &&
              RegExp(r'[^a-zA-Z0-9]').hasMatch(password),
        ),
      ],
    );
    //   },
    // );
  }
}
