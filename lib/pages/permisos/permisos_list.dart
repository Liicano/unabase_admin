import "package:collection/collection.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:unabase_admin/services/permisos/permisos_get.dart';
import 'package:unabase_admin/services/permisos/permisos_post.dart';

class PermisosList extends StatefulWidget {
  final String title;
  PermisosList({Key key, this.title}) : super(key: key);

  @override
  _PermisosListState createState() => _PermisosListState();
}

class _PermisosListState extends State<PermisosList> {
  var _permissions;
  var _permissions_group = {};
  var _permissionsModules = [];
  var _permission = {};

  @override
  void initState() {
    super.initState();
    _readPermissions();
  }

//  AGREGAR PERMISO A LA LISTA
  void _addItemToList(resp) {
    print('_addItemToList');

    _permissions.add(resp);
    _groupPermissions();

    setState(() {});
  }

  //BUSCAR LOS PERMISOS
  _readPermissions() async {
    _permissions = await getAllPermissions();
    print(_permissions);
    _groupPermissions();

    setState(() {});
  }

  //BUSCAR LOS PERMISOS
  _groupPermissions() {
    // _permissions_group = {};
    _permissions_group = groupBy(_permissions, (obj) => obj['module']);
    _setPermissionsModules();

    setState(() {});
  }

//  CREA UN ARRAY CON LOS NOMBRES DE LOS MODULOS
  _setPermissionsModules() {
    _permissionsModules = [];

    _permissions_group.keys.forEach(
        (k) => k != null ? _permissionsModules.add(k) : print('isNull'));
    print(_permissionsModules);

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
            child: _permissions == null
                ? CircularProgressIndicator()
                : Container(
                    child: GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: size.width > 600 ? 3 : 2,
                      childAspectRatio: size.width > 600 ? 5 : 2,

                      children: new List<Widget>.generate(
                          _permissionsModules.length, (index) {
                        return _listItem(context, _permissionsModules[index],
                            _permissions_group);
                      }),
                    ),
                  )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5.0,
        icon: const Icon(Icons.add),
        label: const Text('NUEVO PERMISO'),
        onPressed: () {
          _settingModalBottomSheet(context, _permission, _addItemToList);
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
Widget _listItem(context, moduleName, _permissionsGroup) {
  final size = MediaQuery.of(context).size;

  return Container(
    width: size.width > 600 ? 100 : size.width * 0.9,
    child: Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Text(
            moduleName[0] + moduleName[1],
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(moduleName, style: TextStyle(fontSize: 18)),
        subtitle: Text(''),
        isThreeLine: true,
        onTap: () {
          print(_permissionsGroup[moduleName]);

          Navigator.pushNamed(context, '/verPermisosDelModulo', arguments: {
            "permissions": _permissionsGroup[moduleName],
            "permissionsModule": moduleName,
            "title": 'Permisos'
          });

          /* print(currency);
          _showBottomSheetEditTax(
              context, currency, _setCurrencyState, _deleteCurrencyState);*/
        },
      ),
    ),
  );
}

//BOTTOM SHEET CREAR PERMISO
void _settingModalBottomSheet(context, permission, _addItemToList) {
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
                        child: Text('GUARDAR PERMISO'),
                        highlightedBorderColor: Colors.green,
                        textColor: Colors.green,
                        color: Colors.green,
                        onPressed: () async {
                          var resp = await postNewPermission(permission);

                          if (resp != null) {
                            print(resp);

                            _addItemToList(resp);
                            Navigator.pop(context);
                            _showAlert(context, 'Felicitaciones!',
                                'Permiso creado con exito.');
                          }
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        permission['name'] = value;
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
                      maxLines: 2,
                      onChanged: (value) {
                        permission['description'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descripciòn',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        permission['action'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Accion del permiso',
                          helperText: 'Ej: read, create, delete, update'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        permission['type'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Permiso del cliente o en la api',
                          helperText: 'Ej: internal, external'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        permission['module'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Modulo donde aplica el permiso',
                          helperText: 'Ej: movement, item, line, etc...'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        permission['path'] = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ruta para aplicar permiso',
                          helperText: 'Ej: item.movement'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      });
}

void _showAlert(BuildContext context, titulo, subtitulo) {
  SweetAlert.show(context,
      title: titulo, subtitle: subtitulo, style: SweetAlertStyle.success);
}
