import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:unabase_admin/services/login/login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[_crearFondo(context), _loginForm(context)],
      ),
    );
  }
}

Widget _loginForm(context) {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SafeArea(
            child: Container(
          height: 180.0,
        )),
        Container(
          width: 500,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            margin: EdgeInsets.all(15),
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 50.0, bottom: 50.00),
                        child: Center(
                            child: Image.asset(
                          'assets/images/logotipo_largo.png',
                          width: 250,
                        )),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: TextFormField(
                          obscureText: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Correo',
                          ),
                          onSaved: (value) {
                            _username = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Campo vacio';
                            }
                            List text = value.split('@');
                            if (text.length > 0) {
                              if (text[1] != 'unabase.com') {
                                print(text[1]);
                                return 'Correo no pertenece a unabase.';
                              }
                            }

                            if (text.length <= 0) {
                              return 'Ingrese un correo valido';
                            }

                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Contraseña',
                          ),
                          onSaved: (value) {
                            _password = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Campo vacio';
                            }
                            return null;
                          },
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: FlatButton(
                            child: const Text(
                              'INICIAR SESION',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 15),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                Map<String, String> userData = {
                                  "username": _username,
                                  "password": _password
                                };

                                var data = await userLogin(userData);

                                if (data.statusCode == 200) {
                                  await _saveUserLocalStorage(data.body);
                                  Navigator.pushNamed(context, '/home');
                                } else {
                                  if (data.statusCode == 404) {
                                    _showAlertError(
                                        context, 'Ups!', 'Usuario no existe!');
                                  } else {
                                    print(jsonEncode(data.body));
                                    _showAlertError(context, 'Error!',
                                        'Error ${jsonEncode(data.body)}');
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      /*Center(
                        child: Text(
                          'Ò',
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      new Container(
                        alignment: FractionalOffset.bottomCenter,
                        margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                        child: new RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                side:
                                    BorderSide(color: const Color(0xFF4285F4))),
                            padding: EdgeInsets.only(
                                top: 3.0, bottom: 3.0, left: 3.0),
                            color: const Color(0xFF4285F4),
                            onPressed: () async {
                              var resp = await googleLogin();
                              print(resp.body);

                              // Navigator.pushNamed(context, '/webview');
                            },
                            child: new Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Image.network(
                                    'https://img.icons8.com/clouds/2x/google-logo.png',
                                    width: 40),
                                new Container(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: new Text(
                                      "Iniciar sesion con Google",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 15,
                      )*/
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _crearFondo(context) {
  final size = MediaQuery.of(context).size;
  final fondoSuperior = Container(
    height: size.height * 0.4,
    width: double.infinity,
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
      Color.fromRGBO(52, 160, 2, 1.0),
      Color.fromRGBO(52, 180, 2, 1.0)
    ])),
  );

  final circulo = Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: Color.fromRGBO(255, 255, 255, 0.10),
    ),
  );

  return Stack(
    children: <Widget>[
      fondoSuperior,
      Positioned(top: 90.0, left: 30.0, child: circulo),
      Positioned(top: -40.0, right: 35.0, child: circulo),
      Positioned(bottom: -50.0, right: -10.0, child: circulo),
      Positioned(top: 300.0, left: -40.0, child: circulo),
      Container(
        padding: EdgeInsets.only(top: 80.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 10.0,
            ),
            Text(
              'Administracion',
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            ),
            SizedBox(
              width: double.infinity,
              height: 10.0,
            ),
          ],
        ),
      )
    ],
  );
}

_saveUserLocalStorage(user) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('userData', user);
  print('saved $user');
}

void _showAlertError(BuildContext context, titulo, subtitulo) {
  SweetAlert.show(context,
      title: titulo, subtitle: subtitulo, style: SweetAlertStyle.error);
}
