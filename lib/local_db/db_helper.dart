import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //Table create
  static Future<void> createTabels(sql.Database database) async {
    await database.execute(
        "CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, my_id INTEGER, imgUrl TEXT, name TEXT, desc TEXT, price TEXT, createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)");
  }

  //database create
  static Future<sql.Database> db() async {
    return sql.openDatabase("mydb.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTabels(database);
    });
  }

  //Insert data
  static Future<int> insertData(int my_id, String imgUrl, String name, String desc, String price) async {
    final db = await SQLHelper.db();

     final existingData = await db.query('data', where: 'my_id = ?', whereArgs: [my_id]);

     if (existingData.isNotEmpty) {
       return existingData.first['id'] as int;
     }

    final data = {'my_id': my_id, 'imgUrl': imgUrl, 'name': name, 'desc': desc, 'price': price};
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //Get all data
  static Future<List<Map<String, dynamic>>> getAllDate() async {
    final db = await SQLHelper.db();
    return db.query('data', orderBy: 'id');
    
  }

  //Delete data
  static Future<void> deletedata(int id) async {
    final data = await SQLHelper.db();
    try {
      await data.delete('data', where: "id=?", whereArgs: [id]);
    } catch (e) {}
  }
}