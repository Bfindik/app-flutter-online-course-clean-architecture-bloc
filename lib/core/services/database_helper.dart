import 'dart:async';
<<<<<<< HEAD
import 'package:online_course/src/JSON/users.dart';
=======
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
<<<<<<< HEAD
  String user = '''
   CREATE TABLE users (
   usrId INTEGER PRIMARY KEY AUTOINCREMENT,
   fullName TEXT,
   email TEXT,
   usrName TEXT UNIQUE,
   usrPassword TEXT
   )
   ''';
=======
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37

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
<<<<<<< HEAD
      'CREATE TABLE lessons(id INTEGER PRIMARY KEY AUTOINCREMENT, instructorId INTEGER, name TEXT, price REAL, isWeekday INTEGER)',
    );

    await db.execute(
      'CREATE TABLE hours(id INTEGER PRIMARY KEY AUTOINCREMENT, instructorId INTEGER, hour INTEGER)',
    );
    await db.execute(
      'CREATE TABLE courses(id INTEGER PRIMARY KEY AUTOINCREMENT, instructorId INTEGER, name TEXT, description TEXT, price REAL, image TEXT, startDate TEXT, endDate TEXT, lessonIds TEXT, craftDays TEXT)',
    );
    await db.execute(user);
=======
      'CREATE TABLE lessons(id INTEGER PRIMARY KEY AUTOINCREMENT, instructorId INTEGER, name TEXT, price REAL)',
    );
    await db.execute(
      'CREATE TABLE hours(id INTEGER PRIMARY KEY AUTOINCREMENT, instructorId INTEGER, hour INTEGER)',
    );
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
  }

  Future<int> insertInstructor(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('instructors', row);
  }

<<<<<<< HEAD
  // Yeni metod: Tüm kursları al
  Future<List<Map<String, dynamic>>> getCourses() async {
    Database db = await instance.database;
    return await db.query('courses');
  }

  Future<int> insertLesson(Map<String, dynamic> row, bool isWeekday) async {
    Database db = await instance.database;
    row['isWeekday'] = isWeekday ? 1 : 0; // 1: hafta içi, 0: hafta sonu
=======
  Future<int> insertLesson(Map<String, dynamic> row) async {
    Database db = await instance.database;
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
    return await db.insert('lessons', row);
  }

  Future<List<Map<String, dynamic>>> getInstructors() async {
    Database db = await instance.database;
    return await db.query('instructors');
  }

  Future<int> deleteInstructor(int id) async {
    Database db = await instance.database;
<<<<<<< HEAD
    await db.delete('hours', where: 'instructorId = ?', whereArgs: [id]);
    await db.delete('lessons', where: 'instructorId = ?', whereArgs: [id]);
=======
    // İlgili saatleri öğretmenle ilişkilendirilmiş olanları sil
    // await db.delete('hours', where: 'instructorId = ?', whereArgs: [id]);

    // İlgili dersleri öğretmenle ilişkilendirilmiş olanları sil
    await db.delete('lessons', where: 'instructorId = ?', whereArgs: [id]);

>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
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

<<<<<<< HEAD
  Future<int> insertCourse(Map<String, dynamic> course) async {
    Database db = await instance.database;
    return await db.insert('courses', course);
  }

=======
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
  Future<List<Map<String, dynamic>>> getLessonsByInstructorId(
      int instructorId) async {
    Database db = await instance.database;
    return await db
        .query('lessons', where: 'instructorId = ?', whereArgs: [instructorId]);
  }

<<<<<<< HEAD
  Future<List<Map<String, dynamic>>> getLessonsByInstructor(
      int instructorId) async {
    return await DatabaseHelper.instance.getLessonsByInstructorId(instructorId);
  }

=======
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
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
<<<<<<< HEAD

  //Authentication
  Future<bool> authenticate(Users usr) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
        "select * from users where usrName = '${usr.usrName}' AND usrPassword = '${usr.password}' ");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Sign up
  Future<int> createUser(Users usr) async {
    Database db = await instance.database;
    return db.insert("users", usr.toMap());
  }

  //Get current User details
  Future<Users?> getUser(String usrName) async {
    Database db = await instance.database;
    var res =
        await db.query("users", where: "usrName = ?", whereArgs: [usrName]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }
=======
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
}
