import 'dart:convert';
//import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:prueba/src/Pages/secciones.dart';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

class DataWorkTwo extends StatefulWidget {
  final _idtrabajo;
  final String _correo;
  final String _datos;
  DataWorkTwo(this._idtrabajo, this._correo, this._datos);

  @override
  _DataWorkTwoState createState() => _DataWorkTwoState();
}

class _DataWorkTwoState extends State<DataWorkTwo> {
  DateTime now = DateTime.now();
  File _file;

  Color _aprueba = Colors.red;

  double _humedadRelativa = 0;
  double _temperaturaAmbiental = 0;
  double _temperaturaPlaca = 0;
  double _puntoRocio = 0;
  double _rugosidad = 0;
  double _tem_punto = 0;
  double _espesorHumedad = 0;
  String _equipo = "";
  Widget _mostrar = Divider();
  String _fecha;
  int _aplica = 0;
  bool _espesor = false;
  String _observacion = "";
  Widget _mensaje = Container();

  @override
  void initState() {
    // TODO: implement initState
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
        AnimatedContainer(
          duration: Duration(seconds: 0),
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
                            "Sección: 2",
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, left: 5),
                              child: Text("Equipo:",
                                  style: TextStyle(height: 1, fontSize: 16)),
                            ),
                            Container(
                              width: 200,
                              height: 45,
                              child:
                                  SizedBox(width: 100, child: _inputEquipo()),
                            ),
                            Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, left: 5),
                              child: Text("Humedad relativa: ",
                                  style: TextStyle(height: 1, fontSize: 16)),
                            ),
                            Container(
                              width: 200,
                              height: 45,
                              child:
                                  SizedBox(width: 100, child: _inputHumedad()),
                            ),
                          ]),
                    ),
                    Container(
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
                  ],
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 5),
                  child: Text(
                    "Temperatura ambiental:                                                     ",
                    style: TextStyle(height: 1, fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: 300,
                  height: 45,
                  margin: EdgeInsets.only(right: 40),
                  child: _inputTempAmbiental(),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    "Temperatura placa:                                                     ",
                    style: TextStyle(height: 1, fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: 300,
                  height: 45,
                  margin: EdgeInsets.only(right: 40),
                  child: _inputTempPlaca(),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                  child: Row(
                    children: [
                      Text("Punto rocio : ",
                          style: TextStyle(height: 1, fontSize: 16)),
                      Text("${_puntoRocio.toStringAsFixed(2)}",
                          style: TextStyle(height: 1, fontSize: 16)),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Text("Temperatura placa - punto rocio : ",
                          style: TextStyle(height: 1, fontSize: 16)),
                      Text("${_tem_punto.toStringAsFixed(2)}",
                          style: TextStyle(height: 1, fontSize: 16))
                    ],
                  ),
                ),
                _buttonAplicar(),
                _mostrar,
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ElevatedButton(
                        //autofocus: ,
                        child: Text('Observación',
                            style: TextStyle(height: 1, fontSize: 16)),
                        onPressed: () => _mostrarComentarios(context),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100),
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

  Function _validar() {
    double _parte1, _parte2;

    _parte1 = pow((_humedadRelativa / 100), (1 / 8));
    _parte2 = _parte1 * (110 + _temperaturaAmbiental) - 110;
    _puntoRocio = _parte2;
    _tem_punto = _temperaturaPlaca - _puntoRocio;
    if (_tem_punto >= 4) {
      _aprueba = Colors.green;
      __mostrarEspesor(true);
      _aplica = 1;
    } else {
      _aprueba = Colors.red;
      __mostrarEspesor(false);
      _aplica = 0;
    }
  }

  _inputHumedad() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onChanged: (e) {
        if (e == "") {
          setState(() {
            _aprueba = Colors.red;
            _mensaje = Container();
          });
          return;
        }
        setState(() {
          _humedadRelativa = double.parse(e);
          _mensaje = Container();
          _validar();
        });
      },
    );
  }

  _inputTempPlaca() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onChanged: (e) {
        if (e == "") {
          setState(() {
            _aprueba = Colors.red;
            _mensaje = Container();
          });
          return;
        }
        setState(() {
          _temperaturaPlaca = double.parse(e);
          _validar();
          _mensaje = Container();
        });
      },
    );
  }

  _inputTempAmbiental() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onChanged: (e) {
        if (e == "") {
          setState(() {
            _aprueba = Colors.red;
            _mensaje = Container();
          });
          return;
        }

        setState(() {
          _temperaturaAmbiental = double.parse(e);
          _validar();
          _mensaje = Container();
        });
      },
    );
  }

  _inputEquipo() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onChanged: (e) {
        if (e == "") {
          setState(() {
            _aprueba = Colors.red;
          });
          return;
        }
        setState(() => _equipo = e);
      },
    );
  }

  _inputEspesor() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onChanged: (e) {
        setState(
            () => {_espesorHumedad = double.parse(e), _mensaje = Container()});
      },
    );
  }

  __mostrarEspesor(val) {
    if (val) {
      setState(() {
        _mostrar = Column(
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                "Espesor en humedad                                                     ",
                style: TextStyle(height: 1, fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 300,
              height: 45,
              margin: EdgeInsets.only(right: 40),
              child: _inputEspesor(),
            ),
            Divider(),
          ],
        );
      });
    } else {
      setState(() {
        _mostrar = Divider();
      });
    }
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

  _buttonAplicar() {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: _aprueba, primary: Colors.white),
        onPressed: () {},
        child: Text("Se puede Aplicar el producto",
            style: TextStyle(height: 1, fontSize: 16)));
  }

  _buttonGuardar() {
    return ElevatedButton(
        onPressed: () {
          if (_equipo != "" &&
              _humedadRelativa != "" &&
              _temperaturaAmbiental != "" &&
              _temperaturaPlaca != "" &&
              _file != null) {
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
    PickedFile pinture = await ImagePicker().getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 900);

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
        'humedadRelativa': _humedadRelativa.toString(),
        'temperaturaAmbiental': _temperaturaAmbiental.toString(),
        'temperaturaPlaca': _temperaturaPlaca.toString(),
        'puntoRocio': _puntoRocio.toString(),
        'Aplica': _aplica.toString(),
        'datoAplica': _tem_punto.toString(),
        'espesor': _espesorHumedad.toString(),
        'observacion': _observacion.toString(),
        'image': base64Image,
        'nameImage': fileName
      };
      var url = Uri.parse("http://192.168.1.11:3000/seccion2");
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
