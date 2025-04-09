import 'dart:convert';
import 'dart:developer';

import 'package:pencarian_qanun_mobile/core/models/komisi.dart';
import 'package:pencarian_qanun_mobile/core/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:pencarian_qanun_mobile/features/komisi/models/detail_komisi.dart';

class KomisiRepository {
  String get _endpoint => "${AppConstants.baseUrl}/api/komisi";

  Future<List<Komisi>> getKomisi() async {
    log("Fetching API: Get komisi");
    final response = await http.get(Uri.parse(_endpoint));
    if (response.statusCode != 200) {
      throw Exception("API Error:\n${response.body}");
    }
    final data = jsonDecode(response.body)["data"] as List;
    return data.map((e) => Komisi.fromJson(e)).toList();
  }

  Future<List<DetailKomisi>> getDetailKomisi(String id) async {
    log("Fetching API: Get detail komisi");
    final response = await http.get(Uri.parse("$_endpoint/$id"));
    if (response.statusCode != 200) {
      throw Exception("API Error:\n${response.body}");
    }
    final body = jsonDecode(response.body);
    final data = body["data"] as List;
    final komisiJson = body["komisi"];
    return data.map((e) => DetailKomisi.fromJson(e, komisiJson)).toList();
  }
}
