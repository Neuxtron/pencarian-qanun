import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/providers/connection_mode_provider.dart';
import 'package:pencarian_qanun_mobile/core/viewmodels/qanun_viewmodel.dart';
import 'package:pencarian_qanun_mobile/routes.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_theme.dart';
import 'package:provider/provider.dart';

class QanunApp extends StatelessWidget {
  const QanunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QanunViewmodel()),
        ChangeNotifierProvider(create: (context) => ConnectionModeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        title: "Pencarian Qanun",
        initialRoute: Routes.main,
        routes: Routes.routes,
      ),
    );
  }
}
