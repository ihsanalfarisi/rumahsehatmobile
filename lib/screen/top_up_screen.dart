import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tk_flutter/screen/profile_screen.dart';
import 'package:tk_flutter/widget/main_drawer.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({Key? key}) : super(key: key);

  @override
  State<TopUpScreen> createState() => _TopUpState();
}

class _TopUpState extends State<TopUpScreen> {
  TextEditingController saldoController = TextEditingController();

  Future<int> updatePasien() async {
    String? token = await storage.read(key: "jwttoken");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String username = decodedToken["sub"];
    String saldo = saldoController.text;

    var url = '$SERVER_URL/api/v1/pasien/topup';

    Map<String, String> queryParams = {
      'username': '$username',
    };

    Uri uri = Uri.parse(url);
    final finalUri = uri.replace(queryParameters: queryParams);
    var response = await http.post(finalUri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"username": username, "saldo": saldo}));

    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Up Saldo"),
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Masukkan jumlah top up",
                  prefixText: "Rp",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              controller: saldoController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () async {
                int code = await updatePasien();
                if (code == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Top-up saldo berhasil"),
                  ));
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ProfileScreen();
                  }));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Top-up saldo gagal"),
                  ));
                }
              },
              color: Colors.green[600],
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Konfirmasi',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
