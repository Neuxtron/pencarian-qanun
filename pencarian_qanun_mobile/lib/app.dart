import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/routes.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_theme.dart';

class QanunApp extends StatelessWidget {
  const QanunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.main,
      routes: Routes.routes,
    );
  }
}
