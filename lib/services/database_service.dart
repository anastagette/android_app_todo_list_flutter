import 'dart:io';
import '../models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {

  DatabaseService._privateConstructor();
  static final DatabaseService instance =
    DatabaseService._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        uid INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isDone INT NOT NULL,
        remarks TEXT,
        notificationId INT,
        notificationEnabled INT NOT NULL,
        notificationDate DATE,
        notificationTime TIME        
      )
    ''');
  }

  Future<List<Task>> getTasks() async {
    Database db = await instance.database;
    var tasks = await db.query('tasks', orderBy: 'uid');
    List<Task> tasksList = tasks.isNotEmpty
      ? tasks.map((e) => Task.fromMap(e)).toList()
      : [];
    return tasksList;
  }

  Future<int> createNewTask(Task task) async {
    Database db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(int? uid, String? title, String remarks) async {
    Database db = await instance.database;
    return await db.rawUpdate(
      'UPDATE tasks SET title = ?, remarks = ? WHERE uid = ?',
      [title, remarks, uid]);
  }

  Future<int> updateNotificationEnabled(
    int? uid, bool notificationEnabled
  ) async {
    int transformedBool = notificationEnabled ? 1 : 0;
    Database db = await instance.database;
    return await db.rawUpdate(
      'UPDATE tasks SET notificationEnabled = ? WHERE uid = ?',
      [transformedBool, uid]);
  }

  Future<int> updateNotificationDate(int? uid, String notificationDate) async {
    Database db = await instance.database;
    return await db.rawUpdate(
      'UPDATE tasks SET notificationDate = ? WHERE uid = ?',
      [notificationDate, uid]);
  }

  Future<int> updateNotificationTime(int? uid, String notificationTime) async {
    Database db = await instance.database;
    return await db.rawUpdate(
      'UPDATE tasks SET notificationTime = ? WHERE uid = ?',
      [notificationTime, uid]);
  }

  Future taskIsDone(uid) async {
    Database db = await instance.database;
    return await db.rawUpdate(
      'UPDATE tasks SET isDone = ? WHERE uid = ?',
      [1, uid]);
  }

  Future taskIsNotDone(uid) async {
    Database db = await instance.database;
    return await db.rawUpdate(
      'UPDATE tasks SET isDone = ? WHERE uid = ?',
      [0, uid]);
  }

  Future<int> deleteTask(int? uid) async {
    Database db = await instance.database;
    return await db.delete('tasks', where: 'uid = ?', whereArgs: [uid]);
  }
}