import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/custom_toggle_switch.dart';
import 'package:movixapp/features/settings/widgets/settings_tile.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      title: title,
      onTap: () => onChanged(!value),
      trailing: AppToggleSwitch(value: value, onChanged: onChanged),
    );  }
}

