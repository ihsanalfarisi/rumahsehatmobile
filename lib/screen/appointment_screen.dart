import 'dart:convert';
// import 'dart:html';
import 'package:tk_flutter/screen/home_screen.dart';

import '../widget/main_drawer.dart';
import '../model/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'appointment_detail.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  static const routeName = '/appointment';

  @override
  State<AppointmentScreen> createState() => _AppointmentState();
}

class _AppointmentState extends State<AppointmentScreen> {
  Future<List<Appointment>> fetchAppointment() async {
    String? token = await storage.read(key: "jwttoken");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String username = decodedToken["sub"];
    var url = '$SERVER_URL/api/v1/appointment/list-appointment';
    Map<String, String> queryParams = {
      'username': '$username',
    };
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Origin": "*",
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    Uri uri = Uri.parse(url);
    final finalUri = uri.replace(queryParameters: queryParams);
    final response = await http.get(
      finalUri,
      headers: requestHeaders,
    );
    print(finalUri);

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      List<Appointment> listAppointment = [];

      for (var d in data) {
        if (d != null) {
          listAppointment.add(Appointment.fromJson(d));
        }
      }
      return listAppointment;
    } else {
      throw Exception('Failed to load appointment');
    }
  }

  late Future<List<Appointment>> futureAppointment;
  @override
  void initState() {
    super.initState();
    futureAppointment = fetchAppointment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Appointment'),
        ),
        drawer: const MainDrawer(),
        body: FutureBuilder(
            future: fetchAppointment(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return Column(
                    children: const [
                      Text(
                        "Belum ada appointment",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Material(
                                elevation: 2.0,
                                borderRadius: BorderRadius.circular(5.0),
                                shadowColor: Colors.blueGrey,
                                child: ListTile(
                                    onTap: () {
                                      // Route menu ke halaman utama
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AppointmentDetail(
                                              appointment:
                                                  snapshot.data![index],
                                            ),
                                          ));
                                    },
                                    title: Text(snapshot.data![index].kode),
                                    subtitle: Column(
                                      children: [
                                        Text("Dokter: " +
                                            snapshot.data![index].dokter.nama),
                                        Text("Waktu awal: " +
                                            (DateFormat('d MMM yyy HH:mm:ss')
                                                .format(snapshot
                                                    .data![index].waktuAwal)
                                                .toString())),
                                        Text("Status: " +
                                            (snapshot.data![index].isDone
                                                ? "Selesai"
                                                : "Belum selesai"))
                                      ],
                                    ))),
                          ));
                }
              }
            }));
  }
}
