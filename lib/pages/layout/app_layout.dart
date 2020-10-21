import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unabase_admin/pages/external/login.dart';
import 'package:unabase_admin/pages/home.dart';

class AppLayout extends StatefulWidget {
  @override
  _AppLayout createState() => _AppLayout();
}

class _AppLayout extends State<AppLayout> {
  var _userData;
  bool _isLogged;
  var _userToken;

  @override
  void initState() {
    super.initState();
    _readUserLocalStorage();
  }

  //LEER EL USUARIO DESDE EL LOCALSTORAGE
  _readUserLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('userData') != null
        ? jsonDecode(prefs.getString('userData'))['token']
        : null;

    _userToken != null ? _isLogged = true : _isLogged = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLogged == null
          ? Container()
          : _isLogged == false ? Login() : MyHomePage(title: 'Dashboard'),
    );
  }
}
