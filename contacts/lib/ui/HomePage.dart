import 'dart:io';

import 'package:contacts/helpers/contacts.dart';
import 'package:contacts/ui/ContactsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestAllContacts();
  }

  void requestAllContacts() {
    helper.getAllContacts().then((response) {
      setState(() {
        contacts = response;
      });
    }).catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Order A-Z"),
                value: OrderOptions.orderAz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Order Z-A"),
                value: OrderOptions.orderZa,
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img))
                        : AssetImage("images/person.png"),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
//        _showContactPage(contact: contacts[index]);
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Call",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          if (contacts[index].phone != null)
                            launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Edit",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          helper.deleteContact(contacts[index].id);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Contact contact}) async {
    final requestContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactsPage(contact: contact),
      ),
    );

    if (requestContact != null) {
      if (contact != null) {
        await helper.updateContact(requestContact);
      } else {
        await helper.saveContact(requestContact);
      }

      requestAllContacts();
    }
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderAz:
        contacts.sort((a, b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case OrderOptions.orderZa:
        contacts.sort((a, b) =>
            b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      default:
        break;
    }
    setState(() {});
  }
}
