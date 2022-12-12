import 'dart:core';
import '../model/apoteker_model.dart';
import 'appointment_model.dart';

class Resep {
  final int id;
  final bool isDone;
  final DateTime createdAt;
  // final Appointment appointment;
  final Apoteker? apoteker;
  Resep({
    required this.id,
    required this.isDone,
    required this.createdAt,
    // required this.appointment,
    this.apoteker,
  });

  factory Resep.fromJson(Map<String, dynamic> json) => Resep(
        id: json["id"],
        isDone: json['isDone'],
        createdAt: DateTime.parse(json['createdAt']),
        // appointment: Appointment.fromJson(json["appointment"]),
        apoteker: json["apoteker"] != null
            ? Apoteker.fromJson(json["apoteker"])
            : null,
      );

  Map<dynamic, dynamic> toJson() => {
        id: id,
        isDone: isDone,
        createdAt: createdAt,
        // appointment: appointment,
        apoteker: apoteker,
      };
}
