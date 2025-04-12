import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/models/komisi.dart';
import 'package:pencarian_qanun_mobile/core/providers/connection_mode_provider.dart';
import 'package:pencarian_qanun_mobile/core/services/database_service.dart';
import 'package:pencarian_qanun_mobile/core/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:pencarian_qanun_mobile/features/komisi/models/detail_komisi.dart';
import 'package:provider/provider.dart';

class KomisiRepository {
  final BuildContext context;
  KomisiRepository(this.context);

  String get _endpoint => "${AppConstants.baseUrl}/api/komisi";
  ConnectionModeProvider get _modeProvider =>
      context.read<ConnectionModeProvider>();

  Future<List<Komisi>> getKomisi() async {
    if (!_modeProvider.isOnline) return _getOfflineKomisi();

    log("Fetching API: Get komisi");
    try {
      final response = await http.get(Uri.parse(_endpoint));
      if (response.statusCode != 200) {
        throw Exception("API Error:\n${response.body}");
      }
      final data = jsonDecode(response.body)["data"] as List;
      return data.map((e) => Komisi.fromJson(e)).toList();
    } on SocketException {
      return _getOfflineKomisi();
    }
  }

  Future<List<DetailKomisi>> getDetailKomisi(String id) async {
    if (!_modeProvider.isOnline) return _getOfflineDetailKomisi(id);

    log("Fetching API: Get detail komisi");
    try {
      final response = await http.get(Uri.parse("$_endpoint/$id"));
      if (response.statusCode != 200) {
        throw Exception("API Error:\n${response.body}");
      }
      final body = jsonDecode(response.body);
      final data = body["data"] as List;
      final komisiJson = body["komisi"];
      return data.map((e) => DetailKomisi.fromJson(e, komisiJson)).toList();
    } on SocketException {
      return _getOfflineDetailKomisi(id);
    }
  }

  Future<List<Komisi>> _getOfflineKomisi() async {
    _modeProvider.isOnline = false;
    final dataMap = await DatabaseService().getKomisi();
    return dataMap.map((e) => Komisi.fromDatabase(e)).toList();
  }

  Future<List<DetailKomisi>> _getOfflineDetailKomisi(String id) async {
    _modeProvider.isOnline = false;
    final listQanun = await DatabaseService().getQanunByKomisi(id);

    List<int> listTahun = [];
    for (var qanun in listQanun) {
      final tahun = qanun["tahun"];
      if (!listTahun.contains(tahun)) listTahun.add(tahun);
    }

    final detailKomisiJson = listTahun.map((tahun) {
      final qanunByTahun = listQanun.where((qanun) => qanun["tahun"] == tahun);
      return {
        "tahun": tahun,
        "listQanun": qanunByTahun,
      };
    });
    return detailKomisiJson.map((e) => DetailKomisi.fromDatabase(e)).toList();
  }
}
