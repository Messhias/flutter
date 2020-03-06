import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contacts";
final String idColumn = "idColumn",
    nameColumn = "nameColumn",
    emailColumn = "emailColumn",
    phoneColumn = "phoneColumn",
    imageColumn = "imageColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;

    _db = await initDB();

    return _db;
  }

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contacts.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $contactTable  ("
          "$idColumn integer primary key, $nameColumn TEXT,"
          "$emailColumn TEXT, $phoneColumn TEXT, $imageColumn TEXT"
          ")");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database database = await db;
    if (contact != null) contact.id = await database.insert(contactTable, contact.toMap());

    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database database = await db;
    List<Map> map = await database.query(contactTable,
        columns: [nameColumn, phoneColumn, emailColumn, imageColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if (map.length > 0)
      return Contact.fromMap(map.first);
    else
      return null;
  }

  deleteContact(int id) async {
    Database database = await db;
    return await database.delete(contactTable,
        whereArgs: [id], where: "$idColumn = ?");
  }

  Future<int> updateContact(Contact contact) async {
    Database database = await db;
    if (contact != null) return await database.update(contactTable, contact.toMap(),
        where: '$idColumn = ?', whereArgs: [contact.id]);

    return null;
  }

  Future<List> getAllContacts() async {
    Database database = await db;
    List listMap = await database.rawQuery("SELECT * FROM $contactTable");
    List<Contact> contacts = List();
    for (Map map in listMap) {
      contacts.add(Contact.fromMap(map));
    }

    return contacts;
  }

  Future<int> getNumber() async {
    Database database = await db;
    return Sqflite.firstIntValue(
        await database.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }
}

class Contact {
  String name, email, phone, img;
  int id;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imageColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      phoneColumn: phone,
      imageColumn: img,
    };

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Contact (name: $name, phone: $phone, email: $email, img: $img)";
  }
}
