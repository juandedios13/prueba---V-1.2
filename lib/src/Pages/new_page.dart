import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prueba/src/Pages/seccion1.dart';
import 'package:http/http.dart' as http;
import 'package:prueba/src/Pages/secciones.dart';

class NewWork extends StatefulWidget {
  final String _correo;
  final String _datos;
  NewWork(this._correo, this._datos);

  @override
  _NewWorkState createState() => _NewWorkState();
}

class _NewWorkState extends State<NewWork> {
  DateTime now = DateTime.now();
  String _fecha = "";
  String _ubicacion = "";
  String _codigo = "";
  String _dropdownValue = "Linea de tuberia";
  String _codigoTrabajo = "";
  String _otroTrabajo = "";
  Widget _otro = Divider();
  var _datos;
  double heigth = 420;
  double margin_container = 30;
  Widget mensaje = Container();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fecha = "${now.year}-${now.month}-${now.day}";
    _datos = jsonDecode(widget._datos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nuevo trabajo"),
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
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 15, right: 15, bottom: 5),
              child: _cardTipo2(context),
            ),
            // Text("${_ubicacion}"),
            // ElevatedButton(
            //    onPressed: () {
            //      _ubicacio();
            ///    },
            //    child: Text("aqui"))
          ],
        ));
  }

  Widget _cardTipo2(context) {
    return AnimatedContainer(
        duration: Duration(seconds: 0),
        margin: EdgeInsets.only(top: margin_container),
        width: 350,
        height: heigth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                //offset: Offset(2.0, 10.0)
              )
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Fecha: ", style: TextStyle(height: 1, fontSize: 16)),
                  Padding(
                      padding: EdgeInsets.only(
                        left: 87,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 150,
                        height: 40,
                        padding: EdgeInsets.only(top: 12, left: 5),
                        child: Text(
                          _fecha,
                          style: TextStyle(height: 1, fontSize: 16),
                        ),
                      ))
                ],
              ),
              Divider(),
              Row(
                children: [
                  Text("Codigo: ", style: TextStyle(height: 1, fontSize: 16)),
                  Padding(
                    padding: EdgeInsets.only(left: 80),
                    child: Container(
                      width: 150,
                      height: 40,
                      child: SizedBox(width: 100, child: _inputCodigo()),
                    ),
                  )
                ],
              ),
              Divider(),
              Row(
                children: [
                  Text("Tipo de trabajo: ",
                      style: TextStyle(height: 1, fontSize: 16)),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Container(
                      width: 150,
                      height: 40,
                      child: SizedBox(
                          width: 100, child: _input_dropdownButton(context)),
                    ),
                  )
                ],
              ),
              _otro,
              Row(
                children: [
                  Text("Codigo de trabajo: ",
                      style: TextStyle(height: 1, fontSize: 16)),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Container(
                      width: 150,
                      height: 40,
                      child: SizedBox(width: 100, child: _inputCodigoTrabajo()),
                    ),
                  )
                ],
              ),
              Divider(),
              Row(
                children: [
                  Text("Ubicación: ",
                      style: TextStyle(height: 1, fontSize: 16)),
                  Padding(
                    padding: EdgeInsets.only(left: 62),
                    child: Container(
                      width: 150,
                      height: 40,
                      child: SizedBox(width: 100, child: _buttonGps()),
                    ),
                  )
                ],
              ),

              Padding(
                padding: EdgeInsets.only(left: 50, right: 50, top: 30),
                child: _buttonGuardar(),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 50, right: 50, top: 10),
                  child: mensaje)

              //_mostrarMapa(context),
            ],
          ),
        ));
  }

  void _ubicacio() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    setState(() {
      _ubicacion = "${position.latitude},${position.longitude} ";
    });
  }

  _inputCodigo() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: (e) {
        setState(() {
          _codigo = e;
          mensaje = Container();
          if (_dropdownValue != 'Otro') {
            heigth = 420;
          } else {
            heigth = 470;
          }
        });
      },
    );
  }

  _inputCodigoTrabajo() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: (e) {
        setState(() {
          _codigoTrabajo = e;
          mensaje = Container();
          if (_dropdownValue != 'Otro') {
            heigth = 420;
          } else {
            heigth = 470;
          }
        });
      },
    );
  }

  _inputOtroTrabajo() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: (e) {
        setState(() {
          _otroTrabajo = e;
          mensaje = Container();
          if (_dropdownValue != 'Otro') {
            heigth = 420;
          } else {
            heigth = 470;
          }
        });
      },
    );
  }

  _input_dropdownButton(context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: DropdownButton<String>(
          value: _dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 1,
          style: const TextStyle(color: Colors.black),
          onChanged: (String newValue) {
            setState(() {
              _dropdownValue = newValue;
              _otroTrabajo = newValue;
              mensaje = Container();
              if (_dropdownValue == "Otro") {
                setState(() {
                  heigth = 470;
                  margin_container = 10;
                });
                _otro = Column(
                  children: [
                    Divider(),
                    Row(
                      children: [
                        Text("Otro: ",
                            style: TextStyle(height: 1, fontSize: 16)),
                        Padding(
                          padding: EdgeInsets.only(left: 102),
                          child: Container(
                            width: 150,
                            height: 40,
                            child: SizedBox(
                                width: 100, child: _inputOtroTrabajo()),
                          ),
                        )
                      ],
                    ),
                    Divider()
                  ],
                );
              } else {
                _otro = Divider();
                setState(() {
                  heigth = 420;
                  margin_container = 30;
                });
              }
            });
          },
          items: <String>['Linea de tuberia', 'Plataforma', 'Otro']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  _buttonGps() {
    return ElevatedButton(
        child: Text("Mostrar Ubicacion"),
        onPressed: () => {_ubicacio(), _mostrarMapa(context)});
  }

  _buttonGuardar() {
    return Container(
      width: 120,
      child: ElevatedButton(
          child: Text("Guadar"),
          onPressed: () {
            if (_codigo != "" &&
                _otroTrabajo != "" &&
                _codigoTrabajo != "" &&
                _ubicacion != "") {
              _enviardatos();
            } else {
              setState(() {
                mensaje = Text("Por favor llenar todos los campos",
                    style: TextStyle(
                      color: Colors.red,
                      height: 1,
                      fontSize: 14,
                    ));
                heigth = 450;
              });
            }
          }),
    );
  }

  _mostrarMapa(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Ubicacion', style: TextStyle(height: 1, fontSize: 16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        )
                      ]),
                  child: Text("${_ubicacion}"),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => {Navigator.of(context).pop()},
                  child: Text('Guardar'))
            ],
          );
        });
  }

  Future<String> _enviardatos() async {
    var id = _datos['idSupervisor'];
    print(_datos);
    var url = Uri.parse("http://192.168.101.11:3000/guardartrabajo");
    final respuesta = await http.post(url, body: {
      'idSupervisor': id.toString(),
      'codigoLibre': _codigo,
      'tipoTrabajo': _otroTrabajo,
      'fecha': _fecha,
      'codigoTrabajo': _codigoTrabajo,
      'ubicacion': _ubicacion,
      'completado': '0'
    });

    if (respuesta.statusCode == 200) {
      final json = jsonDecode(respuesta.body);
      print(json.length);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Secciones(
                  json['idTrabajo'].toString(),
                  widget._correo,
                  widget._datos)));
    } else {
      setState(() {
        mensaje = Text(
            "no se pudo conectar con el servidor, por favor intentar mas tarde",
            style: TextStyle(
              color: Colors.red,
              height: 1,
              fontSize: 14,
            ));
        heigth = 450;
      });
    }
  }
}
