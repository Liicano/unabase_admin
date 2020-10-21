import 'dart:convert';
import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unabase_admin/pages/components/percentChart.dart';
import 'package:unabase_admin/pages/components/piechart.dart';
import 'package:unabase_admin/services/home/chart_movements.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _userData;
  var _movements;

  @override
  void initState() {
    super.initState();
    _readUserLocalStorage();
    _readChartstData();
  }

  //GENERAR COLOR ALEATORIO PARA CHART DE MONEDAS
  Random random = new Random();

  String generateRandomHexColor() {
    int length = 6;
    String chars = '0123456789ABCDEF';
    String hex = '#';
    while (length-- > 0) hex += chars[(random.nextInt(16)) | 0];
    return hex;
  }

  //LEER EL USUARIO DESDE EL LOCALSTORAGE
  _readUserLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userData'));

    setState(() {
      _userData = prefs.getString('userData');
    });
  }

  //BUSCAR LOS MOVIMIENTOS DE LA APP
  _readChartstData() async {
    _movements = await getReportData();
    print(jsonDecode(_movements.body)['currencies']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (_userData == null || _movements == null) {
      return new Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              tooltip: 'Cerrar sesion',
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.clear();
                Navigator.pushNamed(context, '/appLayout');
              },
            ),
          ],
        ),
        body: _userData == null
            ? Container()
            : CustomScrollView(
                primary: false,
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(5),
                    sliver: SliverGrid.count(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: size.width > 600 ? 3 : 1,
                      children: <Widget>[
                        _MovementsCard(),
                        _currenciesCard(),
                        _UsersCard(),
                      ],
                    ),
                  ),
                ],
              ),
        drawer: _userData == null
            ? Text('')
            : Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            minRadius: 35,
                            child: Text(getInitials(
                                jsonDecode(_userData)['user']['name']
                                    ['first'])),
                          ),
                          Text(
                            jsonDecode(_userData)['user']['name']['first'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'helvetica',
                            ),
                          ),
                          Text('Administrador',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10))
                        ],
                      )),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.home,
                      ),
                      title:
                          Text('Inicio', style: TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.pushNamed(context, '/home');
//                        Navigator.pop(context);
                      },
                    ),
                    Divider(
                      height: 30,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.monetization_on,
                      ),
                      title: Text('Impuestos',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.pushNamed(context, '/impuestos');
                        // Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.attach_money,
                      ),
                      title: Text('Monedas',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.pushNamed(context, '/monedas');
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.dns,
                      ),
                      title: Text('Permisos',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.pushNamed(context, '/permisos');
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.list,
                      ),
                      title:
                          Text('Rubros', style: TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.pushNamed(context, '/rubros');
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.menu,
                      ),
                      title:
                          Text('Items', style: TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.pushNamed(context, '/items');
                      },
                    ),
                  ],
                ),
              ),
      );
    }
  }

  /// Create series list with one series
  List<charts.Series<LinearSales, String>> _fillMovementsChartData() {
    var reportData = jsonDecode(_movements.body);

    final data = [
      new LinearSales(
          'Oportunidades', reportData['movements']['opportunities'], '#7200ca'),
      new LinearSales(
          'Cotizaciones', reportData['movements']['budgets'], '#03d6f9'),
      new LinearSales(
          'Negocios', reportData['movements']['businesses'], '#34cc02'),
    ];

    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.name,
        measureFn: (LinearSales sales, _) => sales.sales,
        colorFn: (LinearSales sales, _) =>
            charts.Color.fromHex(code: sales.color),
        labelAccessorFn: (LinearSales row, _) => '${row.sales}',
        data: data,
      )
    ];
  }

  /// DATA DE EL GRAFICO DE MONEDAS
  List<charts.Series<LinearSales, String>> _fillCurrenciesChart() {
    var reportData = jsonDecode(_movements.body);

    final data = [
      new LinearSales('', 0, '#FFFFFF'),
    ];

    for (var dat in reportData['currencies']['movements'].keys) {
      data.add(new LinearSales(dat, reportData['currencies']['movements'][dat],
          '${generateRandomHexColor()}'));
    }

    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.name,
        measureFn: (LinearSales sales, _) => sales.sales,
        colorFn: (LinearSales sales, _) =>
            charts.Color.fromHex(code: sales.color),
        labelAccessorFn: (LinearSales row, _) => '${row.sales}',
        data: data,
      )
    ];
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<OrdinalSales, String>> _ordinalChartData() {
    var reportData = jsonDecode(_movements.body);

    final data = [
      new OrdinalSales('2018', 0),
    ];

    for (var dat in reportData['users']['byYear'].keys) {
      print('${dat}' + ' - ' + '${reportData['users']['byYear'][dat]}');
      data.add(new OrdinalSales(dat, reportData['users']['byYear'][dat]));
    }

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Users',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  //=======================
  //CARD DE MOVIMIENTOS
  //=======================

  Widget _MovementsCard() {
    final size = MediaQuery.of(context).size;

    if (_userData == null || _movements == null) {
      return Container();
    } else {
      return Container(
        width: size.width > 600 ? size.width * 0.3 : size.width,
        padding: EdgeInsets.only(top: 10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10.0),
              Text(
                _movements != null
                    ? '${jsonDecode(_movements.body)['movements']['total']} - Movimientos del sistema'
                    : '',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Divider(),
              Expanded(
                child: SimpleDatumLegend(_fillMovementsChartData()),
              ),
              Center(),
              SizedBox(height: 20.0),
              ButtonBar(
                children: <Widget>[],
              ),
            ],
          ),
        ),
      );
    }
  }

  //=======================
  //CARD DE USUARIOS
  //=======================

  Widget _UsersCard() {
    final size = MediaQuery.of(context).size;

    if (_userData == null || _movements == null) {
      return Container();
    } else {
      return Container(
        width: size.width > 600 ? size.width * 0.3 : size.width,
        padding: EdgeInsets.only(top: 10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10.0),
              Text(
                _movements != null ? 'Ingreso de usuarios' : '',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Divider(),
              Expanded(
                child: SlidingViewportOnSelection(_ordinalChartData()),
              ),
              Center(),
              SizedBox(height: 20.0),
              ButtonBar(
                children: <Widget>[],
              ),
            ],
          ),
        ),
      );
    }
  }

  //=======================
//CARD DE MONEDAS
//=======================

  Widget _currenciesCard() {
    final size = MediaQuery.of(context).size;

    if (_movements == null) {
      return Container();
    } else {
      return Container(
        width: size.width > 600 ? size.width * 0.3 : size.width * 0.8,
        padding: EdgeInsets.only(top: 10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10.0),
              Text(
                _movements != null ? 'Monedas en uso' : '',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Divider(),
              Expanded(
                child: SimpleDatumLegend(_fillCurrenciesChart()),
              ),
              Center(),
              SizedBox(height: 20.0),
              ButtonBar(
                children: <Widget>[],
              ),
            ],
          ),
        ),
      );
    }
  }
}

/// Sample linear data type.
class LinearSales {
  final int sales;
  final String name;
  final String color;

  LinearSales(this.name, this.sales, this.color);
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

String getInitials(String name) {
  List n = name.split(' ');
  if (n.length > 1) {
    return n[0][0] + n[1][0];
  } else {
    return 'x' + 'x';
  }
}
