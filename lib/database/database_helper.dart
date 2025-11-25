import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gastro_db.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Always delete existing database to get fresh copy
    try {
      if (await databaseExists(path)) {
        await deleteDatabase(path);
        print('✅ Existing database deleted');
      }
    } catch (e) {
      print('⚠️ Error deleting existing database: $e');
    }

    // Try to copy from assets first
    bool copiedFromAssets = false;
    try {
      await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load('assets/database/$filePath');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      print('✅ Database copied from assets');
      copiedFromAssets = true;
    } catch (e) {
      print('⚠️ Could not copy from assets: $e');
      print('📝 Creating database with tables...');
    }

    // Open database
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (database) async {
        print('📂 Database opened successfully');
        await _verifyAndPopulate(database, copiedFromAssets);
      },
    );

    return db;
  }

  Future<void> _createDB(Database db, int version) async {
    print('🔨 Creating database tables...');

    // Create USER table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS USER (
        USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        USER_NAME TEXT NOT NULL,
        USER_EMAIL TEXT NOT NULL UNIQUE,
        USER_PASSWORD TEXT NOT NULL,
        USER_DATE_CREATED TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create CATEGORY table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS CATEGORY (
        CATEG_ID INTEGER PRIMARY KEY,
        CATEG_NAME TEXT NOT NULL
      )
    ''');

    // Create SPECIALTY table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS SPECIALTY (
        SP_ID INTEGER PRIMARY KEY,
        SP_NAME TEXT NOT NULL,
        SP_DESCRIPTION TEXT,
        SP_HISTORY TEXT,
        SP_IMG_URL TEXT,
        CATEG_ID INTEGER,
        FOREIGN KEY (CATEG_ID) REFERENCES CATEGORY(CATEG_ID)
      )
    ''');

    // Creates table for BOOKMARK
    await db.execute('''
      CREATE TABLE IF NOT EXISTS BOOKMARK (
        BM_ID INTEGER PRIMARY KEY,
        BM_DATE TEXT,
        BM_PLACE_NAME TEXT,
        BM_ADDRESS TEXT,
        BM_LAT REAL,
        BM_LNG REAL,
        BM_RATING REAL,
        BM_IMG TEXT,
        USER_ID INTEGER,
        FOREIGN KEY (USER_ID) REFERENCES USER(USER_ID)
      )
    ''');

      await db.execute('''
      CREATE TABLE IF NOT EXISTS COMMENTS (
        REV_ID INTEGER PRIMARY KEY,
        REV_DATE TEXT,
        REV_DESC TEXT,
        REV_LAT REAL,
        REV_LNG REAL,
        REV_PLACE_NAME TEXT,
        USER_ID INTEGER,
        FOREIGN KEY (USER_ID) REFERENCES USER(USER_ID)
      )
    ''');

    print('✅ Tables created successfully');
  }

  Future<void> _verifyAndPopulate(Database db, bool copiedFromAssets) async {
    try {
      // Check if tables exist
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'"
      );
      print('📋 Available tables: ${tables.map((t) => t['name']).toList()}');

      // If not copied from assets, populate with data
      if (!copiedFromAssets) {
        await _populateData(db);
      }

      // Verify data
      final specialtyCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM SPECIALTY')
      );
      print('🍽️ SPECIALTY table has $specialtyCount records');

      final categoryCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM CATEGORY')
      );
      print('📁 CATEGORY table has $categoryCount records');

      final userCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM USER')
      );
      print('👤 USER table has $userCount records');
    } catch (e) {
      print('⚠️ Error verifying database: $e');
    }
  }

// Add these methods to your DBHelper class in database_helper.dart

// Insert a new comment
Future<int> insertComment(Map<String, dynamic> comment) async {
  final db = await database;
  return await db.insert('COMMENTS', comment);
}

// Get all comments
Future<List<Map<String, dynamic>>> getAllComments() async {
  final db = await database;
  return await db.query(
    'COMMENTS',
    orderBy: 'REV_DATE DESC',
  );
}

// Get comments by user ID
Future<List<Map<String, dynamic>>> getCommentsByUser(int userId) async {
  final db = await database;
  return await db.query(
    'COMMENTS',
    where: 'USER_ID = ?',
    whereArgs: [userId],
    orderBy: 'REV_DATE DESC',
  );
}

// Get comments by place name
Future<List<Map<String, dynamic>>> getCommentsByPlace(String placeName) async {
  final db = await database;
  return await db.query(
    'COMMENTS',
    where: 'REV_PLACE_NAME = ?',
    whereArgs: [placeName],
    orderBy: 'REV_DATE DESC',
  );
}

