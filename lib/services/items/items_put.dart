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

Future<dynamic> putItem(item) async {
  print(item);
  await _getApiToken();

  final response = await http.put('$api/sections/${item['_id']}',
      headers: {
        'Content-type': 'application/json',
        'Authorization': _Token,
      },
      body: jsonEncode(item));

  if (response.statusCode == 200) {
    print(response.body);
    return response.body;
  } else {
    throw 'ERROR:  ${response.body}';
  }
}
