import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'instructors_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE instructors(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, homePhone TEXT, cellPhone TEXT, address TEXT, email TEXT)',
    );

    await db.execute(
      'CREATE TABLE lessons(id INTEGER PRIMARY KEY AUTOINCREMENT, instructorId INTEGER, name TEXT, price REAL)',
    );
    await db.execute(
      'CREATE TABLE hours(id INTEGER PRIMARY KEY AUTOINCREMENT, instructorId INTEGER, hour INTEGER)',
    );
  }

  Future<int> insertInstructor(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('instructors', row);
  }

  Future<int> insertLesson(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('lessons', row);
  }

  Future<List<Map<String, dynamic>>> getInstructors() async {
    Database db = await instance.database;
    return await db.query('instructors');
  }

  Future<int> deleteInstructor(int id) async {
    Database db = await instance.database;
    // İlgili saatleri öğretmenle ilişkilendirilmiş olanları sil
    // await db.delete('hours', where: 'instructorId = ?', whereArgs: [id]);

    // İlgili dersleri öğretmenle ilişkilendirilmiş olanları sil
    await db.delete('lessons', where: 'instructorId = ?', whereArgs: [id]);

    return await db.delete('instructors', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getInstructorById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'instructors',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getHoursByInstructorId(
      int instructorId) async {
    Database db = await instance.database;
    return await db
        .query('hours', where: 'instructorId = ?', whereArgs: [instructorId]);
  }

  Future<List<Map<String, dynamic>>> getLessonsByInstructorId(
      int instructorId) async {
    Database db = await instance.database;
    return await db
        .query('lessons', where: 'instructorId = ?', whereArgs: [instructorId]);
  }

  // DatabaseHelper sınıfına saatleri eklemek için yeni bir fonksiyon ekleyin
  Future<int> insertHours(int instructorId, List<int> hours) async {
    Database db = await instance.database;
    for (int hour in hours) {
      await db.insert('hours', {'instructorId': instructorId, 'hour': hour});
    }
    // İşlem başarıyla tamamlandığında, burada bir değer döndürebilirsiniz.
    return 1; // Örneğin, eklenecek saat sayısını döndürüyoruz.
  }

  Future<int> updateInstructor(Map<String, dynamic> updatedInstructor) async {
    Database db = await instance.database;
    int id = updatedInstructor['id'];

    // Önceki saat ve ders bilgilerini al
    List<Map<String, dynamic>> oldHours = await getHoursByInstructorId(id);
    List<Map<String, dynamic>> oldLessons = await getLessonsByInstructorId(id);

    // hours ve lessons alanlarını uygun formata dönüştür
    List<int> hours = updatedInstructor['hours'].cast<int>();
    List<String> lessons = updatedInstructor['lessons'].cast<String>();
    Map<String, double> lessonPrices = updatedInstructor['lessonPrices'];

    // Transaksyon kullanarak güncelleme işlemlerini gerçekleştir
    return await db.transaction((txn) async {
      // Önceki saat ve ders bilgilerini sil
      await txn.delete('hours', where: 'instructorId = ?', whereArgs: [id]);
      await txn.delete('lessons', where: 'instructorId = ?', whereArgs: [id]);

      // Yeni saat bilgilerini ekle
      for (int hour in hours) {
        await txn.insert('hours', {'instructorId': id, 'hour': hour});
      }

      // Yeni ders bilgilerini ekle
      for (String lesson in lessons) {
        await txn.insert('lessons', {
          'instructorId': id,
          'name': lesson,
          'price': lessonPrices[lesson],
        });
      }

      // Öğretmen bilgilerini güncelle
      return await txn.update(
        'instructors',
        {
          'id': id,
          'name': updatedInstructor['name'],
          'homePhone': updatedInstructor['homePhone'],
          'cellPhone': updatedInstructor['cellPhone'],
          'address': updatedInstructor['address'],
          'email': updatedInstructor['email'],
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }
}
