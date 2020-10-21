import 'package:flutter/material.dart';
import 'package:unabase_admin/pages/external/splashScreen.dart';
import 'package:unabase_admin/routes/routes.dart';

class AdminApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'admin_app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: ScreenWait(),
        routes: getApplicationRoutes());
  }
}
