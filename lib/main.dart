import 'package:flutter/material.dart';
import 'package:tk_flutter/screen/login_screen.dart';
import '../screen/home_screen.dart';
import '../screen/tabs_screen.dart';
import '../screen/register_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final storage = FlutterSecureStorage();

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
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen()
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
