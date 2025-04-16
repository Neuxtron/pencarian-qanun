import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pencarian_qanun_mobile/core/models/qanun.dart';
import 'package:pencarian_qanun_mobile/core/services/database_service.dart';
import 'package:pencarian_qanun_mobile/core/utils/app_constants.dart';
import 'package:path_provider/path_provider.dart';

class QanunRepository {
  final _endpoint = "${AppConstants.baseUrl}/api/qanun";
  final _databaseService = DatabaseService();

  Future<DetailQanun> getDetailQanun(String id) async {
    log("Fetching API: Get detail qanun");
    try {
      final response = await http.get(Uri.parse("$_endpoint/$id"));
      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)["message"];
        throw Exception(message);
      }

      final dataJson = jsonDecode(response.body)["data"];
      final qanun = Qanun.fromJson(dataJson);
      return qanun.details!;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future readQanun(Qanun qanun) async {
    await _databaseService.readQanun(qanun);
  }

  Future<bool> downloadQanun(Qanun qanun) async {
    try {
      final response = await http.get(Uri.parse(qanun.downloadUrl!));
      if (response.statusCode != 200) {
        throw Exception("Download Failed: ${response.statusCode}");
      }
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${qanun.id}.pdf');

      await file.writeAsBytes(response.bodyBytes);
      log('File downloaded to: ${file.path}');
      await _databaseService.saveQanun(qanun);
      return true;
    } catch (e) {
      log("Failed to download: $e");
      return false;
    }
  }

  Future<bool> checkIsDownloaded(String id) async {
    return _databaseService.checkIsDownloaded(id);
  }

  Future<List<Qanun>> getRiwayatQanun() async {
    try {
      final riwayatMap = await _databaseService.getRiwayatQanun();
      return riwayatMap.map((e) => Qanun.fromDatabase(e)).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> bintangQanun(Qanun qanun) async {
    return _databaseService.bintangQanun(qanun);
  }

  Future<bool> checkIsDibintang(String id) async {
    return _databaseService.checkIsDibintang(id);
  }

  Future<List<Qanun>> getQanunDibintang() async {
    try {
      final dibintangMap = await _databaseService.getQanunDibintang();
      return dibintangMap.map((e) => Qanun.fromDatabase(e)).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
