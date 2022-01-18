import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba/src/Pages/secciones.dart';

class DataWorkThree extends StatefulWidget {
  final _idtrabajo;
  final String _correo;
  final String _datos;
  DataWorkThree(this._idtrabajo, this._correo, this._datos);

  @override
  _DataWorkThreeState createState() => _DataWorkThreeState();
}

class _DataWorkThreeState extends State<DataWorkThree> {
  DateTime now = DateTime.now();
  File _file;
  String _equipo = "";
  String _observacion = "";
  String _fecha;
  Widget _mensaje = Container();

  @override
  void initState() {
    super.initState();
    _fecha = "${now.year}-${now.month}-${now.day}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Datos del trabajo"),
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
        Container(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Sección: 3",
                            style: TextStyle(height: 1, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Text("Fecha: ",
                              style: TextStyle(height: 1, fontSize: 16)),
                        ),
                        Text(_fecha, style: TextStyle(height: 1, fontSize: 16))
                      ],
                    )),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    "Equipo:                                                     ",
                    style: TextStyle(height: 1, fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: 300,
                  height: 45,
                  margin: EdgeInsets.only(right: 40),
                  child: _inputEquipo(),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                      "Observación:                                                                      ",
                      style: TextStyle(height: 1, fontSize: 16)),
                ),
                Container(
                    width: 300,
                    height: 45,
                    margin: EdgeInsets.only(right: 40),
                    child: TextFormField(
                      maxLength: 200,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      onChanged: (e) {
                        setState(() {
                          _mensaje = Container();
                          _observacion = e.toString();
                        });
                      },
                    )),
                Divider(),
                Container(
                    padding: EdgeInsets.only(top: 10),
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            //offset: Offset(2.0, 10.0)
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              Container(
                                  child: _file == null
                                      ? Text("Tomar foto",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              height: 1, fontSize: 16))
                                      : SizedBox(
                                          width: 100,
                                          child: Image.file(_file))),
                              Center(
                                child: ElevatedButton(
                                    onPressed: _tomarFoto,
                                    child: Icon(Icons.camera)),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
                Divider(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 125),
                      child: _buttonGuardar(),
                    )
                  ],
                ),
                _mensaje
              ],
            ),
          ),
        )
      ]),
    );
  }

  _inputEquipo() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onChanged: (e) {
        setState(() {
          _mensaje = Container();
          _equipo = e;
        });
      },
    );
  }

  _mostrarComentarios(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title:
                Text('Comentario', style: TextStyle(height: 1, fontSize: 16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (e) {
                    setState(() => _observacion = e);
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      _observacion = "";
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Guardar'))
            ],
          );
        });
  }

  _buttonGuardar() {
    return ElevatedButton(
        onPressed: () {
          if (_equipo != "" && _observacion != "" && _file != null) {
            _enviardatos();
          } else {
            setState(() {
              _mensaje = Container(
                margin: EdgeInsets.only(top: 10),
                child: Text("Por favor llenar todos los campos",
                    style: TextStyle(
                      color: Colors.red,
                      height: 1,
                      fontSize: 16,
                    )),
              );
            });
          }
        },
        child: Text("Guardar", style: TextStyle(height: 1, fontSize: 16)));
  }

  Future _tomarFoto() async {
    PickedFile pinture =
        await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      if (pinture != null) {
        _file = File(pinture.path);
      }
    });
  }

  Future _enviardatos() async {
    String base64Image = base64Encode(_file.readAsBytesSync());
    String fileName = _file.path.split("/").last;

    try {
      var data = {
        'idTrabajo': widget._idtrabajo.toString(),
        'equipo': _equipo,
        'fecha': _fecha.toString(),
        'observacion': _observacion.toString(),
        'image': base64Image,
        'nameImage': fileName
      };
      var url = Uri.parse("http://192.168.1.11:3000/seccion3");
      final respuesta = await http.post(url, body: data);
      //http.MultipartFile(url,_file)

      if (respuesta.statusCode == 200) {
        final json = respuesta.body;
        print("respuesta");
        print(json);
        if (json == "exitoso") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Secciones(
                      widget._idtrabajo, widget._correo, widget._datos)));
        } else {
          setState(() {
            _mensaje = Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(json,
                  style: TextStyle(
                    color: Colors.red,
                    height: 1,
                    fontSize: 16,
                  )),
            );
          });
        }
      } else {}
    } catch (e) {
      print(e);
    }
  }
}
