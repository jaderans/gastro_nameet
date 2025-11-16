import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gatro_db.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE USER (
        USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        USER_NAME TEXT NOT NULL,
        USER_EMAIL TEXT NOT NULL UNIQUE,
        USER_PASSWORD TEXT NOT NULL,
        USER_DATE_CREATED TEXT DEFAULT CURRENT_TIMESTAMP
      );
    ''');
  }

  // Insert user
  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('USER', row);
  }

  // LOGIN FUNCTION
Future<Map<String, dynamic>?> loginUser(String email, String password) async {
  final db = await instance.database;

  final result = await db.query(
    'USER',
    where: 'USER_EMAIL = ? AND USER_PASSWORD = ?',
    whereArgs: [email, password],
  );

  if (result.isNotEmpty) {
    return result.first; // user found
  }

  return null; // no user found
}


}
