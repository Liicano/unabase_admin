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

Future<dynamic> deleteCurrency(Currency) async {
  print(Currency);
  await _getApiToken();

  final response = await http.delete(
    '$api/currencies/${Currency}',
    headers: {
      'Content-type': 'application/json',
      'Authorization': _Token,
    },
  );

  if (response.statusCode == 200) {
    print(response.body);
    return jsonDecode(response.body);
  } else {
    throw 'ERROR:  ${response.body}';
  }
}
