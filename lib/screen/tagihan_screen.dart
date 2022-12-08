import 'dart:convert';
// import 'dart:html';
import 'package:tk_flutter/screen/home_screen.dart';

import '../model/tagihan_model.dart';
import '../widget/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'appointment_detail.dart';

class TagihanScreen extends StatefulWidget {
  const TagihanScreen({Key? key}) : super(key: key);

  static const routeName = '/tagihan';

  @override
  State<TagihanScreen> createState() => _TagihantState();
}

class _TagihantState extends State<TagihanScreen> {
  Future<List<Tagihan>> fetchTagihan() async {
    String? token = await storage.read(key: "jwttoken");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String username = decodedToken["sub"];
    var url = 'http://localhost:8080/api/v1/tagihan/list-tagihan';
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
    // print(finalUri);
    // print("cony");

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      // print(data);
      List<Tagihan> listTagihan = [];

      for (var d in data) {
        // print(d);
        if (d != null) {
          listTagihan.add(Tagihan.fromJson(d));
        }
      }
      return listTagihan;
    } else {
      throw Exception('Failed to load tagihan');
    }
  }

  late Future<List<Tagihan>> futureTagihan;
  @override
  void initState() {
    super.initState();
    futureTagihan = fetchTagihan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Bill'),
        ),
        drawer: const MainDrawer(),
        body: FutureBuilder(
            future: fetchTagihan(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return Column(
                    children: const [
                      Text(
                        "Belum ada tagihan",
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
                                        Text("Tanggal Terbuat: " +
                                            (DateFormat('d MMM yyy HH:mm:ss')
                                                .format(snapshot.data![index]
                                                    .tanggalTerbuat)
                                                .toString())),
                                        Text("Status: " +
                                            (snapshot.data![index].isPaid
                                                ? "Sudah Dibayar"
                                                : "Belum Dibayar"))
                                      ],
                                    ))),
                          ));
                }
              }
            }));
  }
}
