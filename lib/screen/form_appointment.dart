import 'dart:convert';
import 'package:tk_flutter/screen/home_screen.dart';

import '../widget/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class FormAppointment extends StatefulWidget {
  const FormAppointment({Key? key}) : super(key: key);

  static const routeName = '/appointment/add';

  @override
  State<FormAppointment> createState() => _FormAppointmentState();
}

class _FormAppointmentState extends State<FormAppointment> {
  TextEditingController uuidController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  Future<int> postAppointment() async {
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    String? token = await storage.read(key: "jwttoken");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String username = decodedToken["sub"];

    String? tanggal = prefrences.getString('date');
    String? jam = prefrences.getString('jam');
    String? uuid = prefrences.getString('uuid');
    int lengthjam = jam!.length;
    String nol = '0';
    if (lengthjam == 1) {
      jam = '$nol$jam';
    }

    String? menit = prefrences.getString('menit');
    int lengthmenit = menit!.length;
    if (lengthmenit == 1) {
      menit = '$nol$menit';
    }

    String separator = 'T';
    String titikdua = ':';
    String? waktu = '$tanggal$separator$jam$titikdua$menit';

    var url = '$SERVER_URL/api/v1/appointment/add';

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "idDokter": uuid,
          "usernamePasien": username,
          "waktuAwal": waktu
        }));
    if (response.statusCode == 200) {
      var appoinmentArr = json.decode(response.body);
      var waktuawal = appoinmentArr['waktuawal'];
      var waktuakhir = appoinmentArr['waktuakhir'];
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 0);

  Future _showTimePicker() async {
    var timeFormat = DateFormat('HH:MM');

    SharedPreferences myprefrences = await SharedPreferences.getInstance();
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    ).then((value) {
      setState(() {
        _timeOfDay = value!;

        myprefrences.setString('jam', _timeOfDay.hour.toString());
        myprefrences.setString('menit', _timeOfDay.minute.toString());
      });
    });
  }

  DateTime _dateOfDay = DateTime.now();

  Future _showDatePicker() async {
    SharedPreferences myprefrences = await SharedPreferences.getInstance();
    var dateFormat = DateFormat('yyyy-MM-dd');
    showDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
      context: context,
    ).then((value) {
      setState(() {
        _dateOfDay = value!;

        myprefrences.setString(
            'date', dateFormat.format(_dateOfDay).toString());
      });
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Jadwal sudah terisi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Silakan cari jadwal lain'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Isi Form',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pushNamed(FormAppointment.routeName);
              },
            ),
          ],
        );
      },
    );
  }

  List<dynamic>? _listDokter;
  String? namaDokter;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        textStyle: TextStyle(color: Colors.white),
        primary: Colors.green[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ));

    String? baru;
    var myFormat = DateFormat('dd-MM-yyyy');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FORM APPOINTMENT',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const MainDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Silakan Isi Form Berikut untuk Membuat Appointment',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 0.0, left: 10.0, right: 10.0),
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(blurRadius: 2.0, offset: Offset(0, 2))
                      ]),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      myFormat.format(_dateOfDay).toString(),
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: _showDatePicker,
                color: Colors.green[600],
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('PILIH TANGGAL',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, bottom: 0.0, left: 10.0, right: 10.0),
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(blurRadius: 2.0, offset: Offset(0, 2))
                      ]),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      _timeOfDay.format(context).toString(),
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: _showTimePicker,
                color: Colors.green[600],
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('PILIH JAM',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownSearch<dynamic>(
                  dropdownSearchDecoration: const InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    labelText: "Dokter",
                    hintText: "Pilih Dokter",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  ),
                  mode: Mode.MENU,
                  showSearchBox: true,
                  onFind: (text) async {
                    SharedPreferences prefrences =
                        await SharedPreferences.getInstance();
                    String? token = await storage.read(key: "jwttoken");
                    var response = await http.get(
                        Uri.parse("$SERVER_URL/api/v1/appointment/list-dokter"),
                        headers: {
                          'Content-Type': 'application/json',
                          'Accept': 'application/json',
                          'Authorization': 'Bearer $token',
                        });
                    print(token);
                    if (response.statusCode == 200) {
                      var listdata = jsonDecode(response.body);

                      setState(() {
                        _listDokter = listdata;
                      });
                    }

                    return _listDokter as List<dynamic>;
                  },
                  onChanged: (text) async {
                    SharedPreferences prefrences =
                        await SharedPreferences.getInstance();
                    setState(() {
                      int tarif;
                      namaDokter = text['username'];
                    });
                    prefrences.setString('uuid', text['uuid']);
                  },
                  itemAsString: (item) =>
                      item['username'] + " - Rp" + item['tarif'].toString()),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  style: style,
                  onPressed: () async {
                    int code = await postAppointment();
                    if (code == 200) {
                      Navigator.of(context).pushNamed('/appointment');
                    } else {
                      _showMyDialog();
                    }
                  },
                  child: const Text(
                    'submit',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
