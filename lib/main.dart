import 'package:flutter/material.dart';

import 'package:tk_flutter/screen/login_screen.dart';
import 'package:tk_flutter/screen/tagihan_screen.dart';
import 'package:tk_flutter/screen/profile_screen.dart';
import '../screen/home_screen.dart';
import '../screen/tabs_screen.dart';
import '../screen/register_screen.dart';
import '../screen/appointment_screen.dart';
import '../screen/tagihan_screen.dart';
import '../screen/form_appointment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final storage = FlutterSecureStorage();
// final SERVER_URL = "http://localhost:8080";
final SERVER_URL = "https://apap-072.cs.ui.ac.id";

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeData theme = ThemeData();
  Widget entryPage = LoginScreen();

  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  void isLoggedIn() async {
    String? token = await storage.read(key: "jwttoken");
    if (token == null || JwtDecoder.isExpired(token)) {
      setState(() {
        entryPage = LoginScreen();
      });
    } else {
      setState(() {
        entryPage = TabsScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rumah Sehat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        canvasColor: Colors.white,
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: const TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyText2: const TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            headline6: const TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
      ),
      home: entryPage,
      routes: {
        // '/': (ctx) => TabsScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        FormAppointment.routeName: (ctx) => FormAppointment(),
        AppointmentScreen.routeName: (ctx) => AppointmentScreen(),
        TagihanScreen.routeName: (ctx) => TagihanScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        ProfileScreen.routeName: (ctx) => ProfileScreen()
      },
      // ignore: missing_return
      onGenerateRoute: (settings) {
        print(settings.arguments);
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        );
      },
    );
  }
}
