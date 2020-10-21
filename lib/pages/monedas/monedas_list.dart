import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:unabase_admin/services/monedas/monedas_delete.dart';
import 'package:unabase_admin/services/monedas/monedas_get.dart';
import 'package:unabase_admin/services/monedas/monedas_post.dart';
import 'package:unabase_admin/services/monedas/monedas_put.dart';

class MonedasList extends StatefulWidget {
  MonedasList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MonedasListState createState() => _MonedasListState();
}

class _MonedasListState extends State<MonedasList> {
  var _currencies;

  @override
  void initState() {
    super.initState();
    _readCurrencies();
  }

  void _addItemToList(resp) {
    print('_addItemToList');
    _currencies.add(resp);
    setState(() {});
  }

//  ACTUALIZAR MONEDA
  void _setCurrencyState(resp) {
    print('_setCurrencyState');
    int taxIndex = _currencies.indexWhere((cur) => cur['_id'] == resp['_id']);
    _currencies[taxIndex] = resp;
    setState(() {});
  }

  void _deleteCurrencyState(resp) {
    print('_deleteCurrencyState');

    int curIndex = _currencies.indexWhere((tax) => tax['_id'] == resp);
    print(curIndex);
    _currencies.removeAt(curIndex);
    setState(() {});
  }

  //BUSCAR LOS IMPUESTOS
  _readCurrencies() async {
    _currencies = await getAllCurrencies();
    print(_currencies);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
            child: _currencies == null
                ? CircularProgressIndicator()
                : Container(
                    child: GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: size.width > 600 ? 3 : 1,
                      childAspectRatio: size.width > 600 ? 5 : 5,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(_currencies.length, (index) {
                        return _listItem(
                            context,
                            '${_currencies[index]['name']}',
                            '${_currencies[index]['prefix']}',
                            '${_currencies[index]['thousand']}',
                            '${_currencies[index]['decimal']}',
                            _currencies[index],
                            _setCurrencyState,
                            _deleteCurrencyState);
                      }),
                    ),
                  )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5.0,
        icon: const Icon(Icons.add),
        label: const Text('NUEVA MONEDA'),
        onPressed: () {
          _showBottomSheetCrearMoneda(context, _currencies, _addItemToList);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

//CARDS (ITEMS) DEL LSITADO DE MONEDAS
Widget _listItem(context, name, prefix, separador_miles, separador_decimal,
    currency, _setCurrencyState, _deleteCurrencyState) {
  final size = MediaQuery.of(context).size;

  return Container(
    width: size.width > 600 ? 100 : size.width * 0.9,
    child: Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.attach_money,
            color: Colors.white,
          ),
        ),
        title: Text('${name}'),
        subtitle: Text(
            '${prefix} -  MILES: (${separador_miles}) - DECIMALES: (${separador_decimal})'),
        isThreeLine: true,
        onTap: () {
          print(currency);
          _showBottomSheetEditTax(
              context, currency, _setCurrencyState, _deleteCurrencyState);
        },
      ),
    ),
  );
}

//BOTTOM SHEET CREAR MONEDA
void _showBottomSheetCrearMoneda(context, currencies, _addItemToList) {
  var _currencyScope = {
    "name": '',
    "decimal": '',
    "thousand": '',
    "prefix": '',
    "precision": 2,
    "countryOrigin": ''
  };

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerRight,
                    child: OutlineButton(
                        child: Text('GUARDAR MONEDA'),
                        highlightedBorderColor: Colors.green,
                        textColor: Colors.green,
                        color: Colors.green,
                        onPressed: () async {
                          var resp = await postNewCurrency(_currencyScope);
                          if (resp != null) {
                            _addItemToList(resp);
                            Navigator.pop(context);
                            _showAlert(context, 'Felicitaciones!',
                                'Moneda creada con exito.');
                          }
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        _currencyScope['name'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        _currencyScope['countryOrigin'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pais',
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        _currencyScope['prefix'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Prefijo - Ej: USD',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        _currencyScope['decimal'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Separador de decimales Ej: ,',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        _currencyScope['thousand'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Separador de miles Ej: .',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        _currencyScope['precision'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Precisiòn de decimales Ej: 0.00',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      });
}

//BOTTOM SHEET DE EDITAR MONEDA
void _showBottomSheetEditTax(
    context, currency, _setCurrencyState, _deleteCurrencyState) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                child: new Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      OutlineButton(
                          child: Text('ELIMINAR'),
                          highlightedBorderColor: Colors.redAccent,
                          textColor: Colors.redAccent,
                          color: Colors.redAccent,
                          onPressed: () {
                            Navigator.pop(context);

                            _showalertConfirm(context, _showAlert,
                                _deleteCurrencyState, deleteCurrency, currency);
                          }),
                      OutlineButton(
                          child: Text('GUARDAR CAMBIOS'),
                          highlightedBorderColor: Colors.green,
                          textColor: Colors.green,
                          color: Colors.green,
                          onPressed: () async {
                            print(currency);
                            var resp = await putCurrency(currency);

                            if (resp != null) {
                              print(resp);
                              _setCurrencyState(resp);
                              Navigator.pop(context);
                              _showAlert(context, 'Felicitaciones!',
                                  'Moneda actualizada con exito.');
                            }
                          }),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      currency['name'] = value;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: currency['name'],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      currency['countryOrigin'] = value;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: currency['countryOrigin'],
                    ),
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      currency['prefix'] = value;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: currency['prefix'],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      currency['decimal'] = value;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: currency['decimal'],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      currency['thousand'] = value;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: currency['thousand'],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      currency['precision'] = value;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '${currency['precision']}',
                    ),
                  ),
                ),
              ],
            )),
          );
        });
      });
}

void _showAlert(BuildContext context, titulo, subtitulo) {
  SweetAlert.show(context,
      title: titulo, subtitle: subtitulo, style: SweetAlertStyle.success);
}

void _showalertConfirm(BuildContext context, _showAlert, _deleteCurrencyState,
    deleteCurrency, currency) {
  SweetAlert.show(context,
      title: "¿Estas seguro?",
      subtitle: "La moneda se eliminara.",
      style: SweetAlertStyle.confirm,
      showCancelButton: true,
      cancelButtonText: 'CANCELAR',
      confirmButtonText: 'ELIMINAR', onPress: (isConfirm) {
    if (isConfirm) {
      deleteCurrency(currency['_id']).then((resp) {
        if (resp['success'] == true) {
          _deleteCurrencyState(currency['_id']);
          _showAlert(context, 'Felicitaciones!', 'Moneda eliminado con exito');
        }
      });

      return false;
    }
  });
}
