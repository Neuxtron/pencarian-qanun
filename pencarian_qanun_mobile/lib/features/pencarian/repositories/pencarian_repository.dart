import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pencarian_qanun_mobile/core/models/qanun.dart';
import 'package:pencarian_qanun_mobile/core/utils/app_constants.dart';

class PencarianRepository {
  String get _endpoint => "${AppConstants.baseUrl}/api/qanun";

  Future<List<Qanun>> searchQanun(String text) async {
    log("Fetching API: Search qanun: $text");
    final response = await http.get(Uri.parse("$_endpoint?search=$text"));
    if (response.statusCode != 200) {
      throw Exception("API Error:\n${response.body}");
    }
    final data = jsonDecode(response.body)["data"] as List;
    return data.map((e) => Qanun.fromJson(e)).toList();
  }
}
