import 'package:flutter/foundation.dart';

class GuestService {
  static final ValueNotifier<bool> isGuest = ValueNotifier<bool>(false);

  static void enterGuestMode() {
    isGuest.value = true;
  }

  static void exitGuestMode() {
    isGuest.value = false;
  }
}