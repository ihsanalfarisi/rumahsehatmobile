import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tk_flutter/widget/main_drawer.dart';
import 'package:tk_flutter/model/appointment_model.dart';
import '../screen/resep_detail.dart';
import '../main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

class AppointmentDetail extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetail({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      drawer: MainDrawer(),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        appointment.kode,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                          title: const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'Kode: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          dense: true,
                          subtitle: Text(
                            appointment.kode,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          )),
                      ListTile(
                          title: const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'Waktu Awal: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          dense: true,
                          subtitle: Text(
                            appointment.waktuAwal.toString(),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          )),
                      ListTile(
                        title: const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Status: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Text(
                          appointment.isDone ? "Selesai" : "Belum selesai",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                        dense: true,
                      ),
                      ListTile(
                          title: const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'Dokter: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          dense: true,
                          subtitle: Text(
                            appointment.dokter.nama,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          )),
                      appointment.resep == null
                          ? ListTile()
                          : ListTile(
                              title: const Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Resep: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              dense: true,
                              // subtitle: Text(
                              //   appointment.dokter.nama,
                              //   style: const TextStyle(
                              //       fontSize: 14, color: Colors.black),
                              // )
                              subtitle: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.all(15.0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.center,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResepDetailScreen(
                                          resep: appointment.resep!,
                                          namaDokter: appointment.dokter.nama,
                                          namaPasien: appointment.pasien.nama,
                                        ),
                                      ));
                                },
                                child: const Text(
                                  "Resep",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.all(15.0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
