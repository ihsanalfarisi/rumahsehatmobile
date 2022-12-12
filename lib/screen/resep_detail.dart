import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tk_flutter/model/jumlah_obat_resep_model.dart';
import 'package:tk_flutter/widget/main_drawer.dart';
import 'package:tk_flutter/model/appointment_model.dart';
import 'package:tk_flutter/model/resep_model.dart';
import '../main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResepDetailScreen extends StatefulWidget {
  final Resep resep;
  final String namaDokter;
  final String namaPasien;
  const ResepDetailScreen({
    Key? key,
    required this.resep,
    required this.namaDokter,
    required this.namaPasien,
  }) : super(key: key);

  @override
  State<ResepDetailScreen> createState() => _ResepDetailState();
}

class _ResepDetailState extends State<ResepDetailScreen> {
  Future<List<JumlahObatResep>> fetchJumlahObatResep() async {
    String? token = await storage.read(key: "jwttoken");
    var url = '$SERVER_URL/api/v1/resep/list-jumlah-obat/' +
        widget.resep.id.toString();

    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Origin": "*",
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    Uri uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      List<JumlahObatResep> listJumlahObatResep = [];

      for (var d in data) {
        if (d != null) {
          listJumlahObatResep.add(JumlahObatResep.fromJson(d));
        }
      }
      return listJumlahObatResep;
    } else {
      throw Exception('Failed to load jumlah obat resep');
    }
  }

  late Future<List<JumlahObatResep>> futureJumlahObatResep;

  @override
  void initState() {
    super.initState();
    futureJumlahObatResep = fetchJumlahObatResep();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Resep'),
        ),
        drawer: MainDrawer(),
        body: FutureBuilder(
            future: fetchJumlahObatResep(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Row(
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
                                  'Detail Resep',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                ListTile(
                                    title: const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'ID: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    dense: true,
                                    subtitle: Text(
                                      widget.resep.id.toString(),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    )),
                                ListTile(
                                    title: const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'Dokter: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    dense: true,
                                    subtitle: Text(
                                      widget.namaDokter,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    )),
                                ListTile(
                                    title: const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'Pasien: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    dense: true,
                                    subtitle: Text(
                                      widget.namaPasien,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    )),
                                ListTile(
                                    title: const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'Status: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    dense: true,
                                    subtitle: Text(
                                      widget.resep.isDone
                                          ? "Selesai"
                                          : "Belum selesai",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    )),
                                ListTile(
                                    title: const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'Jumlah Obat: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    dense: true,
                                    subtitle: Text(
                                      snapshot.data!.length.toString(),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    )),
                                widget.resep.apoteker == null
                                    ? ListTile()
                                    : ListTile(
                                        title: const Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 10.0),
                                          child: Text(
                                            'Apoteker: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        dense: true,
                                        subtitle: Text(
                                          widget.resep.apoteker!.nama,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        )),
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text("Nama Obat")),
                                      DataColumn(label: Text("Kuantitas"))
                                    ],
                                    rows: snapshot.data!
                                        .map<DataRow>((jumlahObat) =>
                                            DataRow(cells: <DataCell>[
                                              DataCell(Text(
                                                  jumlahObat.obat.namaObat)),
                                              DataCell(Text(jumlahObat.kuantitas
                                                  .toString()))
                                            ]))
                                        .toList(),
                                    headingTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: const EdgeInsets.all(15.0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
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
                );
              }
            }));
  }
}
