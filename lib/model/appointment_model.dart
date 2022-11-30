import 'dart:core';
import '../model/dokter_model.dart';
import '../model/pasien_model.dart';

class Appointment {
    final String kode;
    final DateTime waktuAwal;
    final bool isDone;
    final Dokter dokter;
    final Pasien pasien;
    final bool resep;

    Appointment({
      required this.kode,
      required this.waktuAwal,
      required this.isDone,
      required this.dokter,
      required this.pasien,
      required this.resep
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        kode: json["kode"],
        waktuAwal: DateTime.parse(json['waktuAwal']),
        isDone: json['isDone'] == "true"? true : false,
        dokter: Dokter.fromJson(json["dokter"]),
        resep: json['resep'] == null ? false : true,
        pasien: Pasien.fromJson(json["pasien"]),
      );

  Map<dynamic, dynamic> toJson() => {
        kode: kode,
        waktuAwal: waktuAwal,
        isDone: isDone,
        dokter: dokter,
        resep: resep,
        pasien: pasien,
      };
}