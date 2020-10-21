import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String api = 'https://dev.unabase.net';
var _userData;
var _Token;

_getApiToken() async {
  final prefs = await SharedPreferences.getInstance();
  _userData = prefs.getString('userData');
  print(jsonDecode(_userData));
  _Token = jsonDecode(_userData)['token'];
}

Future<http.Response> getReportData() async {
  await _getApiToken();

  final response = await http.get(
    'https://dev.unabase.net/reports',
    headers: {
      'Content-type': 'application/json',
      "Access-Control-Allow-Origin": "*",
      'Authorization': _Token,
    },
  );

  if (response.statusCode == 200) {
    print(jsonEncode(response.body));
    return response;
  } else {
    print(jsonEncode(response.body));
    throw 'Error en la peticion de movements ERROR:  ${response.statusCode}';
  }
}
