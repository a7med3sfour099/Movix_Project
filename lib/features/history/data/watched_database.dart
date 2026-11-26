import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/profile/data/profile_database.dart';
import 'package:sqflite/sqflite.dart';

class WatchedDatabase {
  final ProfileDatabase _profileDb = ProfileDatabase();

  // Called by movix.db when it creates or upgrades
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS watched (
        user_id TEXT NOT NULL,
        media_id INTEGER NOT NULL,
        media_type TEXT NOT NULL,
        title TEXT,
        year TEXT,
        date TEXT,
        rating TEXT,
        genre_id INTEGER,
        image TEXT,
        watched_at INTEGER,
        PRIMARY KEY (user_id, media_id, media_type)
      )
    ''');
  }

  // Newest first
  Future<List<MediaItem>> getWatched(String userId) async {
    final db = await _profileDb.openMyDatabase();
    final rows = await db.query(
      'watched',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'watched_at DESC',
    );

    return rows.map((row) {
      return MediaItem(
        id: row['media_id'] as int,
        title: row['title'] as String? ?? '',
        year: row['year'] as String? ?? '',
        date: row['date'] as String? ?? '',
        type: row['media_type'] as String? ?? 'movie',
        rating: row['rating'] as String? ?? '0.0',
        genreId: row['genre_id'] as int?,
        image: row['image'] as String?,
      );
    }).toList();
  }

  // Same movie again just updates its time
  Future<void> addWatched(String userId, MediaItem item) async {
    final db = await _profileDb.openMyDatabase();
    await db.insert(
      'watched',
      {
        'user_id': userId,
        'media_id': item.id,
        'media_type': item.type,
        'title': item.title,
        'year': item.year,
        'date': item.date,
        'rating': item.rating,
        'genre_id': item.genreId,
        'image': item.image,
        'watched_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeWatched(String userId, int mediaId, String type) async {
    final db = await _profileDb.openMyDatabase();
    await db.delete(
      'watched',
      where: 'user_id = ? AND media_id = ? AND media_type = ?',
      whereArgs: [userId, mediaId, type],
    );
  }

  Future<void> clearWatched(String userId) async {
    final db = await _profileDb.openMyDatabase();
    await db.delete('watched', where: 'user_id = ?', whereArgs: [userId]);
  }
}