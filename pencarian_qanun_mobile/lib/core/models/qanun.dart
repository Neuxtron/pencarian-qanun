import 'package:pencarian_qanun_mobile/core/models/komisi.dart';

class Qanun {
  final String id;
  final String nama;
  final int tahun;
  final int nomor;
  final Komisi? komisi;
  final DetailQanun? details;

  Qanun({
    required this.id,
    required this.nama,
    required this.tahun,
    required this.nomor,
    required this.komisi,
    required this.details,
  });

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

  Map<String, dynamic> toMap() {
    return {
      "id_qanun": id,
      "nomor_komisi": komisi!.nomorKomisi,
      "tahun": tahun,
      "nama": nama,
      "nomor": nomor,
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
