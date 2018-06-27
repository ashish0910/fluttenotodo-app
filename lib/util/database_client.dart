import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notodoapp/model/nodo_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
    factory DatabaseHelper() => _instance ;
    static Database _db;
    final String tableName = "nodoTable";
    final String columnId = "id";
    final String columnDateCreated = "dateCreated";
    final String columnItemName = "itemName";
    Future<Database> get db async{
      if(_db!=null){
        return _db;
      }
      _db = await intitDB();
            return _db;
          }
      
      
          DatabaseHelper.internal();
      
        intitDB() async{
          var databasesPath = await getDatabasesPath();
          String path = join(databasesPath, "nodo_db.db");
          var ourDb = await openDatabase(path,version: 1,onCreate: _onCreate);
          return ourDb;
                  }
          
            void _onCreate(Database db, int version) async {
              await db.execute(
                "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY , $columnItemName TEXT , $columnDateCreated TEXT)"
              );
  }

  //insertion
  Future<int> saveUser(NoDoItem item)async {
    var dbClient = await db;
    int res = await dbClient.insert('$tableName', item.toMap());
    return res;
  }
  Future<List> getAllUsers() async{
    var dbClient = await db;
    var result = dbClient.rawQuery("SELECT * FROM $tableName");
    return result;
  } 
  Future<int> getCount() async{
    var dbClient = await db ;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName")
    );
  }
  Future<NoDoItem> getUser(int id) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE $columnId = $id");
    if(result.length == 0) {return null;}
    return new NoDoItem.fromMap(result.first);
  }
  Future<int> deleteUser(int id) async{
    var dbClient = await db ;
    var result = await dbClient.delete(tableName,where: "$columnId = ?",whereArgs: [id]);
    return result;
  }
  Future<int> updateUser(NoDoItem item) async{
    var dbClient = await db;
    return await dbClient.update(tableName, item.toMap(),where: "$columnId = ?",whereArgs: [item.id]);
  }
  Future close() async{
    var dbClient = await db;
    return dbClient.close();
  }
}