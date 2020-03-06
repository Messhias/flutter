import 'dart:io';

import 'package:contacts/helpers/contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum OrderOptions { orderAz, orderZa }

class ContactsPage extends StatefulWidget {
  final Contact contact;

  ContactsPage({this.contact});

  @override
  _ContactsPage createState() => _ContactsPage();
}

class _ContactsPage extends State<ContactsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  Contact _editedContact;
  bool _userEdited = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.contact == null) {
      this._editedContact = Contact();
    } else {
      this._editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _phoneController.text = _editedContact.phone;
      _emailController.text = _editedContact.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "New contact"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: 140.0,
                  width: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact.img != null
                          ? FileImage(File(_editedContact.img))
                          : AssetImage("images/person.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  print("aqui");
                  ImagePicker.pickImage(source: ImageSource.camera)
                      .then((response) {
                    if (response != null) {
                      setState(() {
                        _editedContact.img = response.path;
                      });
                    }
                  }).catchError((error) => print(error));
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Name"),
                onChanged: (value) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = value;
                  });
                },
                controller: _nameController,
                focusNode: _nameFocus,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.email = value;
                },
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.phone = value;
                },
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Are you sure to discard all changes?"),
              content: Text("After leaving all the changes will been lost"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
}
