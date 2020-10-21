import 'package:flutter/material.dart';
import 'package:unabase_admin/pages/external/login.dart';
import 'package:unabase_admin/pages/external/webview_pages.dart';
import 'package:unabase_admin/pages/home.dart';
import 'package:unabase_admin/pages/impuestos/impuestos_list.dart';
import 'package:unabase_admin/pages/items/items_page.dart';
import 'package:unabase_admin/pages/layout/app_layout.dart';
import 'package:unabase_admin/pages/monedas/monedas_list.dart';
import 'package:unabase_admin/pages/permisos/permisos_list.dart';
import 'package:unabase_admin/pages/permisos/permisos_list_one.dart';
import 'package:unabase_admin/pages/rubros/rubros_list.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/appLayout': (BuildContext context) => AppLayout(),
    '/home': (BuildContext context) => MyHomePage(title: 'Dashboard'),
    '/login': (BuildContext context) => Login(),
    '/impuestos': (BuildContext context) => ImpuestosList(title: 'Impuestos'),
    '/items': (BuildContext context) => ItemsPage(),
    '/rubros': (BuildContext context) => RubrosList(),
    '/monedas': (BuildContext context) => MonedasList(title: 'Monedas'),
    '/permisos': (BuildContext context) => PermisosList(title: 'Permisos'),
    '/verPermisosDelModulo': (BuildContext context) =>
        PermisosListOne(title: 'Permisos'),
    '/webview': (BuildContext context) => MyWebView(
          title: 'web',
          selectedUrl: 'https://alligator.io/flutter/webview/',
        ),
  };
}