// Update a comment
Future<int> updateComment(int revId, Map<String, dynamic> comment) async {
  final db = await database;
  return await db.update(
    'COMMENTS',
    comment,
    where: 'REV_ID = ?',
    whereArgs: [revId],
  );
}

// Delete a comment
Future<int> deleteComment(int revId) async {
  final db = await database;
  return await db.delete(
    'COMMENTS',
    where: 'REV_ID = ?',
    whereArgs: [revId],
  );
}

// BOOKMARK CRUD START
  Future<int> insertBookmark(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('BOOKMARK', row);
  }

  Future<List<Map<String, dynamic>>> getAllBookmarks() async {
    final db = await instance.database;
    return await db.query('BOOKMARK');
  }

  Future<int> deleteBookmark(int bmId) async {
    final db = await instance.database;
    return await db.delete(
      'BOOKMARK',
      where: 'BM_ID = ?',
      whereArgs: [bmId],
    );
  } 

//BOOKMARK CRUD END


  Future<void> _populateData(Database db) async {
    print('📥 Populating database with food data...');

    // Insert Categories
    final categories = [
      {'CATEG_ID': 1, 'CATEG_NAME': 'Breakfast'},
      {'CATEG_ID': 2, 'CATEG_NAME': 'Lunch'},
      {'CATEG_ID': 3, 'CATEG_NAME': 'Dinner'},
      {'CATEG_ID': 4, 'CATEG_NAME': 'Snacks'},
      {'CATEG_ID': 5, 'CATEG_NAME': 'Soup'},
      {'CATEG_ID': 6, 'CATEG_NAME': 'Dessert'},
    ];

    for (var category in categories) {
      await db.insert('CATEGORY', category, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    print('✅ Inserted ${categories.length} categories');

    // Insert Specialties based on your CSV data
    final specialties = [
      {
        'SP_ID': 1,
        'SP_NAME': 'Laswa',
        'SP_DESCRIPTION': 'A hearty vegetable soup served with shrimp or fish',
        'SP_HISTORY': 'Rooted in rural Ilonggo cooking traditions',
        'SP_IMG_URL': 'https://assets.unileversolutions.com/recipes-v3/175481-default.jpg?im=AspectCrop=(720,459);Resize=(720,459)',
        'CATEG_ID': 1
      },
      {
        'SP_ID': 2,
        'SP_NAME': 'Tinuom nga Manok',
        'SP_DESCRIPTION': 'Chicken cooked in banana leaves with native spices',
        'SP_HISTORY': 'Originates from the countryside of Iloilo',
        'SP_IMG_URL': 'https://i0.wp.com/www.angsarap.net/wp-content/uploads/2023/06/Tinuom-na-Manok.jpg',
        'CATEG_ID': 1
      },
      {
        'SP_ID': 3,
        'SP_NAME': 'Laswa',
        'SP_DESCRIPTION': 'A hearty vegetable soup served with shrimp or fish',
        'SP_HISTORY': 'Rooted in rural Ilonggo cooking traditions',
        'SP_IMG_URL': 'https://assets.unileversolutions.com/recipes-v3/175481-default.jpg?im=AspectCrop=(720,459);Resize=(720,459)',
        'CATEG_ID': 5
      },
      {
        'SP_ID': 4,
        'SP_NAME': 'Tinuom nga Manok',
        'SP_DESCRIPTION': 'Chicken cooked in banana leaves with native spices',
        'SP_HISTORY': 'Originates from the countryside of Iloilo',
        'SP_IMG_URL': 'https://i0.wp.com/www.angsarap.net/wp-content/uploads/2023/06/Tinuom-na-Manok.jpg',
        'CATEG_ID': 5
      },
      {
        'SP_ID': 5,
        'SP_NAME': 'Batchoy',
        'SP_DESCRIPTION': 'Pork noodle soup with crushed chicharon and liver',
        'SP_HISTORY': 'Invented in the 1930s at La Paz Public Market in Iloilo City',
        'SP_IMG_URL': 'https://assets.unileversolutions.com/recipes-v3/110752-default.jpg?im=AspectCrop=(720,459);Resize=(720,459)',
        'CATEG_ID': 2
      },
      {
        'SP_ID': 6,
        'SP_NAME': 'Batchoy',
        'SP_DESCRIPTION': 'Pork noodle soup with crushed chicharon and liver',
        'SP_HISTORY': 'Invented in the 1930s at La Paz Public Market in Iloilo City',
        'SP_IMG_URL': 'https://assets.unileversolutions.com/recipes-v3/110752-default.jpg?im=AspectCrop=(720,459);Resize=(720,459)',
        'CATEG_ID': 5
      },
      {
        'SP_ID': 7,
        'SP_NAME': 'KBL (Kadios, Baboy, Langka)',
        'SP_DESCRIPTION': 'A sour soup made from pigeon peas, pork, and jackfruit',
        'SP_HISTORY': 'A traditional Ilonggo comfort dish with native ingredients',
        'SP_IMG_URL': 'https://images.yummy.ph/yummy/uploads/2023/10/kblrecipe-small-2.jpg',
        'CATEG_ID': 2
      },
      {
        'SP_ID': 8,
        'SP_NAME': 'KBL (Kadios, Baboy, Langka)',
        'SP_DESCRIPTION': 'A sour soup made from pigeon peas, pork, and jackfruit',
        'SP_HISTORY': 'A traditional Ilonggo comfort dish with native ingredients',
        'SP_IMG_URL': 'https://images.yummy.ph/yummy/uploads/2023/10/kblrecipe-small-2.jpg',
        'CATEG_ID': 5
      },
      {
        'SP_ID': 9,
        'SP_NAME': 'Linagpang',
        'SP_DESCRIPTION': 'Grilled fish simmered with tomatoes, onions, and ginger',
        'SP_HISTORY': 'A native warm dish enjoyed at night in coastal areas',
        'SP_IMG_URL': 'https://i0.wp.com/www.angsarap.net/wp-content/uploads/2017/02/Linagpang-na-Bangus.jpg?w=1080&ssl=1',
        'CATEG_ID': 3
      },
      {
        'SP_ID': 10,
        'SP_NAME': 'Linagpang',
        'SP_DESCRIPTION': 'Grilled fish simmered with tomatoes, onions, and ginger',
        'SP_HISTORY': 'A native warm dish enjoyed at night in coastal areas',
        'SP_IMG_URL': 'https://i0.wp.com/www.angsarap.net/wp-content/uploads/2017/02/Linagpang-na-Bangus.jpg?w=1080&ssl=1',
        'CATEG_ID': 5
      },
      {
        'SP_ID': 11,
        'SP_NAME': 'Chicken Binakol',
        'SP_DESCRIPTION': 'Chicken soup cooked with coconut water and lemongrass',
        'SP_HISTORY': 'Though known in Western Visayas, a comforting native soup',
        'SP_IMG_URL': 'https://i0.wp.com/www.angsarap.net/wp-content/uploads/2012/01/chicken-binakol.jpg?w=800&ssl=1',
        'CATEG_ID': 3
      },
      {
        'SP_ID': 12,
        'SP_NAME': 'Chicken Binakol',
        'SP_DESCRIPTION': 'Chicken soup cooked with coconut water and lemongrass',
        'SP_HISTORY': 'Though known in Western Visayas, a comforting native soup',
        'SP_IMG_URL': 'https://i0.wp.com/www.angsarap.net/wp-content/uploads/2012/01/chicken-binakol.jpg?w=800&ssl=1',
        'CATEG_ID': 5
      },
      {
        'SP_ID': 13,
        'SP_NAME': 'Puto Manapla',
        'SP_DESCRIPTION': 'Soft steamed rice cakes often paired with dinuguan',
        'SP_HISTORY': 'Popular among Ilonggo travelers and locals alike',
        'SP_IMG_URL': 'https://miro.medium.com/v2/resize:fit:2000/format:webp/1*FWR-U--WQ6M8ALNFgngouQ.jpeg',
        'CATEG_ID': 4
      },
      {
        'SP_ID': 14,
        'SP_NAME': 'Baye-Baye',
        'SP_DESCRIPTION': 'Rice delicacy made from pounded sticky rice',
        'SP_HISTORY': 'A long-time Ilonggo delicacy served in banana leaves',
        'SP_IMG_URL': 'https://cdn.shortpixel.ai/spai/q_+w_975+to_webp+ret_img/rezelkealoha.com/wp-content/uploads/2023/11/Baye-Baye-Recipe-22.jpg',
        'CATEG_ID': 4
      },
      {
        'SP_ID': 15,
        'SP_NAME': 'Pancit Molo',
        'SP_DESCRIPTION': 'Dumpling soup with minced meat and vegetables',
        'SP_HISTORY': 'Named after the district of Molo, Iloilo City',
        'SP_IMG_URL': 'https://www.kawalingpinoy.com/wp-content/uploads/2015/10/pancit-molo-1-1152x1536.jpg',
        'CATEG_ID': 5
      },
      {
        'SP_ID': 16,
        'SP_NAME': 'Biscocho',
        'SP_DESCRIPTION': 'Toasted bread coated with butter and sugar',
        'SP_HISTORY': 'Originated in Iloilo bakery houses and is a popular pasalubong',
        'SP_IMG_URL': 'https://www.foxyfolksy.com/wp-content/uploads/2019/08/how-to-make-biscocho.jpg',
        'CATEG_ID': 6
      },
      {
        'SP_ID': 17,
        'SP_NAME': 'Biscocho',
        'SP_DESCRIPTION': 'Toasted bread coated with butter and sugar',
        'SP_HISTORY': 'Originated in Iloilo bakery houses and is a popular pasalubong',
        'SP_IMG_URL': 'https://www.foxyfolksy.com/wp-content/uploads/2019/08/how-to-make-biscocho.jpg',
        'CATEG_ID': 4
      },
      {
        'SP_ID': 18,
        'SP_NAME': 'Baye-Baye',
        'SP_DESCRIPTION': 'Rice delicacy made from pounded sticky rice',
        'SP_HISTORY': 'A long-time Ilonggo delicacy served in banana leaves',
        'SP_IMG_URL': 'https://cdn.shortpixel.ai/spai/q_+w_975+to_webp+ret_img/rezelkealoha.com/wp-content/uploads/2023/11/Baye-Baye-Recipe-22.jpg',
        'CATEG_ID': 6
      },
    ];

    for (var specialty in specialties) {
      await db.insert('SPECIALTY', specialty, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    print('✅ Inserted ${specialties.length} specialties');
  }

  // Insert user
  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('USER', row);
  }

  // Check if email exists (for duplicate validation)
  Future<bool> emailExists(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'USER',
      where: 'USER_EMAIL = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Check if username exists (for duplicate validation)
  Future<bool> usernameExists(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'USER',
      where: 'USER_NAME = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
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

  // FOOD/SPECIALTY QUERIES

  // Get all specialties by category
  Future<List<Map<String, dynamic>>> getSpecialtiesByCategory(int categoryId) async {
    final db = await instance.database;
    try {
      final result = await db.query(
        'SPECIALTY',
        where: 'CATEG_ID = ?',
        whereArgs: [categoryId],
      );
      print('📊 Found ${result.length} items for category $categoryId');
      return result;
    } catch (e) {
      print('❌ Error getting specialties by category: $e');
      return [];
    }
  }

  // Get specialty by ID
  Future<Map<String, dynamic>?> getSpecialtyById(int spId) async {
    final db = await instance.database;
    try {
      final result = await db.query(
        'SPECIALTY',
        where: 'SP_ID = ?',
        whereArgs: [spId],
      );

      if (result.isNotEmpty) {
        return result.first;
      }
    } catch (e) {
      print('❌ Error getting specialty by ID: $e');
    }
    return null;
  }

  // Get category by ID
  Future<Map<String, dynamic>?> getCategoryById(int categoryId) async {
    final db = await instance.database;
    try {
      final result = await db.query(
        'CATEGORY',
        where: 'CATEG_ID = ?',
        whereArgs: [categoryId],
      );

      if (result.isNotEmpty) {
        return result.first;
      }
    } catch (e) {
      print('❌ Error getting category by ID: $e');
    }
    return null;
  }

  // Get all categories
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await instance.database;
    try {
      return await db.query('CATEGORY');
    } catch (e) {
      print('❌ Error getting all categories: $e');
      return [];
    }
  }

  // Get all specialties
  Future<List<Map<String, dynamic>>> getAllSpecialties() async {
    final db = await instance.database;
    try {
      return await db.query('SPECIALTY');
    } catch (e) {
      print('❌ Error getting all specialties: $e');
      return [];
    }
  }

  // Search specialties by name
  Future<List<Map<String, dynamic>>> searchSpecialties(String searchTerm) async {
    final db = await instance.database;
    try {
      return await db.query(
        'SPECIALTY',
        where: 'SP_NAME LIKE ?',
        whereArgs: ['%$searchTerm%'],
      );
    } catch (e) {
      print('❌ Error searching specialties: $e');
      return [];
    }
  }

  // Debug helper - print all specialties
  Future<void> debugPrintAllSpecialties() async {
    final db = await instance.database;
    try {
      final result = await db.query('SPECIALTY');
      print('=== ALL SPECIALTIES (${result.length} total) ===');
      for (var row in result) {
        print('ID: ${row['SP_ID']}, Name: ${row['SP_NAME']}, Category: ${row['CATEG_ID']}');
      }
      print('=== END ===');
    } catch (e) {
      print('❌ Error printing specialties: $e');
    }
  }

  // Debug helper - print all categories
  Future<void> debugPrintAllCategories() async {
    final db = await instance.database;
    try {
      final result = await db.query('CATEGORY');
      print('=== ALL CATEGORIES (${result.length} total) ===');
      for (var row in result) {
        print('ID: ${row['CATEG_ID']}, Name: ${row['CATEG_NAME']}');
      }
      print('=== END ===');
    } catch (e) {
      print('❌ Error printing categories: $e');
    }
  }
}