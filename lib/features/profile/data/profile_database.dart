import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
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
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE profile (
            id INTEGER PRIMARY KEY,
            user_id TEXT NOT NULL UNIQUE,
            image_path TEXT
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
}
