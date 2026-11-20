import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

/// Shared layout for detail screens, including loading and error states
class DetailsScaffold extends StatelessWidget {
  final String title;
  final bool loading;
  final String? error;
  final VoidCallback? onRetry;
  final Widget? body;

  const DetailsScaffold({
    super.key,
    required this.title,
    this.loading = false,
    this.error,
    this.onRetry,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1512),
      bottomNavigationBar: const BottomBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBackButton(),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _content()),
          ],
        ),
      ),
    );
  }

  Widget _content() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: HomeHeader.greenColor),
      );
    }
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error!, style: const TextStyle(color: Colors.white)),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      );
    }
    return body ?? const SizedBox.shrink();
  }
}
