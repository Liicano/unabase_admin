import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

String api = 'https://dev.unabase.net';

Future<http.Response> userLogin(User) async {
  print(User);

  final response = await http.post('$api/auth/login',
      headers: {
        'Content-type': 'application/json',
      },
      body: jsonEncode(User));

  if (response.statusCode == 200) {
    print(jsonEncode(response.body));
    return response;
  } else {
    return response;
  }
}
