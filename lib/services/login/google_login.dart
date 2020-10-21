import 'dart:async';

import 'package:http/http.dart' as http;

String api = 'https://dev.unabase.net';

Future<dynamic> googleLogin() async {
  final response = await http.get(
    '$api/auth/google',
    headers: {
      'Content-type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return response;
  } else {
    return response;
  }
}
