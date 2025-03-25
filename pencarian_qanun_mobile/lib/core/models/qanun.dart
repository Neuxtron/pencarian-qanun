class Qanun {
  final String id;
  final String nama;
  final int tahun;
  final int nomor;
  // TODO: detail qanun

  Qanun({
    required this.id,
    required this.nama,
    required this.tahun,
    required this.nomor,
  });

  factory Qanun.fromJson(Map<String, dynamic> json) {
    return Qanun(
      id: json["id"],
      nama: json["nama"],
      tahun: json["tahun"],
      nomor: json["nomor"],
    );
  }
}
