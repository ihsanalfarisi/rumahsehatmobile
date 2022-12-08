import 'dart:core';
import '../model/dokter_model.dart';
import '../model/pasien_model.dart';
import '../model/appointment_model.dart';

class Tagihan {
  final String kode;
  final DateTime tanggalTerbuat;
  DateTime? tanggalBayar;
  final bool isPaid;
  final int jumlahTagihan;
  final Appointment appointment;

  Tagihan(
      {required this.kode,
      required this.tanggalTerbuat,
      required this.tanggalBayar,
      required this.isPaid,
      required this.jumlahTagihan,
      required this.appointment});

  factory Tagihan.fromJson(Map<String, dynamic> json) => Tagihan(
        kode: json["kode"],
        tanggalTerbuat: DateTime.parse(json['tanggalTerbuat']),
        tanggalBayar: json['tanggalBayar'] == null
            ? null
            : DateTime.parse(json['tanggalBayar']),
        isPaid: (json['isPaid']) == false ? false : true,
        jumlahTagihan: json['jumlahTagihan'],
        appointment: Appointment.fromJson(json["appointment"]),
      );

  Map<dynamic, dynamic> toJson() => {
        kode: kode,
        tanggalTerbuat: tanggalTerbuat,
        tanggalBayar: tanggalBayar,
        isPaid: isPaid,
        jumlahTagihan: jumlahTagihan,
        appointment: appointment,
      };
}
