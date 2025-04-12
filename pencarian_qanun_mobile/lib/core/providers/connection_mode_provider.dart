import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/shared/utils/app_utils.dart';

class ConnectionModeProvider extends ChangeNotifier {
  late BuildContext context;

  bool _isOnline = true;
  bool get isOnline => _isOnline;
  set isOnline(bool mode) {
    if (mode == isOnline) return;
    final modeString = mode ? "Mode Online" : "Mode Offline";
    AppUtils.showSnackbar(context, modeString);
    _isOnline = mode;
  }
}
