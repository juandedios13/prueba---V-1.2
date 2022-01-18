import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prueba/src/Pages/new_page.dart';
import 'package:prueba/src/Pages/secciones.dart';

class Work_page extends StatefulWidget {
  final String _correo;
  final String _datos;

  Work_page(this._correo, this._datos);

  @override
  _Work_pageState createState() => _Work_pageState();
}

class _Work_pageState extends State<Work_page> {
  @override
  Future<List> _inf;
  String _idtrabajo = "";

  Future<List> _enviardatos() async {
    var url = Uri.parse("http://192.168.1.12:3000/trabajos-supervisor");

    final respuesta = await http.post(url, body: {"correo": widget._correo});

    List datos = [];

    if (respuesta.statusCode == 200) {
      final json = jsonDecode(respuesta.body);
      //print(json);
      List dato = [];
      for (var item in json) {
        dato = [];
        dato
          ..add(item['idTrabajo'])
          ..add(item['codigoLibre'])
          ..add(item['tipoTrabajo'])
          ..add(item['fecha'].substring(0, 10))
          ..add(item['codigoTrabajo'])
          ..add(item['ubicacion'])
          ..add(item['completado']);
        datos.add(dato);
      }
      return datos;
    }

    return datos;
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _inf = _enviardatos();

    ///print(_inf);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Trabajos"),
        actions: [
          Container(
            width: 50,
            margin: EdgeInsets.only(right: 5.0, top: 5, bottom: 5),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image(
                image: AssetImage('imagenes/icono.png'),
              ),
              radius: 20.0,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _inf,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print(snapshot.data);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                children: _listTrabajos(snapshot.data),
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.hasError);
            return Text("nel perro");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget Lista() {}

  List<Widget> _listTrabajos(datos) {
    List<Widget> widgets = [];

    widgets.add(new_datos());

    for (var item in datos) {
      //print("1" + item);
      widgets.add(Card(
        child: ElevatedButton(
          onPressed: () {
            _idtrabajo = item[0].toString();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Secciones(_idtrabajo, widget._correo, widget._datos)));
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            primary: Colors.black,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              paddin(texto("Fecha: ", Colors.black),
                  texto(item[3], Colors.black54)),
              paddin(texto("Codigo: ", Colors.black),
                  texto(item[1], Colors.black54)),
              paddin(texto("Tipo trabajo: ", Colors.black),
                  texto(item[2], Colors.black54)),
              paddin(texto("Codigo trabajo: ", Colors.black),
                  texto(item[4], Colors.black54)),
              paddin(texto("Ubicación: ", Colors.black),
                  texto(item[5], Colors.black54))
            ],
          ),
        ),
      ));
    }

    return widgets;
  }

  Widget new_datos() {
    return Card(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      NewWork(widget._correo, widget._datos)));
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          primary: Colors.black,
        ),
        child: Icon(
          Icons.add_circle_outline_outlined,
          size: 100,
        ),
      ),
    );
  }

  Text texto(dato, color) {
    return Text(dato, style: TextStyle(height: 1, fontSize: 16, color: color));
  }

  Padding paddin(hijo1, hijo2) {
    return Padding(
      padding: EdgeInsets.only(top: 7, left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hijo1,
          Padding(
            padding: EdgeInsets.only(left: 10, top: 2),
            child: hijo2,
          )
        ],
      ),
    );
  }
}
