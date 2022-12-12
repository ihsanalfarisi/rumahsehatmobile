import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../main.dart';
import 'dart:convert';
import '../model/appointment_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = "/";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> homeData;

  Future<Map<String, dynamic>> getHomeData() async {
    String? token = await storage.read(key: "jwttoken");
    Map<String, dynamic> homeData = {};
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String username = decodedToken["sub"];
      homeData["username"] = username;
      var url = 'http://localhost:8080/api/v1/home-data';
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
        homeData["appointment_count"] = data["appointment_count"];
        homeData["saldo"] = data["saldo"];
        return homeData;
      } else {
        throw Exception('Failed to load appointment');
      }
    } else {
      throw Exception('Failed to get username');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeData = getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getHomeData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: Text("Loading..."),
            );
          } else {
            String usernameWelcome = snapshot.data["username"];
            int appointment_count = snapshot.data["appointment_count"];
            int saldo = snapshot.data["saldo"];
            return ListView(
              children: [
                Column(children: <Widget>[
                  const SizedBox(
                    width: 20.0,
                    height: 30.0,
                  ),
                  const Text("RumahSehat",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        wordSpacing: 5,
                      )),
                  const SizedBox(
                    width: 20.0,
                    height: 30.0,
                  ),
                  Text("Hello, $usernameWelcome !",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        wordSpacing: 5,
                      )),
                  const SizedBox(
                    width: 20.0,
                    height: 30.0,
                  ),
                  Text("You have $appointment_count appointments.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        wordSpacing: 5,
                      )),
                  const SizedBox(
                    width: 20.0,
                    height: 30.0,
                  ),
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.lightGreen,
                      elevation: 5,
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Text("SALDO",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                    wordSpacing: 5,
                                  )),
                              const SizedBox(
                                width: 20.0,
                                height: 10.0,
                              ),
                              Text("Rp. $saldo ",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                    wordSpacing: 5,
                                  )),
                            ],
                          ))),
                  const SizedBox(
                    width: 20.0,
                    height: 30.0,
                  ),
                ])
              ],
            );
          }
        });
  }
}
