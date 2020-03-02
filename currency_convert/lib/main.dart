import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=59c7c755&format=json";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final brlController = TextEditingController();
  final usdController = TextEditingController();
  final eurController = TextEditingController();

  double euro;
  double dollar;

  void _clearAll(){
    brlController.text = "";
    usdController.text = "";
    eurController.text = "";
  }

  void _brlChanged(String value) {
    if(value.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(value);
    usdController.text = (real/dollar).toStringAsFixed(2);
    eurController.text = (real/euro).toStringAsFixed(2);
  }
  void _usdChanged(String value) {
    if(value.isEmpty) {
      _clearAll();
      return;
    }
    double dollar = double.parse(value);
    brlController.text = (dollar * this.dollar).toStringAsFixed(2);
    eurController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
  }
  void _eurChanged(String value) {
    if(value.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(value);
    brlController.text = (euro * this.euro).toStringAsFixed(2);
    usdController.text = (euro * this.euro / dollar).toStringAsFixed(2);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$Currency convert\$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Loading data...",
                  style: TextStyle(
                    color: Colors.amber,
                  ),
                  textAlign: TextAlign.center,
                ),
              );

              break;

            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error...",
                    style: TextStyle(
                      color: Colors.amber,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                print(snapshot);
                dollar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),

                      Divider(),

                      buildTextField(
                          "BRL",
                          "R\$",
                          brlController,
                          _brlChanged
                      ),

                      Divider(),

                      buildTextField("USD", "\$", usdController, _usdChanged),

                      Divider(),

                      buildTextField("EUR", "€", eurController, _eurChanged),

                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

Widget buildTextField(
    String label,
    String prefix,
    TextEditingController controller,
    Function onChanged
) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.amber,
      ),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25.0,
    ),
    onChanged: onChanged,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
