import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tk_flutter/widget/main_drawer.dart';
import '../main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import '../model/tagihan_model.dart';
import 'package:http/http.dart' as http;

class TagihanDetail extends StatefulWidget {
  final Tagihan tagihan;

  const TagihanDetail({Key? key, required this.tagihan});

  @override
  State<TagihanDetail> createState() => _TagihantDetail();
}

class _TagihantDetail extends State<TagihanDetail> {
  late Tagihan tagihan = widget.tagihan;
  bool isLoading = false;

  Future<void> paidTagihan(BuildContext context) async {
    try {
      if (tagihan.jumlahTagihan > tagihan.appointment.pasien.saldo) {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Saldo Tidak Cukup"),
                  content:
                      Text("Pastikan saldo Anda cukup untuk membayar tagihan."),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Kembali"))
                  ],
                ));
      } else {
        setState(() {
          isLoading = true;
        });
        String? token = await storage.read(key: "jwttoken");
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
        String kode = tagihan.kode;
        var url1 = 'http://localhost:8080/api/v1/pasien/bayar';
        Map<String, String> queryParams = {
          'kode': '$kode',
        };
        Map<String, String> requestHeaders = {
          "Access-Control-Allow-Origin": "*",
          'Content-type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $token'
        };
        Uri uri1 = Uri.parse(url1);
        final finalUri1 = uri1.replace(queryParameters: queryParams);
        final response = await http.post(
          finalUri1,
          headers: requestHeaders,
        );
        print(finalUri1);

        if (response.statusCode == 200) {
          var url2 = 'http://localhost:8080/api/v1/tagihan/bayar';
          Uri uri2 = Uri.parse(url2);
          final finalUri = uri2.replace(queryParameters: queryParams);
          final response = await http.post(
            finalUri,
            headers: requestHeaders,
          );
          print(finalUri);

          if (response.statusCode == 200) {
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            setState(() {
              tagihan = Tagihan.fromJson(data);
              isLoading = false;
            });
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text('Pembayaran Berhasil'),
                      content: Text("Pembayaran telah berhasil dilakukan."),
                      actions: [
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context, 'Kembali'),
                            child: Text('Kembali')),
                      ],
                    ));
          } else {
            throw Exception('Gagal mengubah status tagihan');
          }
        } else {
          throw Exception('Gagal Membayar');
        }
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
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
                          tagihan.kode,
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
                              tagihan.kode,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            )),
                        ListTile(
                            title: const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Tanggal Terbuat: ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            dense: true,
                            subtitle: Text(
                              // ignore: unnecessary_null_comparison
                              tagihan.tanggalTerbuat.toString == null
                                  ? "-"
                                  : tagihan.tanggalTerbuat.toString(),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            )),
                        ListTile(
                            title: const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Tanggal Bayar: ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            dense: true,
                            subtitle: Text(
                              tagihan.tanggalBayar == null
                                  ? "-"
                                  : tagihan.tanggalBayar.toString(),
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
                            tagihan.isPaid ? "Sudah selesai" : "Belum selesai",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                          dense: true,
                        ),
                        ListTile(
                            title: const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Jumlah Tagihan: ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            dense: true,
                            subtitle: Text(
                              tagihan.jumlahTagihan.toString(),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            )),
                        ListTile(
                            title: const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Kode Appointment: ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            dense: true,
                            subtitle: Text(
                              tagihan.appointment.kode.toString(),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            )),
                      ],
                    ),
                    SizedBox(),
                    SizedBox(
                        child: tagihan.isPaid == false
                            ? ElevatedButton(
                                onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text('Konfirmasi Pembayaran'),
                                          content: Text(
                                              "Apakah Anda ingin melanjutkan pembayaran?"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Batalkan'),
                                                child: Text('Batalkan')),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  await paidTagihan(context);
                                                },
                                                child: Text('Bayar'))
                                          ],
                                        )),
                                child: Text("Lakukan Pembayaran"))
                            : SizedBox()),
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
}
