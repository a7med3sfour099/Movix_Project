import 'package:app_links/app_links.dart';

class AppLinkService {
  final AppLinks _appLinks = AppLinks();

  Future<void> init({
    required void Function(String oobCode) onPasswordResetLink,
  }) async {
    // Handle a link that opened the app from a terminated state.
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri, onPasswordResetLink);
    }

    // Handle links received while the app is already running.
    _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri, onPasswordResetLink);
    });
  }

  void _handleUri(Uri uri, void Function(String oobCode) onPasswordResetLink) {
    // Firebase wrap the actual action URL inside the "link" parameter.
    final nestedLink = uri.queryParameters['link'];
    final actionUri = nestedLink != null ? Uri.tryParse(nestedLink) : uri;

    if (actionUri == null) return;

    final mode = actionUri.queryParameters['mode'];
    final oobCode = actionUri.queryParameters['oobCode'];

    if (mode == 'resetPassword' && oobCode != null && oobCode.isNotEmpty) {
      onPasswordResetLink(oobCode);
    }
  }
}
