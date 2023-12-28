import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:contacts_management/Models/contacts_model.dart';
class databasehelper{

  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contacts_buddy.db');
    print('Database path: $path');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }


   static Future<void> _createDatabase(Database db, int version) async {
     String users = '''
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    age INTEGER
  )
''';
     String contacts = '''
  CREATE TABLE IF NOT EXISTS contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    number INTEGER
  )
''';
      //await db.execute(users);
      await db.execute(contacts);
  }

  static Future<int> insertUser(String name, int age)async{
     final  db = await _openDatabase();
     final data = {
       'name':name,
       'age' :age,
     };
     return await db.insert('users', data);


  }
  static Future<int> insertContact(String name, int number)async{
    final  db = await _openDatabase();
    final data = {
      'name':name,
      'number' :number,
    };
    return await db.insert('contacts', data);

    //static Future<int> initialDummyData(String name, int number)async{
    //name = 'Dummy',
   // number = 0763312356
     // final  db = await _openDatabase();
    //  final data = {
    //    'name':name,
      //  'number' :number,
      //};
      //return await db.insert('contacts', data);
  }
  //Get Data
   static Future <List<Map<String,dynamic>>> getData() async {
    final Database db = await _openDatabase();
    return await db.query('contacts');
  }

  static Future<int> deleteData(int id) async {
    final Database db = await _openDatabase();
    return db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
  static Future<Map<String,dynamic>?> getSingleData(int id) async {
    final Database db = await _openDatabase();
    List<Map<String,  dynamic>> result  = await db.query(
      'contacts',
      where : 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
    //return db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateData(int id, Map<String, dynamic> data) async
  {
    final db = await _openDatabase();
    return await db.update('contacts', data,where: 'id = ?' ,whereArgs: [id]);
  }
  //Search Method


  static Future<List<Map<String, dynamic>>> searchNotes(String keyword) async {
    final Database db = await _openDatabase();
    List<Map<String, dynamic>> searchResult = await db
        .rawQuery("select * from contacts where name LIKE ?", ["%$keyword%"]);
    return searchResult;
  }

  //Search Method


}