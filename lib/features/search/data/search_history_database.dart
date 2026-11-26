import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:movixapp/features/search/data/search_result.dart';

class SearchHistoryDatabase {
  // Guests share one bucket
  String get _userId => FirebaseAuth.instance.currentUser?.uid ?? 'guest';

  Future<Database> openMyDatabase() async {
    String folder = await getDatabasesPath();
    String dbPath = join(folder, 'search_history.db');

    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS searches');
          await db.execute('DROP TABLE IF EXISTS viewed');
          await _createTables(db);
        }
      },
    );
  }
  Future<void> _createTables(Database db) async {
    await db.execute(
      'CREATE TABLE searches (user_id TEXT, text TEXT, time INTEGER, '
          'PRIMARY KEY (user_id, text))',
    );
    await db.execute(
      'CREATE TABLE viewed (user_id TEXT, key TEXT, id INTEGER, type TEXT, '
          'title TEXT, image TEXT, year INTEGER, rating REAL, '
          'department TEXT, gender INTEGER, time INTEGER, '
          'PRIMARY KEY (user_id, key))',
    );
  }

  // Search texts, newest first
  Future<List<String>> getSearches() async {
    Database db = await openMyDatabase();
    List<Map> rows = await db.query(
      'searches',
      where: 'user_id = ?',
      whereArgs: [_userId],
      orderBy: 'time DESC',
      limit: 15,
    );
    return rows.map((row) => row['text'] as String).toList();
  }

  // Same text again replaces the old row, so it moves to the front
  Future<void> addSearch(String text) async {
    Database db = await openMyDatabase();
    await db.insert(
      'searches',
      {
        'user_id': _userId,
        'text': text,
        'time': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> clearSearches() async {
    Database db = await openMyDatabase();
    await db.delete('searches', where: 'user_id = ?', whereArgs: [_userId]);
  }
  // Viewed movies, shows and actors, newest first
  Future<List<SearchResult>> getViewed() async {
    Database db = await openMyDatabase();
    List<Map> rows = await db.query(
      'viewed',
      where: 'user_id = ?',
      whereArgs: [_userId],
      orderBy: 'time DESC',
      limit: 10,
    );

    return rows.map((row) {
      return SearchResult(
        id: row['id'] as int,
        type: row['type'] as String,
        title: row['title'] as String,
        image: row['image'] as String?,
        year: row['year'] as int?,
        date: '',
        rating: (row['rating'] as num).toDouble(),
        genreIds: const [],
        department: row['department'] as String,
        gender: row['gender'] as int,
      );
    }).toList();
  }

  Future<void> addViewed(SearchResult result) async {
    Database db = await openMyDatabase();
    await db.insert(
      'viewed',
      {
        'user_id': _userId,
        'key': '${result.type}-${result.id}',
        'id': result.id,
        'type': result.type,
        'title': result.title,
        'image': result.image,
        'year': result.year,
        'rating': result.rating,
        'department': result.department,
        'gender': result.gender,
        'time': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> clearViewed() async {
    Database db = await openMyDatabase();
    await db.delete('viewed', where: 'user_id = ?', whereArgs: [_userId]);
  }
}