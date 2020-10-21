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

Future<dynamic> postNewItem(item) async {
  print(item);
  await _getApiToken();

  final response = await http.post('$api/items/',
      headers: {
        'Content-type': 'application/json',
        'Authorization': _Token,
      },
      body: jsonEncode(item));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw 'ERROR:  ${response.body}';
  }
}
