import 'package:pencarian_qanun_mobile/core/models/komisi.dart';
import 'package:pencarian_qanun_mobile/core/utils/app_constants.dart';

class Qanun {
  final String id;
  final String nama;
  final int tahun;
  final int nomor;
  final Komisi? komisi;
  DetailQanun? details;

  Qanun({
    required this.id,
    required this.nama,
    required this.tahun,
    required this.nomor,
    required this.komisi,
    required this.details,
  });

  String? get downloadUrl {
    if (details == null) return null;
    return "${AppConstants.baseUrl}/qanun/$id - ${details!.namaFile}";
  }

  factory Qanun.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic>? komisiJson,
  }) {
    komisiJson ??= json["komisi"];
    final detailsJson = json["details"];

    return Qanun(
      id: json["id"],
      nama: json["nama"],
      tahun: json["tahun"],
      nomor: json["nomor"],
      komisi: komisiJson != null ? Komisi.fromJson(komisiJson) : null,
      details: detailsJson != null ? DetailQanun.fromJson(detailsJson) : null,
    );
  }

  factory Qanun.fromDatabase(Map<String, dynamic> json) {
    final komisiJson = {
      "id": json["id_komisi"],
      "nama_komisi": json["nama_komisi"],
      "nomor_komisi": json["nomor_komisi"],
    };
    final detailsJson = json["details"];

    return Qanun(
      id: json["id"],
      nama: json["nama_qanun"],
      tahun: json["tahun"],
      nomor: json["nomor_qanun"],
      komisi: Komisi.fromDatabase(komisiJson),
      details: detailsJson != null ? DetailQanun.fromJson(detailsJson) : null,
    );
  }

  Map<String, dynamic> toReadMap() {
    return {
      "id_qanun": id,
      "id_komisi": komisi!.id,
      "tahun": tahun,
      "nama_qanun": nama,
      "nomor_qanun": nomor,
    };
  }

  Map<String, dynamic> toSaveMap() {
    return {
      "id": id,
      "id_komisi": komisi!.id,
      "tahun": tahun,
      "nomor_qanun": nomor,
      "nama_qanun": nama,
      "nama_file": id,
    };
  }
}

class DetailQanun {
  final String namaFile;
  final List<String> tags;

  DetailQanun({
    required this.namaFile,
    required this.tags,
  });

  factory DetailQanun.fromJson(Map<String, dynamic> json) {
    final tagsJson = json["tags"] as List;

    return DetailQanun(
      namaFile: json["namaFile"],
      tags: tagsJson.map((e) => e["text"] as String).toList(),
    );
  }
}
