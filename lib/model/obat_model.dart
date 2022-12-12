class Obat {
  final String idObat;
  final String namaObat;
  final int stok;
  final int harga;

  Obat({
    required this.idObat,
    required this.namaObat,
    required this.stok,
    required this.harga,
  });

  factory Obat.fromJson(Map<String, dynamic> json) => Obat(
        idObat: json["idObat"],
        namaObat: json["namaObat"],
        stok: json["stok"],
        harga: json["harga"],
      );

  Map<String, dynamic> toJson() => {
        "idObat": idObat,
        "namaObat": namaObat,
        "stok": stok,
        "harga": harga,
      };
}
