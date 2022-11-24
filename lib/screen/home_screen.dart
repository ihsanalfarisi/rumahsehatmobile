import 'package:flutter/material.dart';
import 'package:tk_flutter/screen/register_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(children: <Widget>[
          SizedBox(
            width: 20.0,
            height: 30.0,
          ),
          Text("- RUMAH SEHAT -",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                wordSpacing: 5,
              )),
          ElevatedButton(
              child: Text("Login"),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
              onPressed: () {
                Navigator.of(context).pushNamed("/");
              }),
          ElevatedButton(
              child: Text("Belum punya akun? Register"),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
              onPressed: () {
                Navigator.of(context).pushNamed(RegisterScreen.routeName);
              })
        ])
      ],
    );
  }
}
