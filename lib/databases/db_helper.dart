import 'package:flutter/material.dart';
import 'package:our_mony_app/databases/db_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DBHelper with ChangeNotifier
{
  DBHelper.internal();
  static final DBHelper _instance = DBHelper.internal();
  factory DBHelper() => _instance;

  Database _db;
  String id = 'id';
  String product = 'product';
  String price = 'price';
  String noItems = 'noItems';
  String total = 'total';
  String weekMoney = 'weekMoney';
  String img = 'img';

  List<String> tables =
  [
    'tableOne',
    'tableTwo',
    'tableThree',
    'tableFour',
    'tableExtra',
  ];
  String get tableOne => tables[0];
  String get tableTwo => tables[1];
  String get tableThree => tables[2];
  String get tableFour => tables[3];
  String get tableExtra => tables[4];

  Future<Database> createDatabase(String table) async
  {
    if(_db != null) {
      return _db;
    }
    //define the path to the database
    String path = join(await getDatabasesPath(), 'ourMoney.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db , int v)
      {
        // table one
        db.execute(
            ''' create table $tableOne ($id integer primary key autoincrement,
            $product varchar(50) NOT NULL,
            $price REAL NOT NULL,
            $noItems REAL NOT NULL,
            $total REAL,
            $weekMoney REAL,
            $img varchar(500))''');
        // Table two
        db.execute(
            '''create table $tableTwo ($id integer primary key autoincrement,
          $product varchar(50) NOT NULL,
          $price REAL NOT NULL,
          $noItems REAL NOT NULL,
          $total REAL,
          $weekMoney REAL,
          $img varchar(500))''');

        // Table three
        db.execute(
            '''create table $tableThree ($id integer primary key autoincrement,
          $product varchar(50) NOT NULL,
          $price REAL NOT NULL,
          $noItems REAL NOT NULL,
          $total REAL,
          $weekMoney REAL,
          $img varchar(500))''');

        // Table four
        db.execute(
            '''create table $tableFour ($id integer primary key autoincrement,
          $product varchar(50) NOT NULL,
          $price REAL NOT NULL,
          $noItems REAL NOT NULL,
          $total REAL,
          $weekMoney REAL,
          $img varchar(500))''');

        // Table extra
        db.execute(
            '''create table $tableExtra ($id integer primary key autoincrement,
          $product varchar(50) NOT NULL,
          $price REAL NOT NULL,
          $noItems REAL NOT NULL,
          $total REAL,
          $weekMoney REAL,
          $img varchar(500))''');
      },
    );
    // Provider notifier listener
    notifyListeners();
    return _db;
  }
  // create table
  Future<int> creatOurMoney(OurMoney ourMoney , String table) async
  {
    Database db = await createDatabase(table);
    try{
      var result = await db.insert(table, ourMoney.convertToMap());
      return result;
    }on DatabaseException catch(e){
      return e.getResultCode();
    }
  }
  //get all database
  Future<List> getAllOurMoney(String table)async
  {
    Database db = await createDatabase(table);
    var result = await db.rawQuery(''' SELECT 
    $id,
    $product,
    $price,
    $noItems,
    $img,
    ($price * $noItems) $total,
    (SELECT SUM($price * $noItems) from $table) $weekMoney
    from $table
    ''');
    return result;
  }
  // Get a week
  Future<List> getWeekMoney(String table) async
  {
    Database db = await createDatabase(table);
    var result = await db.rawQuery('''
        SELECT $id, (SELECT SUM($price * $noItems)from $table) $weekMoney 
        from $table
        ''');
    return result;
  }
  Future<List> getAllPrices(String table) async
  {
    Database db = await createDatabase(table);
    var result = await db.rawQuery('SELECT $id, $price, from $table');
    return result;
  }
  Future<int> delete(int id, String table) async
  {
    Database db = await createDatabase(table);
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
  Future<int> update(OurMoney ourMoney, String table) async
  {
    Database db = await createDatabase(table);
    return await db.update(table, ourMoney.convertToMap(), where: 'id = ?', whereArgs: [ourMoney.id]);
  }

  notifyListeners();
}