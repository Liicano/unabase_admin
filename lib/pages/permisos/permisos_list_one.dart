import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:unabase_admin/services/permisos/permisos_put.dart';

class PermisosListOne extends StatefulWidget {
  final permissions;
  final permissionsModule;
  final title;

  PermisosListOne(
      {Key key, this.permissions, this.permissionsModule, this.title})
      : super(key: key);

  @override
  _PermisosListOneState createState() => _PermisosListOneState();
}

class _PermisosListOneState extends State<PermisosListOne> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    //  ACTUALIZAR PERMISO
    void _setPermissionState(resp) {
      print('_setPermissionState');
      int taxIndex =
          arguments['permissions'].indexWhere((p) => p['_id'] == resp['_id']);
      arguments['permissions'][taxIndex] = resp;
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(arguments['title'] + ' - ' + arguments['permissionsModule']),
      ),
      body: Container(
        child: Center(
            child: arguments['permissions'] == null
                ? CircularProgressIndicator()
                : Container(
                    child: GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: size.width > 600 ? 3 : 1,
                      childAspectRatio: size.width > 600 ? 5 : 5,

                      children: new List<Widget>.generate(
                          arguments['permissions'].length, (index) {
                        return _listItem(
                            context,
                            arguments['permissions'][index],
                            _setPermissionState);
                      }),
                    ),
                  )),
      ),
    );
  }
}

//CARDS (ITEMS) DEL LSITADO DE MONEDAS
Widget _listItem(context, permission, _setPermissionState) {
  final size = MediaQuery.of(context).size;

  return Container(
    width: size.width > 600 ? 100 : size.width * 0.9,
    child: Card(
      child: ListTile(
        title: Text(' - ' + permission['name'], style: TextStyle(fontSize: 18)),
        subtitle: Text(permission['description']),
        isThreeLine: true,
        onTap: () {
          print(permission);
          _editPermissionBottomSheet(context, permission, _setPermissionState);
          /* print(currency);
          _showBottomSheetEditTax(
              context, currency, _setCurrencyState, _deleteCurrencyState);*/
        },
      ),
    ),
  );
}

//BOTTOM SHEET CREAR PERMISO
void _editPermissionBottomSheet(context, permission, _setPermissionState) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      OutlineButton(
                          child: Text('GUARDAR CAMBIOS'),
                          highlightedBorderColor: Colors.green,
                          textColor: Colors.green,
                          color: Colors.green,
                          onPressed: () async {
                            var resp = await putPermission(permission);
                            if (resp != null) {
                              print(resp);
                              _setPermissionState(resp);
                              Navigator.pop(context);
                              _showAlert(context, 'Felicitaciones!',
                                  'Permiso actualizado con exito.');
                            }
                          }),
                    ],
                  ),
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
                      labelText: permission['name'],
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
                      labelText: permission['description'],
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
                        labelText: permission['action'],
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
                        labelText: permission['type'],
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
                        labelText: permission['module'],
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
                        labelText: permission['path'],
                        helperText: 'Ej: item.movement'),
                  ),
                ),
              ],
            ),
          ));
        });
      });
}

void _showAlert(BuildContext context, titulo, subtitulo) {
  SweetAlert.show(context,
      title: titulo, subtitle: subtitulo, style: SweetAlertStyle.success);
}
