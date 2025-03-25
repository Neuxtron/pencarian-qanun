import 'package:pencarian_qanun_mobile/shared/utils/helpers.dart';

class Komisi {
  final String id;
  final String nama;
  final String nomorKomisi;

  Komisi({
    required this.id,
    required this.nama,
    required this.nomorKomisi,
  });

  factory Komisi.toJson(Map<String, dynamic> json) {
    final nomorKomisi = toRoman(json["nomorKomisi"]);

    return Komisi(
      id: json["id"],
      nama: json["nama"],
      nomorKomisi: nomorKomisi,
    );
  }
}
