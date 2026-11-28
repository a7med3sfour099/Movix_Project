
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StorageHelper {
  static const _storage = FlutterSecureStorage();

  static const String _tmdbSessionKey = 'tmdb_session_id';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = join(
      await getDatabasesPath(),
      'app_database.db',
    );

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_data(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tmdb_account_id INTEGER,
            tmdb_session_id TEXT
          )
        ''');
      },
    );
  }

  // TMDB Session
  static Future<void> saveTmdbSessionId(String sessionId) async {
    await _storage.write(
      key: _tmdbSessionKey,
      value: sessionId,
    );
  }

  static Future<String?> getTmdbSessionId() async {
    return _storage.read(key: _tmdbSessionKey);
  }

  static Future<void> clearTmdbSessionId() async {
    await _storage.delete(key: _tmdbSessionKey);
  }

  // User Data
  static Future<int> saveUserData({
    required int tmdbAccountId,
    required String tmdbSessionId,
  }) async {
    final db = await database;

    return db.insert('user_data', {
      'tmdb_account_id': tmdbAccountId,
      'tmdb_session_id': tmdbSessionId,
    });
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final db = await database;
    final results = await db.query('user_data', limit: 1);

    return results.isNotEmpty ? results.first : null;
  }

  static Future<void> clearAll() async {
    await clearTmdbSessionId();

    final db = await database;
    await db.delete('user_data');
  }
}
