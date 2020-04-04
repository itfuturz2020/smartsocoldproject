import 'package:smart_society_new/Mall/Common/MallClassList.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'student.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE student (id INTEGER PRIMARY KEY, date TEXT)');
  }

  Future<AddToCartClass> add(AddToCartClass cart) async {
    var dbClient = await db;
    cart.productId = await dbClient.insert('student', cart.toMap());
    return cart;
  }

  Future<List<AddToCartClass>> getStudents() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('student', columns: ['id', 'date']);
    List<AddToCartClass> students = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        students.add(AddToCartClass.fromMap(maps[i]));
      }
    }
    return students;
  }

  Future<int> delete() async {
    var dbClient = await db;
    return await dbClient.delete('student');
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
