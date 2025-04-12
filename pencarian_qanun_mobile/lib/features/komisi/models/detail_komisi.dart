import 'package:pencarian_qanun_mobile/core/models/qanun.dart';

class DetailKomisi {
  final int tahun;
  final List<Qanun> listQanun;

  DetailKomisi({
    required this.tahun,
    required this.listQanun,
  });

  factory DetailKomisi.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> komisiJson,
  ) {
    final listQanunJson = json["data"] as List;

    return DetailKomisi(
      tahun: json["tahun"],
      listQanun: listQanunJson
          .map((e) => Qanun.fromJson(e, komisiJson: komisiJson))
          .toList(),
    );
  }

  factory DetailKomisi.fromDatabase(Map<String, dynamic> json) {
    final listQanunJson = json["listQanun"] as Iterable;

    return DetailKomisi(
      tahun: json["tahun"],
      listQanun: listQanunJson.map((e) => Qanun.fromDatabase(e)).toList(),
    );
  }
}
