import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];

  final TextEditingController taskController = TextEditingController();

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedIndex;

  @override
  void initState() {
    super.initState();
    _readData().then((response) {
      setState(() {
        _todoList = json.decode(response);
      });
    }).catchError((onError) => print(onError));
  }

  void _addTodo() {
    setState(() {
      if (taskController.text.isNotEmpty) {
        Map<String, dynamic> newTodo = Map();
        newTodo["title"] = taskController.text;
        taskController.text = "";
        newTodo['complete'] = false;
        _todoList.add(newTodo);
        _todoList.sort((a, b) {
          if (a['complete'] && !b['complete']) return 1;
          else if (!a['complete'] && b['complete']) return -1;
          else return 0;
        });
        _saveData();
      }
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (error) {
      print(error);

      return null;
    }
  }

  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b) {
          if (a['complete'] && !b['complete']) return 1;
          else if (!a['complete'] && b['complete']) return -1;
          else return 0;
      });

      _saveData();
    });

    return Null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo list"),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      decoration: InputDecoration(
                          labelText: "New task",
                          labelStyle: TextStyle(
                            color: Colors.blueAccent,
                          )),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    child: Text(
                      "Add",
                    ),
                    textColor: Colors.white,
                    onPressed: _addTodo,
                  )
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                child: ListView.builder(
                  itemBuilder: buildItem,
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _todoList.length
                ),
                onRefresh: refresh,
              ),
            ),
          ],
        ));
  }

  Widget buildItem (BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
            child: Icon(Icons.delete, color: Colors.white,),
            alignment: Alignment(-0.9,0),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_todoList[index]['title']),
        value: _todoList[index]['complete'],
        secondary: CircleAvatar(
          child: Icon(
            _todoList[index]['complete'] ? Icons.check : Icons.error,
          ),
        ),
        onChanged: (complete) {
          setState(() {
            _todoList[index]['complete'] = complete;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_todoList[index]);
          _lastRemovedIndex = index;
          _todoList.removeAt(index);

          _saveData();


          final snackBar = SnackBar(
            content: Text(
              "Task ${_lastRemoved['title']} removed",
            ),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                setState(() {
                  _todoList.insert(_lastRemovedIndex, _lastRemoved);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 2),
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snackBar);

        });
      },
    );
  }
}
