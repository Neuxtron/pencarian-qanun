import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pencarian_qanun_mobile/core/models/qanun.dart';
import 'package:pencarian_qanun_mobile/core/services/database_service.dart';
import 'package:pencarian_qanun_mobile/core/utils/app_constants.dart';

class QanunRepository {
  final _endpoint = "${AppConstants.baseUrl}/api/qanun";

  Future<Qanun?> getDetailQanun(String id) async {
    log("Fetching API: Get detail qanun");
    try {
      final response = await http.get(Uri.parse("$_endpoint/$id"));
      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)["message"];
        throw Exception(message);
      }

      final dataJson = jsonDecode(response.body)["data"];
      final qanun = Qanun.fromJson(dataJson);
      return qanun;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future readQanun(Qanun qanun) async {
    DatabaseService().readQanun(qanun);
  }
}
