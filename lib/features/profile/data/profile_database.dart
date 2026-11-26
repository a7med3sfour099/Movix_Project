import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movixapp/features/calendar/data/reminder_item.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ProfileDatabase {
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Future<Database> openMyDatabase() async {
    String folder = await getDatabasesPath();
    String dbPath = join(folder, 'movix.db');

    return await openDatabase(
      dbPath,
      version: 5,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE profile (
            id INTEGER PRIMARY KEY,
            user_id TEXT NOT NULL UNIQUE,
            image_path TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE library (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL,
            media_id INTEGER NOT NULL,
            media_type TEXT NOT NULL,
            title TEXT,
            year TEXT,
            date TEXT,
            rating TEXT,
            genre_id INTEGER,
            image TEXT,
            category TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE reminders (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            category TEXT NOT NULL,
            title TEXT NOT NULL,
            subtitle TEXT NOT NULL,
            time TEXT NOT NULL,
            poster_url TEXT,
            date TEXT NOT NULL,
            repeat TEXT NOT NULL DEFAULT 'none',
            is_enabled INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          final columns = await db.rawQuery('PRAGMA table_info(profile)');
          final hasUserId = columns.any(
            (column) => column['name'] == 'user_id',
          );

          if (!hasUserId) {
            await db.execute(
              'ALTER TABLE profile ADD COLUMN user_id TEXT',
            );
          }
        }
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS library (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id TEXT NOT NULL,
              media_id INTEGER NOT NULL,
              media_type TEXT NOT NULL,
              title TEXT,
              year TEXT,
              date TEXT,
              rating TEXT,
              genre_id INTEGER,
              image TEXT,
              category TEXT NOT NULL
            )
          ''');
        }
        if (oldVersion < 4) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS reminders (
              id TEXT PRIMARY KEY,
              user_id TEXT NOT NULL,
              category TEXT NOT NULL,
              title TEXT NOT NULL,
              subtitle TEXT NOT NULL,
              time TEXT NOT NULL,
              poster_url TEXT,
              date TEXT NOT NULL,
              repeat TEXT NOT NULL DEFAULT 'none',
              is_enabled INTEGER NOT NULL
            )
          ''');
        }
        if (oldVersion < 5) {
          final columns = await db.rawQuery('PRAGMA table_info(reminders)');
          final hasRepeat = columns.any(
            (column) => column['name'] == 'repeat',
          );
          if (!hasRepeat) {
            await db.execute(
              "ALTER TABLE reminders ADD COLUMN repeat TEXT NOT NULL DEFAULT 'none'",
            );
          }
        }
      },
    );
  }

  Future<String> getImagePath() async {
    final userId = _userId;
    if (userId == null) return '';

    Database db = await openMyDatabase();
    List<Map<String, Object?>> rows = await db.query(
      'profile',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (rows.isEmpty) return '';
    String path = rows.first['image_path'] as String;

    if (File(path).existsSync()) {
      return path;
    }

    return '';
  }

  Future<String> pickImage() async {
    final userId = _userId;
    if (userId == null) return '';

    ImagePicker picker = ImagePicker();
    XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked == null) return '';
    Directory folder = await getApplicationDocumentsDirectory();

    String newPath = join(
      folder.path,
      'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    await File(picked.path).copy(newPath);
    Database db = await openMyDatabase();

    List<Map<String, Object?>> oldRows = await db.query(
      'profile',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    await db.delete(
      'profile',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    await db.insert('profile', {
      'user_id': userId,
      'image_path': newPath,
    });

    for (Map<String, Object?> row in oldRows) {
      File oldFile = File(row['image_path'] as String);
      if (oldFile.existsSync()) {
        await oldFile.delete();
      }
    }

    return newPath;
  }

  Future<({List<MediaItem> favorites, List<MediaItem> watchlist})> getLibrary(
      String userId) async {
    final db = await openMyDatabase();
    final rows = await db.query(
      'library',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    final favorites = <MediaItem>[];
    final watchlist = <MediaItem>[];

    for (final row in rows) {
      final item = MediaItem(
        id: row['media_id'] as int,
        title: row['title'] as String? ?? '',
        year: row['year'] as String? ?? '',
        date: row['date'] as String? ?? '',
        type: row['media_type'] as String? ?? 'movie',
        rating: row['rating'] as String? ?? '0.0',
        genreId: row['genre_id'] as int?,
        image: row['image'] as String?,
      );
      final category = row['category'] as String?;
      if (category == 'favorite') {
        favorites.add(item);
      } else if (category == 'watchlist') {
        watchlist.add(item);
      }
    }

    return (favorites: favorites, watchlist: watchlist);
  }

  Future<void> saveLibrary(
    String userId,
    List<MediaItem> favorites,
    List<MediaItem> watchlist,
  ) async {
    final db = await openMyDatabase();
    await db.transaction((txn) async {
      await txn.delete(
        'library',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      for (final item in favorites) {
        await txn.insert('library', {
          'user_id': userId,
          'media_id': item.id,
          'media_type': item.type,
          'title': item.title,
          'year': item.year,
          'date': item.date,
          'rating': item.rating,
          'genre_id': item.genreId,
          'image': item.image,
          'category': 'favorite',
        });
      }

      for (final item in watchlist) {
        await txn.insert('library', {
          'user_id': userId,
          'media_id': item.id,
          'media_type': item.type,
          'title': item.title,
          'year': item.year,
          'date': item.date,
          'rating': item.rating,
          'genre_id': item.genreId,
          'image': item.image,
          'category': 'watchlist',
        });
      }
    });
  }

  Future<List<ReminderItem>> getReminders(String userId) async {
    final db = await openMyDatabase();
    final rows = await db.query(
      'reminders',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return rows.map((row) {
      return ReminderItem(
        id: row['id'] as String,
        category: row['category'] as String? ?? '',
        title: row['title'] as String? ?? '',
        subtitle: row['subtitle'] as String? ?? '',
        time: row['time'] as String? ?? '',
        posterUrl: row['poster_url'] as String? ?? '',
        date: DateTime.parse(row['date'] as String),
        repeat: row['repeat'] as String? ?? 'none',
        isEnabled: (row['is_enabled'] as int? ?? 1) == 1,
      );
    }).toList();
  }

  Future<void> saveReminders(
      String userId, List<ReminderItem> reminders) async {
    final db = await openMyDatabase();
    await db.transaction((txn) async {
      await txn.delete(
        'reminders',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      for (final item in reminders) {
        await txn.insert('reminders', {
          'id': item.id,
          'user_id': userId,
          'category': item.category,
          'title': item.title,
          'subtitle': item.subtitle,
          'time': item.time,
          'poster_url': item.posterUrl,
          'date': item.date.toIso8601String(),
          'repeat': item.repeat,
          'is_enabled': item.isEnabled ? 1 : 0,
        });
      }
    });
  }
}
