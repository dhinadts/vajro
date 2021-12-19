import 'dart:core';
import 'dart:io';

// import 'package:dhina/utility/utility_basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:dhina/db/sharedpref.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  // static final tamil_quiz = 'tamil_quiz';

  var databasesPath;
  var path;
  // var utility_basic = Utility_Basic();
  // var shared_preference = ""; //Shared_Preference();

  /*Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
      _database = await _initDatabase();

    return _database;
  }*/

  db_move() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // int counter = (prefs.getInt('db_move') ?? 0) + 1;

    if (await prefs.getInt("db_move") == null ||
        await prefs.getInt("db_move") == 0) {
      databasesPath = await getDatabasesPath();
      path = join(databasesPath, "Fruits.db");

      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load(join("assets", "Fruits.db"));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // Write and flush the bytes written
        await File(path).writeAsBytes(bytes, flush: true);

        var db = await openDatabase(path);
        // utility_basic.toastfun("db_moved");
        await prefs.setInt("db_move", 1);

        // print(await shared_preference.getInt("db_move"));
      } catch (Exception) {
        // utility_basic.toastfun('Db failed ' + Exception.toString());
        debugPrint(Exception.toString());
      }
    }
  }

  // this opens the database and create if not exist
  _initDatabase(String dbName) async {
    databasesPath = await getDatabasesPath();
    path = join(databasesPath, dbName);

    return await openDatabase(path, version: 1);
  }

  // open db any database
  opendb(String dbName) async {
    databasesPath = await getDatabasesPath();
    path = join(databasesPath, "$dbName");
    return await openDatabase(path, version: 1);
  }

  // create  any database
  create_db(String dbName) async {
    var db = await _initDatabase(dbName);
  }

//create table
  Future create_table(String tableName, String query, String dbName) async {
    var db = await _initDatabase(dbName);

    await db.execute('''CREATE TABLE $tableName ($query)''');
  }

  any_query(String query, {String dbName= "Fruits.db"}) async {
    var db = await _initDatabase(dbName);
    return db.rawQuery(query);
  }

  close_db(String dbName) async {
    var db = await _initDatabase(dbName);
    return await db.close();
  }
}
