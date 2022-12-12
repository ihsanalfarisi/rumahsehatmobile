import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tk_flutter/model/pasien_model.dart';
import 'package:tk_flutter/screen/top_up_screen.dart';
import 'package:tk_flutter/widget/main_drawer.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Pasien> futureProfilePasien;

  @override
  void initState() {
    super.initState();
    futureProfilePasien = fetchProfile();
  }

  Future<Pasien> fetchProfile() async {
    String? token = await storage.read(key: "jwttoken");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String username = decodedToken["sub"];
    var url = '$SERVER_URL/api/v1/pasien/profile';
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

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      Pasien pasien = Pasien.fromJson(data);
      return pasien;
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        drawer: const MainDrawer(),
        body: FutureBuilder(
            future: fetchProfile(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: Text("Loading..."),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Username',
                          style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(snapshot.data.username,
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      ),
                      const Divider(),
                      ListTile(
                        title: Text(
                          'Nama',
                          style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(snapshot.data.nama,
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      ),
                      const Divider(),
                      ListTile(
                        title: Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(snapshot.data.email,
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      ),
                      const Divider(),
                      ListTile(
                        title: Text(
                          'Saldo',
                          style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(snapshot.data.saldo.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const TopUpScreen();
                          }));
                        },
                        color: Colors.green[600],
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Top Up Saldo',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
