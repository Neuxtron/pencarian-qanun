import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/layouts/main_layout.dart';

class Routes {
  static const String main = "/";

  static final Map<String, Widget Function(BuildContext)> routes = {
    main: (context) => const MainLayout(),
  };
}
