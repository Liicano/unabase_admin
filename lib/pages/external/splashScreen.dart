import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:unabase_admin/pages/layout/app_layout.dart';

class ScreenWait extends StatefulWidget {
  @override
  _ScreenWaitState createState() => new _ScreenWaitState();
}

class _ScreenWaitState extends State<ScreenWait> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 4,
        navigateAfterSeconds: AppLayout(),
        image: Image.asset(
          'assets/images/logotipo_largo.png',
          width: 300,
        ),
        loadingText: Text('CARGANDO ADMIN...'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.green);
  }
}
