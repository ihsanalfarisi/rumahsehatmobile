import 'dart:convert';
import 'package:tk_flutter/screen/home_screen.dart';

import '../widget/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:intl/intl.dart';
// import 'user.dart' as user;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {
    'email': null,
    'username': null,
    'nama': null,
    'password': null,
    'umur': null
  };
  bool _isPasswordVisible = false;
  bool _isConfPasswordVisible = false;
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();
  void _togglePasswordView() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfPasswordView() {
    setState(() {
      _isConfPasswordVisible = !_isConfPasswordVisible;
    });
  }

  Future<http.Response> signUp() async {
    print(formData);
    final res = await http.post(Uri.parse("$SERVER_IP/api/v1/auth/register"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(formData));
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      drawer: MainDrawer(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Text("Join RumahSehat",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      wordSpacing: 5)),
              SizedBox(height: 20),
// Form
// Email
              Form(
                key: _registerFormKey,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(250, 250, 250, 0.95),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          onSaved: (String? value) {
                            formData['email'] = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(200, 200, 200, 1),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 10),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Email tidak boleh kosong";
                            }
                            if (!RegExp(
                                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(value)) {
                              return "Email invalid";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
// Username
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(250, 250, 250, 0.95),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          onSaved: (String? value) {
                            formData['username'] = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(200, 200, 200, 1),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 10),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Username tidak boleh kosong";
                            }
                            if (value.contains(" ")) {
                              return "Username invalid";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
// Nama
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(250, 250, 250, 0.95),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          onSaved: (String? value) {
                            formData['nama'] = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Nama',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(200, 200, 200, 1),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 10),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Nama tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
// Birthdate
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(250, 250, 250, 0.95),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          controller: _birthDateController,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1920),
                                lastDate: DateTime.now());
                            if (pickedDate != null) {
                              formData["umur"] =
                                  DateTime.now().year - pickedDate.year;
                              _birthDateController.text =
                                  DateFormat("yyyy-MM-dd").format(pickedDate);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Tanggal Lahir',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(200, 200, 200, 1),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 10),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Nama tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
// Password
                      Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(250, 250, 250, 0.95),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            onSaved: (String? value) {
                              formData['password'] = value;
                            },
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(200, 200, 200, 1),
                              ),
                              suffixIcon: IconButton(
                                color: Color.fromRGBO(200, 200, 200, 1),
                                splashRadius: 1,
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                                onPressed: _togglePasswordView,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.cyan, width: 10)),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password tidak boleh kosong";
                              }
                              if (!RegExp(
                                      r"(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}")
                                  .hasMatch(value)) {
                                return "Password harus mengandung huruf kecil, besar, angka, dan simbol";
                              }
                              return null;
                            },
                          )),
                      SizedBox(
                        height: 30,
                      ),
// Confirm Password
                      Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(250, 250, 250, 0.95),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            onSaved: (String? value) {
                              formData['password'] = value;
                            },
                            obscureText: !_isConfPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(200, 200, 200, 1),
                              ),
                              suffixIcon: IconButton(
                                color: Color.fromRGBO(200, 200, 200, 1),
                                splashRadius: 1,
                                icon: Icon(_isConfPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                                onPressed: _toggleConfPasswordView,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.cyan, width: 10)),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Password tidak boleh kosong";
                              }
                              if (value != _passwordController.text) {
                                return "Password harus sama dengan sebelumnya";
                              }
                              return null;
                            },
                          )),
                      SizedBox(
                        height: 30,
                      ),
// Login Button
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.cyan),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.black12;
                              return null; // Defer to the widget's default.
                            }),
                          ),
                          onPressed: () async {
                            if (_registerFormKey.currentState!.validate()) {
                              _registerFormKey.currentState?.save();
                              final response = await signUp();
                              if (response.statusCode == 200) {
                                storage.write(key: "jwt", value: "jwt");
                                Navigator.of(context)
                                    .pushNamed(HomeScreen.routeName);
                              }
                            }
                            // print(username + " " + password);
                            // if (_registerFormKey.currentState!.validate()) {
                            //   final response = await http.post(
                            // Uri.parse(
                            //     "https://pbp-b07.herokuapp.com/loginf"),
                            // headers: <String, String>{
                            //   'Content-Type':
                            //       'application/json;charset=UTF-8',
                            // },
                            //       body: jsonEncode(<String, String>{
                            //         'username': username,
                            //         'password': password,
                            //       }));
                            //   dynamic dataJSON =
                            //       await jsonDecode(response.body);
                            //   print(response);
                            //   print(response.body);

                            //   if (dataJSON["status"] == "logged in") {
                            //     user.user.insert(0, dataJSON);
                            //     print(user.user[0]['status']);
                            //     print(user.user[0]);
                            //     Navigator.pushNamed(context, "/", arguments: {
                            //       "userID": dataJSON["userID"],
                            //       "task": "fetchData"
                            //     });
                            //   }
                            // } else {
                            //   print("Ga valid");
                            // }
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // RichText(
              //   text: TextSpan(
              //       text: "Belum memiliki akun?",
              //       style: TextStyle(
              //         color: Colors.black,
              //       ),
              //       recognizer: TapGestureRecognizer()
              //         ..onTap = () {
              //           Navigator.popAndPushNamed(context, "/register");
              //         }),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
