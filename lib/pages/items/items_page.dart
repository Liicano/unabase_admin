import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:unabase_admin/services/items/items_get.dart';
import 'package:unabase_admin/services/items/items_post.dart';
import 'package:unabase_admin/services/items/items_put.dart';

class ItemsPage extends StatefulWidget {
  static const String routeName = '/items';

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  var _items = [];

  @override
  void initState() {
    super.initState();
    _readItems();
  }

  //BUSCAR LAS LINEAS
  _readItems() async {
    _items = await getAllItems();
    print(_items);
    setState(() {});
  }

  /*AGREGAR RUBRO A LA LISTA*/
  void _addItemToList(resp) {
    print('_addItemToList');
    _items.add(resp);
    setState(() {});
  }

  void _desactivateItem(resp) {
    print('_desactivateItem');

    int curIndex = _items.indexWhere((r) => r['_id'] == resp);
    print(curIndex);
    _items.removeAt(curIndex);
    setState(() {});
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
      ),
      body: Container(
        child: Center(
            child: _items == null
                ? CircularProgressIndicator()
                : Container(
                    child: GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: size.width > 600 ? 3 : 1,
                      childAspectRatio: size.width > 600 ? 5 : 5,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(_items.length, (index) {
                        return _listItem(
                            context, _items[index], _desactivateItem);
                      }),
                    ),
                  )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5.0,
        icon: const Icon(Icons.add),
        label: const Text('NUEVO ITEM'),
        onPressed: () {
          _showBottomSheetCrearItem(context, _items, _addItemToList);
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
Widget _listItem(context, item, _desactivateItem) {
  final size = MediaQuery.of(context).size;

  return Container(
    width: size.width > 600 ? 100 : size.width * 0.9,
    child: Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.brightness_1,
            color: Colors.white,
          ),
        ),
        title: Text(item['name']),
        subtitle: Text(''),
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
                // Navigator.pop(context);

                _showalertConfirm(context, _showAlert, _desactivateItem, item);
              },
            ),
          ),
        ),
        isThreeLine: true,
        onTap: () {
          print(item);
        },
      ),
    ),
  );
}

//BOTTOM SHEET CREAR RUBRO
void _showBottomSheetCrearItem(context, items, _addItemToList) {
  var _itemScope = {
    "name": '',
    "isActive": true,
    "verified": true,
    "global": [
      {
        "currency": '5e3dc88c7e0a6171a7ff0a18',
        "estimate": {
          "buy": {
            "isActive": false,
            "price": {"isActive": false, "number": 0},
            "min": {"number": 0, "percentage": 0, "isActive": false},
            "max": {"number": 0, "percentage": 0, "isActive": false}
          },
          "sell": {
            "isActive": false,
            "price": {"isActive": false, "number": 0},
            "min": {"number": 0, "percentage": 0, "isActive": false},
            "max": {"number": 0, "percentage": 0, "isActive": false}
          },
          "margin": {
            "isActive": false,
            "max": {"percentage": 0, "price": 0},
            "min": {"percentage": 0, "price": 0}
          }
        },
        "taxes": [],
        "index": null
      }
    ]
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
                        child: Text('GUARDAR ITEM'),
                        highlightedBorderColor: Colors.green,
                        textColor: Colors.green,
                        color: Colors.green,
                        onPressed: () async {
                          var resp = await postNewItem(_itemScope);

                          if (resp != null) {
                            _addItemToList(resp);
                            Navigator.pop(context);
                            _showAlert(context, 'Felicitaciones!',
                                'Item creado con exito.');
                          }
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        _itemScope['name'] = value;
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
    BuildContext context, _showAlert, _desactivateItem, item) {
  SweetAlert.show(context,
      title: "¿Estas seguro?",
      subtitle: "El item se desactivara",
      style: SweetAlertStyle.confirm,
      showCancelButton: true,
      cancelButtonText: 'CANCELAR',
      confirmButtonText: 'DESACTIVAR', onPress: (isConfirm) {
    if (isConfirm) {
      var r = {"name": item['name'], "isActive": false, "_id": item['_id']};
      putItem(r).then((resp) {
        print("----------------------------  > " + resp);
        _desactivateItem(item['_id']);
        Navigator.pop(context);
        _showAlert(context, 'Exito!', 'item deshabilitado con exito');
      });

      return false;
    }
  });
}
