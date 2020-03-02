import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Fill your data.";

  set infoText(String value) {
    setState(() {
      _infoText = value;
      _formKey = GlobalKey<FormState>();
    });
  }

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    infoText = "Fill your data.";
  }

  void caculate() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text) / 100;

    double imc = weight / (height * height) / 10;

    print(imc);

    if (imc < 18.6) {
      infoText = "Bellow the weight (${imc.toStringAsPrecision(4)})";
    } else if (imc >= 18.6 && imc < 24.9) {
      infoText = "Ideal weight (${imc.toStringAsPrecision(4)})";
    } else if (imc >= 24.9 && imc < 29.9) {

      infoText = "Sighly above the weight (${imc.toStringAsPrecision(4)})";
    } else if (imc >= 29.9 && imc < 34.9) {

      infoText = "Obesitity I (${imc.toStringAsPrecision(4)})";
    } else if (imc >= 34.9 && imc < 39.9) {

      infoText = "Obesitity II (${imc.toStringAsPrecision(4)})";
    } else if (imc > 40) {
      infoText = "Obesitity III (${imc.toStringAsPrecision(4)})";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("IMC Calculator"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: _resetFields,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                size: 120,
                color: Colors.green,
              ),

              TextFormField(
                keyboardType: TextInputType.number,
                controller: weightController,
                decoration: InputDecoration(
                  labelText: "Insert your KG",
                  labelStyle: TextStyle(
                    color: Colors.green,
                  ),
                ),
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25,
                ),
                validator: (value) {
                  if (value.isEmpty) return "Insert your weight.";

                  return value;
                },
              ),

              TextFormField(
                keyboardType: TextInputType.number,
                controller: heightController,
                decoration: InputDecoration(
                  labelText: "Height",
                  labelStyle: TextStyle(
                    color: Colors.green,
                  ),
                ),
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25,
                ),
                validator: (value) {
                  if (value.isEmpty) return "Insert your height.";

                  return value;
                }
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        caculate();
                      }
                    },
                    child: Text(
                      "Calculate",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                    color: Colors.green,
                  ),
                ),
              ),

              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                ),
              )

            ],

          ),
        ),
      ),

    );
  }
}
