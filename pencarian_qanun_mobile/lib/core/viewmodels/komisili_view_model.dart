import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/models/komisili.dart';

class KomisiliViewModel extends ChangeNotifier {
  final List<Komisili> _listKomisili = [
    Komisili(
      id: "1",
      nama: "Komsili 1",
    ),
    Komisili(
      id: "1",
      nama: "Komsili 1",
    ),
    Komisili(
      id: "1",
      nama: "Komsili 1",
    ),
    Komisili(
      id: "1",
      nama: "Komsili 1",
    ),
  ];
  List<Komisili> get listKomisili => _listKomisili;

  Future getKomisili() async {}
  // TODO: get komisili
}
