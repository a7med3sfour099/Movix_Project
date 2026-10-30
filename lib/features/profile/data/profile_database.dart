import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ProfileDatabase {
  // data base
  Future<Database> openMyDatabase() async {
    String folder = await getDatabasesPath();
    String dbPath = join(folder, 'movix.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE profile (id INTEGER PRIMARY KEY, image_path TEXT)',
        );
      },
    );
  }

  //  get url
  Future<String> getImagePath() async {
    Database db = await openMyDatabase();
    List<Map> rows = await db.query('profile');

    if (rows.isEmpty) {
      return '';
    }

    String path = rows[0]['image_path'];

    if (File(path).existsSync()) {
      return path;
    }
    return '';
  }

  //select img  save url
  Future<String> pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) {
      return '';
    }
    //copy
    Directory folder = await getApplicationDocumentsDirectory();
    String newPath = join(
      folder.path,
      'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await File(picked.path).copy(newPath);

    // url in data base
    Database db = await openMyDatabase();

    List<Map> oldRows = await db.query('profile');

    await db.delete('profile');
    await db.insert('profile', {'image_path': newPath});

    for (Map row in oldRows) {
      File oldFile = File(row['image_path']);
      if (oldFile.existsSync()) {
        await oldFile.delete();
      }
    }

    return newPath;
  }
}
