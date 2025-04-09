import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/layouts/main_layout.dart';
import 'package:pencarian_qanun_mobile/features/komisi/views/komisi_page.dart';
import 'package:pencarian_qanun_mobile/features/qanun/views/qanun_page.dart';

class Routes {
  static const String main = "/";
  static const String detailKomisi = "/detail_komisi";
  static const String hasilPencarian = "/hasil_penarian";
  static const String qanun = "/qanun";

  static final Map<String, Widget Function(BuildContext)> routes = {
    main: (context) => const MainLayout(),
    detailKomisi: (context) => const KomisiPage(),
    qanun: (context) => const QanunPage(),
  };
}
