import 'dart:convert';
import 'dart:developer';

import 'package:pencarian_qanun_mobile/core/models/komisi.dart';
import 'package:pencarian_qanun_mobile/core/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class KomisiRepository {
  String get _endpoint => "${AppConstants.baseUrl}/api/komisi";

  Future<List<Komisi>> getKomisi() async {
    log("Fetching API...");
    final response = await http.get(Uri.parse(_endpoint));
    if (response.statusCode != 200) {
      throw Exception("API Error:\n${response.body}");
    }
    final data = jsonDecode(response.body)["data"] as List;
    return data.map((e) => Komisi.toJson(e)).toList();
  }
}
