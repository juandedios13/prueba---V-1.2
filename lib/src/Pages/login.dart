import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:prueba/src/Pages/new_page.dart';
import 'package:prueba/src/Pages/work.dart';
import 'package:dio/dio.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _correo = "";
  String _contrasena = "";
  Container _progreso = Container(child: Text(""));

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    Size media = mediaquery.size;
    print(media.height.toString());
    return Scaffold(
        body: Container(
      color: Colors.blueAccent,
      child: ListView(
        children: [
          Center(
              child: Container(
                  margin: EdgeInsets.only(top: media.height * 0.15),
                  height: 450,
                  width: 300,
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
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Image(
                              image:
                                  AssetImage('imagenes/logo-con-color.png'))),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 40),
                        child: _inputUsuario(),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 30),
                        child: _inputPassword(),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 20),
                        child: _buttoLogin(),
                      ),
                      _progreso,
                    ],
                  ))),
        ],
      ),
    ));
  }

  _inputUsuario() {
    return TextField(
      //autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          labelText: 'Correo',
          icon: Icon(Icons.account_circle)),
      onChanged: (e) {
        setState(() {
          _correo = e;
          _progreso = Container(child: Text(""));
        });
      },
    );
  }

  _inputPassword() {
    return TextField(
      //autofocus: true,
      obscureText: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          labelText: 'Contraseña',
          icon: Icon(Icons.lock)),
      onChanged: (e) {
        setState(() {
          _contrasena = e;
          _progreso = Container(child: Text(""));
        });
      },
    );
  }

  _buttoLogin() {
    return ElevatedButton(
        child:
            Text("Iniciar sessión", style: TextStyle(height: 1, fontSize: 16)),
        onPressed: () {
          _progreso = Container(
              margin: EdgeInsets.only(top: 5),
              child: CircularProgressIndicator());
          _enviardatos();
        });
  }

  _datoserror(dato) {
    if (dato == "si") {
      return Container(child: CircularProgressIndicator());
    } else if (dato == "no") {}
  }

  Future _validar(json) async {
    var datos = jsonDecode(json);
    if (datos == false || datos == "false") {
      setState(() {
        _progreso = Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              "Datos incorrectos",
              style: TextStyle(color: Colors.red),
            ));
      });
    } else {
      if (datos['token']) {
        datos = jsonEncode(datos);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Work_page(_correo, datos)));
      } else {
        setState(() {
          _progreso = Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                "Datos incorrectos",
                style: TextStyle(color: Colors.red),
              ));
        });
      }
    }
  }

  Future<String> _enviardatos() async {
    setState(() {
      _progreso = Container(
          margin: EdgeInsets.only(top: 5), child: CircularProgressIndicator());
    });
    print("entro");
    var url = Uri.http('192.168.1.12:3000', '/login-supervisor');
    print(url);
    //parse("http://192.168.101.11:3000/login-supervisor");
    var client = http.Client();
    try {
      //final respuesta = await client.get(url);
      final respuesta = await client
          .post(url, body: {"correo": _correo, "contrasena": _contrasena});
      print(respuesta.statusCode);
      if (respuesta.statusCode == 200) {
        final json = respuesta.body;
        _validar(json);
      } else {
        print("entro");
        setState(() {
          _progreso = Container(
              margin: EdgeInsets.only(top: 5),
              child: Text("Fallida conexión con el servidor",
                  style: TextStyle(color: Colors.red)));
        });
      }
    } on Error catch (e) {
      _progreso = Container(
          margin: EdgeInsets.only(top: 5),
          child: Text("Fallida conexión con el servidor",
              style: TextStyle(color: Colors.red)));
    } catch (e) {
      _progreso = Container(
          margin: EdgeInsets.only(top: 5),
          child: Text("Fallida conexión con el servidor",
              style: TextStyle(color: Colors.red)));
      client.close();
    }
  }
}
