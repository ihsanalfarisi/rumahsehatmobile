import 'dart:core';
import '../model/dokter_model.dart';
import '../model/pasien_model.dart';
import '../model/resep_model.dart';

class Appointment {
  final String kode;
  final DateTime waktuAwal;
  final bool isDone;
  final Dokter dokter;
  final Pasien pasien;
  Resep? resep = null;

  Appointment(
      {required this.kode,
      required this.waktuAwal,
      required this.isDone,
      required this.dokter,
      required this.pasien,
      this.resep});

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        kode: json["kode"],
        waktuAwal: DateTime.parse(json['waktuAwal']),
        isDone: json['isDone'],
        dokter: Dokter.fromJson(json["dokter"]),
        resep: json["resep"] != null ? Resep.fromJson(json["resep"]) : null,
        pasien: Pasien.fromJson(json["pasien"]),
      );

  Map<dynamic, dynamic> toJson() => {
        kode: kode,
        waktuAwal: waktuAwal,
        isDone: isDone,
        dokter: dokter,
        pasien: pasien,
        resep: resep
      };
}
