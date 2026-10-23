import 'package:flutter/material.dart';
import 'package:movixapp/features/settings/styles/settings_text_styles.dart';


class LogoutButton extends StatelessWidget {
  const LogoutButton ({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      height: 36,
      child:
        OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFFE53935),
              side: BorderSide(color: Color(0xFFE53935), width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8),
              ),
              padding: EdgeInsets.zero,

            ),
          child: Text(
            'LOG OUT',
            style: SettingsTextStyles.logout,),

        )
    );
  }
}
