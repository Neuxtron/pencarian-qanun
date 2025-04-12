import 'package:pencarian_qanun_mobile/shared/utils/app_utils.dart';

class Komisi {
  final String id;
  final String nama;
  final int nomor;

  Komisi({
    required this.id,
    required this.nama,
    required this.nomor,
  });

  String get nomorRomawi => AppUtils.toRoman(nomor);

  factory Komisi.fromJson(Map<String, dynamic> json) {
    return Komisi(
        id: json["id"], nama: json["nama"], nomor: json["nomorKomisi"]);
  }

  factory Komisi.fromDatabase(Map<String, dynamic> json) {
    return Komisi(
        id: json["id"], nama: json["nama_komisi"], nomor: json["nomor_komisi"]);
  }

  Map<String, dynamic> toSaveMap() {
    return {
      "id": id,
      "nama_komisi": nama,
      "nomor_komisi": nomor,
    };
  }
}
