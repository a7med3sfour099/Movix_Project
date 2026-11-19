import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/Widgets/are_you_sure_dialog.dart';
import 'package:movixapp/features/auth/cubit/auth_cubit.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AreYouSureDialog(
      title: 'Log out?',
      description:
          'Are you sure you want to log out of your MOVIX account? Locally cached favorites will remain safe.',
      icon: Icons.logout_rounded,
      confirmText: 'Log out',
      confirmIcon: Icons.logout_rounded,
      onConfirm: () async {
        Navigator.of(context).pop();
        await context.read<AuthCubit>().logout();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      },
    );
  }
}
