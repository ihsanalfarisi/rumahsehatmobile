import 'dart:convert';
import 'package:tk_flutter/screen/register_screen.dart';
import 'package:tk_flutter/screen/tabs_screen.dart';

import 'package:flutter/material.dart';
import '../main.dart';
import '../request_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreentate();
}

class _LoginScreentate extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  RequestHandler requestHandler = RequestHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoginFailed = false;

  void _togglePasswordView() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Text("Login RumahSehat",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      wordSpacing: 5)),
              SizedBox(height: 20),
              Text(_isLoginFailed ? "Wrong password or username" : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  )),
// Form
              SizedBox(height: 20),
              Form(
                key: _loginFormKey,
                child: Container(
                  child: Column(
                    children: [
// Username
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(250, 250, 250, 0.95),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          controller: _usernameController,
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
// Password
                      Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(250, 250, 250, 0.95),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
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
                                      color: Colors.green, width: 10)),
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
// Login Button
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
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
                            if (_loginFormKey.currentState!.validate()) {
                              Map<String, String> formData = {
                                "username": _usernameController.text,
                                "password": _passwordController.text
                              };
                              var response = await requestHandler.post(
                                  "/api/v1/auth/signin", formData);

                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                Map<String, dynamic> output =
                                    jsonDecode(response.body);
                                print(output["jwttoken"]);
                                await storage.write(
                                    key: "jwttoken", value: output["jwttoken"]);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TabsScreen(),
                                    ),
                                    (route) => false);
                                print(await storage.read(key: "jwttoken"));
                              } else {
                                setState(() {
                                  _isLoginFailed = true;
                                });
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RegisterScreen.routeName);
                        },
                        child: const Text('Belum punya akun?'),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
