import 'package:movixapp/features/profile/data/profile_database.dart';
import 'package:sqflite/sqflite.dart';

class RatingDatabase {
  final ProfileDatabase _profileDb = ProfileDatabase();

  // Called by movix.db when it creates or upgrades
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ratings (
        user_id TEXT NOT NULL,
        media_id INTEGER NOT NULL,
        media_type TEXT NOT NULL,
        value INTEGER NOT NULL,
        rated_at INTEGER,
        PRIMARY KEY (user_id, media_id, media_type)
      )
    ''');
  }

  // Stars from 1 to 5, or 0 if the user did not rate it
  Future<int> getRating(String userId, int mediaId, String type) async {
    final db = await _profileDb.openMyDatabase();
    final rows = await db.query(
      'ratings',
      where: 'user_id = ? AND media_id = ? AND media_type = ?',
      whereArgs: [userId, mediaId, type],
    );

    if (rows.isEmpty) return 0;
    return rows.first['value'] as int;
  }

  // Rating the same title again replaces the old stars
  Future<void> saveRating(
      String userId,
      int mediaId,
      String type,
      int value,
      ) async {
    final db = await _profileDb.openMyDatabase();
    await db.insert(
      'ratings',
      {
        'user_id': userId,
        'media_id': mediaId,
        'media_type': type,
        'value': value,
        'rated_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeRating(String userId, int mediaId, String type) async {
    final db = await _profileDb.openMyDatabase();
    await db.delete(
      'ratings',
      where: 'user_id = ? AND media_id = ? AND media_type = ?',
      whereArgs: [userId, mediaId, type],
    );
  }
}