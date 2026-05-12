import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'agenda_nusantara.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE tasks ADD COLUMN completed_date TEXT');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabel Tugas
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        due_date TEXT,
        category TEXT,
        is_completed INTEGER DEFAULT 0,
        completed_date TEXT
      )
    ''');

    // Tabel User (Akun)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Seeder: Akun Default
    await db.insert('users', {
      'username': 'user',
      'password': 'user',
    });
  }

  // Auth Operations
  Future<Map<String, dynamic>?> login(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<int> updateUserPassword(String username, String newPassword) async {
    Database db = await database;
    return await db.update(
      'users',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  // CRUD Operations (Tasks)
  Future<int> insertTask(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('tasks', row);
  }

  Future<List<Map<String, dynamic>>> queryAllTasks() async {
    Database db = await database;
    return await db.query('tasks', orderBy: 'due_date ASC');
  }

  Future<int> updateTask(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    
    // Jika ditandai selesai (is_completed = 1), catat tanggal hari ini
    if (row['is_completed'] == 1) {
      row = Map<String, dynamic>.from(row);
      row['completed_date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    } else {
      row = Map<String, dynamic>.from(row);
      row['completed_date'] = null;
    }
    
    return await db.update('tasks', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // Get statistics
  Future<Map<String, int>> getTaskStats() async {
    Database db = await database;
    
    var important = await db.rawQuery('SELECT COUNT(*) as count FROM tasks WHERE category = "Penting"');
    var normal = await db.rawQuery('SELECT COUNT(*) as count FROM tasks WHERE category = "Biasa"');
    var completed = await db.rawQuery('SELECT COUNT(*) as count FROM tasks WHERE is_completed = 1');
    var pending = await db.rawQuery('SELECT COUNT(*) as count FROM tasks WHERE is_completed = 0');

    return {
      'total_important': Sqflite.firstIntValue(important) ?? 0,
      'total_normal': Sqflite.firstIntValue(normal) ?? 0,
      'total_completed': Sqflite.firstIntValue(completed) ?? 0,
      'total_pending': Sqflite.firstIntValue(pending) ?? 0,
    };
  }

  // Get task counts for the last 7 days (for chart)
  Future<List<int>> getTasksPerDay() async {
    Database db = await database;
    List<int> counts = [];
    DateTime now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      String dateStr = DateFormat('yyyy-MM-dd').format(date);
      
      var result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM tasks WHERE completed_date = ? AND is_completed = 1',
        [dateStr]
      );
      counts.add(Sqflite.firstIntValue(result) ?? 0);
    }
    return counts;
  }
}
