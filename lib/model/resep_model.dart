import 'dart:core';
import '../model/dokter_model.dart';
import '../model/pasien_model.dart';

class Resep {
    final int id;
    final bool isDone;
    final DateTime createdAt;

    Resep({
      required this.id,
      required this.isDone,
      required this.createdAt,
  });

  factory Resep.fromJson(Map<String, dynamic> json) => Resep(
        id: json["kode"],
        isDone: json['isDone'] == "true"? true : false,
        createdAt: DateTime.parse(json['waktuAwal']),
      );

  Map<dynamic, dynamic> toJson() => {
        id: id,
        isDone: isDone,
        createdAt: createdAt,
      };
}