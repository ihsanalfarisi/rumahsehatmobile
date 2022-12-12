import 'resep_model.dart';
import 'obat_model.dart';

class JumlahObatResep {
  final int id;
  final Resep resep;
  final Obat obat;
  final int kuantitas;

  JumlahObatResep(
      {required this.id,
      required this.resep,
      required this.obat,
      required this.kuantitas});

  factory JumlahObatResep.fromJson(Map<String, dynamic> json) =>
      JumlahObatResep(
          id: json["id"],
          resep: Resep.fromJson(json["resep"]),
          obat: Obat.fromJson(json["obat"]),
          kuantitas: json["kuantitas"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "resep": resep, "obat": obat, "kuantitas": kuantitas};
}
