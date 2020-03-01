import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "People counter.",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _people = 0;
  String _infoText = "Can enter";

  /// @return int
  int get people => _people;

  /// @param int value
  set people(int value) {
    setState(() {
      _people = value;

      if (value < 0) {
        infoText = "Inverted world?";
      } else if ( value > 10) {
        infoText = "Overloaded";
      } else {
        infoText = "Can enter";
      }
    });
  }

  /// @return String
  String get infoText => _infoText;

  /// @param String value
  set infoText(String value) {
    _infoText = value;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Image.asset("images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000.0,
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            Text(
              "People: $people",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      "+1",
                      style: TextStyle(
                        fontSize: 40.00,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      people++;
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      "-1",
                      style: TextStyle(
                        fontSize: 40.00,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      people--;
                    },
                  ),
                ),

              ],
            ),

            Text(
              infoText,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 30.00,
                color: Colors.white,
              ),
            ),


          ],
        ),
      ],
    );
  }
}
