import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tk_flutter/screen/login_screen.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  // Widget _logout() {
  //   return buildListTile('Logout', Icons.logout, () {
  //     user.user.insert(0, {'status': "logged off", "userID": -1});
  //     print(user.user[0]['status']);
  //     Navigator.of(context).pushNamed('/');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
              // child: user.user[0]['status'] == 'logged off'
              // ?
              //  Container(
              decoration: BoxDecoration(color: Colors.green),
              child: Column(children: [
                SizedBox(
                  height: 50,
                ),
                Text("Rumah Sehat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      wordSpacing: 5,
                    )),
                SizedBox(height: 50),
              ])),
          buildListTile('Beranda', Icons.home, () {
            Navigator.of(context).pushNamed('/');
          }),
          buildListTile('Profile', Icons.person, () {
            Navigator.of(context).pushNamed('/profile');
          }),
          buildListTile('Add Appointment', Icons.note_add, () {
            Navigator.of(context).pushNamed('/appointment/add');
          }),
          buildListTile('My Appointment', Icons.note, () {
            Navigator.of(context).pushNamed('/appointment');
          }),
          buildListTile('Logout', Icons.logout, () {
            storage.delete(key: "jwttoken");
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (route) => false);
          }),
        ],
      ),
    );
  }
}
