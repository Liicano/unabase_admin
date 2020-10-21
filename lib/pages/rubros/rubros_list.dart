import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:unabase_admin/services/rubros/rubros_get.dart';
import 'package:unabase_admin/services/rubros/rubros_post.dart';
import 'package:unabase_admin/services/rubros/rubros_put.dart';

class RubrosList extends StatefulWidget {
  RubrosList({Key key}) : super(key: key);

  @override
  _RubrosListState createState() => _RubrosListState();
}

class _RubrosListState extends State<RubrosList> {
  var _rubros = [];

  @override
  void initState() {
    super.initState();
    _readRubros();
  }

  //BUSCAR LOS IMPUESTOS
  _readRubros() async {
    _rubros = await getAllRubros();
    print(_rubros);
    setState(() {});
  }

  /*AGREGAR RUBRO A LA LISTA*/
  void _addItemToList(resp) {
    print('_addItemToList');
    _rubros.add(resp);
    setState(() {});
  }

  void _desactivateRubro(resp) {
    print('_desactivateRubro');

    int curIndex = _rubros.indexWhere((r) => r['_id'] == resp);
    print(curIndex);
    _rubros.removeAt(curIndex);
    setState(() {});
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rubros'),
      ),
      body: Container(
        child: Center(
            child: _rubros == null
                ? CircularProgressIndicator()
                : Container(
                    child: GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: size.width > 600 ? 3 : 1,
                      childAspectRatio: size.width > 600 ? 5 : 5,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(_rubros.length, (index) {
                        return _listItem(
                            context, _rubros[index], _desactivateRubro);
                      }),
                    ),
                  )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5.0,
        icon: const Icon(Icons.add),
        label: const Text('NUEVO RUBRO'),
        onPressed: () {
          /*_showBottomSheetCrearMoneda(context, _currencies, _addItemToList);*/
          _showBottomSheetCrearRubro(context, _rubros, _addItemToList);
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

//CARDS (ITEMS) DEL LISTADO DE RUBROS
Widget _listItem(context, rubro, _desactivateRubro) {
  final size = MediaQuery.of(context).size;

  return Container(
    width: size.width > 600 ? 100 : size.width * 0.9,
    child: Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.group,
            color: Colors.white,
          ),
        ),
        title: Text(rubro['name']),
        subtitle: Text(rubro['isActive'] ? 'Activo' : 'Inactivo'),
        trailing: Container(
          child: Ink(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: Icon(Icons.close),
              color: Colors.redAccent,
              onPressed: () {
                /*Navigator.pop(context);*/

                _showalertConfirm(
                    context, _showAlert, _desactivateRubro, rubro);
              },
            ),
          ),
        ),
        isThreeLine: true,
        onTap: () {
          print(rubro);
          /*   _showBottomSheetEditTax(
              context, currency, _setCurrencyState, _deleteCurrencyState);*/
        },
      ),
    ),
  );
}

//BOTTOM SHEET CREAR RUBRO
void _showBottomSheetCrearRubro(context, rubros, _addItemToList) {
  var _rubroScope = {"name": '', "isActive": true};

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
                        child: Text('GUARDAR RUBRO'),
                        highlightedBorderColor: Colors.green,
                        textColor: Colors.green,
                        color: Colors.green,
                        onPressed: () async {
                          var resp = await postNewRubro(_rubroScope);

                          if (resp != null) {
                            _addItemToList(resp);
                            Navigator.pop(context);
                            _showAlert(context, 'Felicitaciones!',
                                'Rubro creado con exito.');
                          }
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        _rubroScope['name'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre',
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

/*ALERTA*/
void _showAlert(BuildContext context, titulo, subtitulo) {
  SweetAlert.show(context,
      title: titulo, subtitle: subtitulo, style: SweetAlertStyle.success);
}

/*ALERTA DE CONFIRMACION*/
void _showalertConfirm(
    BuildContext context, _showAlert, _desactivateRubro, rubro) {
  SweetAlert.show(context,
      title: "¿Estas seguro?",
      subtitle: "El rubro se desactivara",
      style: SweetAlertStyle.confirm,
      showCancelButton: true,
      cancelButtonText: 'CANCELAR',
      confirmButtonText: 'DESACTIVAR', onPress: (isConfirm) {
    if (isConfirm) {
      var r = {"name": rubro['name'], "isActive": false, "_id": rubro['_id']};
      putRubro(r).then((resp) {
        print(resp);
        _desactivateRubro(rubro['_id']);
        Navigator.pop(context);
        /* showAlert(context, 'Exito!', 'Rubro deshabilitado con exito');*/
      });

      return false;
    }
  });
}
