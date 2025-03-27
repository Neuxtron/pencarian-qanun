import 'package:pencarian_qanun_mobile/core/models/komisi.dart';

class Qanun {
  final String id;
  final String nama;
  final int tahun;
  final int nomor;
  final String? namaFile;
  final Komisi? komisi;

  Qanun({
    required this.id,
    required this.nama,
    required this.tahun,
    required this.nomor,
    required this.namaFile,
    required this.komisi,
  });

  factory Qanun.fromJson(Map<String, dynamic> json) {
    final komisiJson = json["komisi"];

    return Qanun(
      id: json["id"],
      nama: json["nama"],
      tahun: json["tahun"],
      nomor: json["nomor"],
      namaFile: json["namaFile"],
      komisi: Komisi.fromJson(komisiJson),
    );
  }
}
