import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:unabase_admin/services/impuestos/impuestos_delete.dart';
import 'package:unabase_admin/services/impuestos/impuestos_get.dart';
import 'package:unabase_admin/services/impuestos/impuestos_post.dart';
import 'package:unabase_admin/services/impuestos/impuestos_put.dart';

class ImpuestosList extends StatefulWidget {
  ImpuestosList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ImpuestosList createState() => _ImpuestosList();
}

class _ImpuestosList extends State<ImpuestosList> {
  var _taxes;
  String _taxName;
  String _taxNumber;

  @override
  void initState() {
    super.initState();
    _readTaxes();
  }

  void _addItemToList(resp) {
    print('_addItemToList');
    _taxes.add(resp);
    setState(() {});
  }

  void _setTaxState(resp) {
    print('_setTaxState');
    int taxIndex = _taxes.indexWhere((tax) => tax['_id'] == resp['_id']);
    _taxes[taxIndex] = resp;
    setState(() {});
  }

  void _deleteTaxState(resp) {
    print('_deleteTaxState');

    int taxIndex = _taxes.indexWhere((tax) => tax['_id'] == resp);
    print(taxIndex);
    _taxes.removeAt(taxIndex);
    setState(() {});
  }

  //BUSCAR LOS IMPUESTOS
  _readTaxes() async {
    _taxes = await getAllTaxes();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (_taxes == null) {
      return new Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          width: size.width > 600 ? size.width * 0.3 : size.width,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFixedExtentList(
                itemExtent: 80.0,
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return _listItem(
                      context,
                      _taxes[index]['name'],
                      _taxes[index]['number'],
                      _taxes[index]['_id'],
                      _setTaxState,
                      _deleteTaxState);
                }, childCount: _taxes.length),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 5.0,
          icon: const Icon(Icons.add),
          label: const Text('NUEVO IMPUESTO'),
          onPressed: () {
            _settingModalBottomSheet(
                context, _taxName, _taxNumber, _addItemToList);
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
}

Widget _listItem(context, name, number, _id, _setTaxState, _deleteTaxState) {
  final size = MediaQuery.of(context).size;

  return Container(
    width: size.width > 600 ? 100 : size.width * 0.9,
    child: Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.attach_money),
        ),
        title: Text('${name}'),
        subtitle: Text('${number}%'),
        trailing: Icon(
          Icons.edit_location,
          color: Colors.grey,
        ),
        onTap: () {
          print('${_id}');
          _showBottomSheetEditTax(
              context, name, number, _id, _setTaxState, _deleteTaxState);
        },
      ),
    ),
  );
}

//BOTTOM SHEET CREAR IMPUESTO
void _settingModalBottomSheet(context, _taxName, _taxNumber, _addItemToList) {
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
                    child: OutlineButton(
                        child: Text('GUARDAR IMPUESTO'),
                        highlightedBorderColor: Colors.green,
                        textColor: Colors.green,
                        color: Colors.green,
                        onPressed: () async {
                          var resp = await postNewTax(
                              {"name": _taxName, "number": _taxNumber});

                          if (resp != null) {
                            _addItemToList(resp);
                            Navigator.pop(context);
                            _showAlert(context, 'Felicitaciones!',
                                'Impuesto creado con exito.');
                          }
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        _taxName = value;
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
                        _taxNumber = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Numero (%)',
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

//BOTTOM SHEET DE EDITAR IMPUESTO
void _showBottomSheetEditTax(
    context, _taxName, _taxNumber, _id, _setTaxState, _deleteTaxState) {
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
                                _deleteTaxState, deleteTax, _id);

                            /*var resp = await deleteTax({
                            "name": "${_taxName}",
                            "number": "${_taxNumber}",
                            "_id": "${_id}"
                          });

                          if (resp != null) {
                            Navigator.pop(context);

                            _showalertConfirm(
                                context, _showAlert, _deleteTaxState, _id);
                          }*/
                          }),
                      SizedBox(
                        width: 40.0,
                      ),
                      OutlineButton(
                          child: Text('GUARDAR CAMBIOS'),
                          highlightedBorderColor: Colors.green,
                          textColor: Colors.green,
                          color: Colors.green,
                          onPressed: () async {
                            var resp = await putTax({
                              "name": "${_taxName}",
                              "number": "${_taxNumber}",
                              "_id": "${_id}"
                            });

                            if (resp != null) {
                              print(resp);
                              _setTaxState(resp);
                              Navigator.pop(context);
                              _showAlert(context, 'Felicitaciones!',
                                  'Impuesto actualizado con exito.');
                            }
                          })
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      _taxName = value;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '${_taxName}',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      _taxNumber = value;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '${_taxNumber} (%)',
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
      title: "${titulo}",
      subtitle: "${subtitulo}",
      style: SweetAlertStyle.success);
}

void _showalertConfirm(
    BuildContext context, _showAlert, _deleteTaxState, deleteTax, _id) {
  SweetAlert.show(context,
      title: "¿Estas seguro?",
      subtitle: "El impuesto se eliminara.",
      style: SweetAlertStyle.confirm,
      showCancelButton: true,
      cancelButtonText: 'CANCELAR',
      confirmButtonText: 'ELIMINAR', onPress: (bool isConfirm) {
    if (isConfirm) {
      deleteTax(_id).then((resp) {
        if (resp['success'] == true) {
          _deleteTaxState(_id);
          _showAlert(
              context, 'Felicitaciones!', 'Impuesto eliminado con exito');
        }
      });

      // _deleteTaxState(_id);
      //_showAlert(context, 'Felicitaciones!', 'Impuesto eliminado con exito');

      return false;
    }
  });
}
