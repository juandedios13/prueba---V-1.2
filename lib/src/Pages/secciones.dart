import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prueba/src/Pages/seccion1.dart';
import 'package:prueba/src/Pages/seccion2.dart';
import 'package:prueba/src/Pages/seccion3.dart';
import 'package:prueba/src/Pages/work.dart';

class Secciones extends StatefulWidget {
  final String _idtrabajo;
  final String _correo;
  final String _datos;

  Secciones(this._idtrabajo, this._correo, this._datos);

  @override
  _SeccionesState createState() => _SeccionesState();
}

class _SeccionesState extends State<Secciones> {
  Future<List> _inf;
  DateTime now = DateTime.now();
  String _fechaActual;

  Future<List> _enviardatos() async {
    var url = Uri.parse("http://192.168.1.12:3000/secciones");

    final respuesta =
        await http.post(url, body: {"idTrabajo": widget._idtrabajo});

    List datos = [];

    if (respuesta.statusCode == 200) {
      final json = jsonDecode(respuesta.body);
      // print("json");
      //print(json);
      for (var item in json) {
        datos
          ..add(item['seccion1'])
          ..add(item['seccion2'])
          ..add(item['seccion3']);
      }
      // print("datos");
      //print(datos);
      return datos;
    }

    return datos;
  }

  String dia;
  String mes;

  @override
  void initState() {
    // TODO: implement initState
    _inf = _enviardatos();

    mes = _validarFecha(now.month);
    dia = _validarFecha(now.day);

    _fechaActual = "${now.year}-${mes}-${dia}";
    super.initState();
  }

  _validarFecha(x) {
    var n;
    if (x < 10) {
      n = '0${x}';
    } else {
      n = '${x}';
    }
    return n;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Secciones"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Work_page(widget._correo, widget._datos)))
                  }),
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
        body: ListView(children: [
          FutureBuilder(
            future: _inf,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //print(snapshot.data);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: //[Text("")]

                      _listSecciones(snapshot.data),
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
        ]));
  }

  List<Widget> _listSecciones(data) {
    List<Widget> widgets = [];

    widgets.add(_seccion(data, 0, 's1'));
    widgets.add(_seccion(data, 1, 's2'));
    widgets.add(_seccion(data, 2, 's3'));

    return widgets;
  }

  _seccion(data, n, texto) {
    int N = n;
    String aplica = "";
    if (data[n][texto].length != 0) {
      dynamic lista = data[n][texto][0];
      if (lista['Aplica'] == 0) {
        aplica = "no";
      } else {
        aplica = "si";
      }
      return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                  //offset: Offset(2.0, 10.0)
                )
              ]),
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Sección: ",
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 16,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Fecha: ",
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 16,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Humedad relativa: ",
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 16,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Temperatura placa: ",
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 16,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Temperatura ambiental: ",
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 16,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Punto rocio: ",
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 16,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Aplicada: ",
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 16,
                                    color: Colors.black)),
                          ),
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(lista['seccion'].toString(),
                              style: TextStyle(height: 1, fontSize: 16)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                              lista['fecha'].toString().substring(0, 10),
                              style: TextStyle(height: 1, fontSize: 16)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(lista['humedadRelativa'].toString(),
                              style: TextStyle(height: 1, fontSize: 16)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(lista['temperaturaAmbiental'].toString(),
                              style: TextStyle(height: 1, fontSize: 16)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(lista['temperaturaPlaca'].toString(),
                              style: TextStyle(height: 1, fontSize: 16)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(lista['puntoRocio'].toString(),
                              style: TextStyle(height: 1, fontSize: 16)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(aplica,
                              style: TextStyle(height: 1, fontSize: 16)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ));
    } else {
      return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                //offset: Offset(2.0, 10.0)
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("seccion: ${++n}",
                style: TextStyle(height: 1, fontSize: 16, color: Colors.black)),
            _ruta(N, data)
          ],
        ),
      );
    }
  }

  _ruta(n, data) {
    Widget hijo;
    int N = n;
    if (n == 0) {
      hijo = botonEntrar(
          DataWorkOne(widget._idtrabajo, widget._correo, widget._datos));
    } else if (n == 1) {
      if (data[0]['s1'].length != 0) {
        if (data[0]['s1'][0]['Aplica'] == 1) {
          if (data[0]['s1'][0]['fecha'].toString().substring(0, 10) !=
              _fechaActual) {
            hijo = botonEntrar(
                DataWorkTwo(widget._idtrabajo, widget._correo, widget._datos));
          } else {
            hijo = Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                  "Por favor esperar el tiempo necesario para comenzar la seccion",
                  style: TextStyle(
                      height: 1, fontSize: 16, color: Colors.black87)),
            );
          }
        } else {
          hijo = Container(
            margin: EdgeInsets.only(top: 5),
            child: Text("No disponible, La primesa sección no aplico",
                style:
                    TextStyle(height: 1, fontSize: 16, color: Colors.black87)),
          );
        }
      } else {
        hijo = Container(
          margin: EdgeInsets.only(top: 5),
          child: Text("No disponible",
              style: TextStyle(height: 1, fontSize: 16, color: Colors.black87)),
        );
      }
    } else if (n == 2) {
      if (data[1]['s2'].length != 0) {
        if (data[1]['s2'][0]['Aplica'] == 1) {
          if (data[1]['s2'][0]['fecha'].toString().substring(0, 10) !=
              _fechaActual) {
            hijo = botonEntrar(DataWorkThree(
                widget._idtrabajo, widget._correo, widget._datos));
          } else {
            hijo = Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                  "Por favor esperar el tiempo necesario para comenzar la seccion",
                  style: TextStyle(
                      height: 1, fontSize: 16, color: Colors.black87)),
            );
          }
        } else {
          hijo = Container(
            margin: EdgeInsets.only(top: 5),
            child: Text("No disponible, La primesa sección no aplico",
                style:
                    TextStyle(height: 1, fontSize: 16, color: Colors.black87)),
          );
        }
      } else {
        hijo = Container(
          margin: EdgeInsets.only(top: 5),
          child: Text("No disponible",
              style: TextStyle(height: 1, fontSize: 16, color: Colors.black87)),
        );
      }
    }
    return Container(
      width: 300,
      child: hijo,
    );
  }

  ElevatedButton botonEntrar(ruta) {
    return ElevatedButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => ruta)),
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
          primary: Colors.black,
        ),
        child: Text("Entrar",
            style: TextStyle(height: 1, fontSize: 16, color: Colors.white)));
  }

  Text texto(dato, color) {
    return Text(dato, style: TextStyle(height: 1, fontSize: 16, color: color));
  }
}
