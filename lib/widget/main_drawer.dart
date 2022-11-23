import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
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
              ])
              // )
              // : UserAccountsDrawerHeader(
              //     accountName: Text(user.user[0]['username']),
              //     accountEmail: Text(user.user[0]['email']),
              //   ),
              ),
          buildListTile('Beranda', Icons.home, () {
            Navigator.of(context).pushNamed('/');
          }),
          buildListTile('Appointment', Icons.note_add, () {
            Navigator.of(context).pushNamed('/');
          }),
          // buildListTile('Info Statistik', Icons.insert_chart, () {
          //   // karena login belom ada userID nya 1 dulu
          //   Navigator.of(context).pushNamed(Loading.routeName, arguments: {
          //     "userID": user.user[0]['userID'],
          //     "task": "fetchData"
          //   });
          // }),
          // buildListTile('Regulasi', Icons.fact_check, () {
          //   Navigator.of(context).pushNamed(RegulasiScreen.routeName);
          // }),
          // buildListTile('Get Swabbed!', Icons.health_and_safety, () {
          //   Navigator.of(context).pushReplacementNamed(FormSwabState.routeName);
          // }),
          // buildListTile('Info Hotel Karantina', Icons.hotel, () {
          //   Navigator.of(context).pushNamed(HotelScreen.routeName);
          // }),
          // buildListTile('Artikel', Icons.article, () {
          //   Navigator.of(context).pushNamed(ListArtikelState.routeName);
          // }),
          // buildListTile('Support', Icons.help, () {
          //   Navigator.of(context).pushNamed(SupportScreen.routeName);
          // }),
          // Container(
          //     child: user.user[0]['status'] == 'logged off' ? null : _logout())
        ],
      ),
    );
  }
}
