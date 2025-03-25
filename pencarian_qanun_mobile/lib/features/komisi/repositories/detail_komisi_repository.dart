import 'dart:convert';
import 'dart:developer';

import 'package:pencarian_qanun_mobile/core/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:pencarian_qanun_mobile/features/komisi/models/detail_komisi.dart';

class DetailKomisiRepository {
  String get _endpoint => "${AppConstants.baseUrl}/api/komisi";

  Future<List<DetailKomisi>> getDetailKomisi(String id) async {
    log("Fetching API: Get detail komisi");
    final response = await http.get(Uri.parse("$_endpoint/$id"));
    if (response.statusCode != 200) {
      throw Exception("API Error:\n${response.body}");
    }
    final data = jsonDecode(response.body)["data"] as List;
    return data.map((e) => DetailKomisi.fromJson(e)).toList();
  }
}
