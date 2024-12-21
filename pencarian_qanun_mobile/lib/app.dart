import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/routes.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:provider/provider.dart';

class QanunApp extends StatelessWidget {
  const QanunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: "Poppins",
        ),
        initialRoute: Routes.main,
        routes: Routes.routes,
      ),
    );
  }
}
