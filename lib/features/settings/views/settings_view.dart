import 'package:flutter/material.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/settings/styles/settings_text_styles.dart';
import 'package:movixapp/features/settings/widgets/settings_tile.dart';
import 'package:movixapp/features/settings/widgets/settings_switch_tile.dart';
import 'package:movixapp/features/settings/widgets/logout_button.dart';
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notificationsEnabled = true;
  static const _tileGap = SizedBox(height: 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
          title: "Settings",
          back: true,
          onPressed:()=> Navigator.maybePop(context),
        ),
      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Profile" , style: SettingsTextStyles.sectionTitle,),
                _tileGap,
                SettingsTile(title: "Edit Profile", onTap: (){}),
                _tileGap,
                SettingsTile(title: "Change Password", onTap: (){},),
                SizedBox(height: 20,),
                Text("Preference" , style: SettingsTextStyles.sectionTitle,),
                _tileGap,
                SettingsSwitchTile(
                    title: "Notifications",
                    value: _notificationsEnabled,
                    onChanged: (v) => setState(() {
                      _notificationsEnabled = v;
                    })),
                SizedBox(height: 20,),
                Text("About" , style: SettingsTextStyles.sectionTitle,),
                _tileGap,
                SettingsTile(title: "About App", onTap: (){},),
                _tileGap,
                SettingsTile(title: "Privacy Policy", onTap: (){},),
                _tileGap,
                SettingsTile(title: "Terms & Conditions", onTap: (){}),
                SizedBox(height: 15,),
                Center(child: LogoutButton(onPressed: (){}),),

              ],
            ),
          )

      ),

    );
  }
}
