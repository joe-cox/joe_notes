import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:joe_notes/models/practice_session.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String practiceTable = 'AccordionPractices';
  final String columnId = 'id';
  final String columnStartTime = 'start_time';
  final String columnDuration = 'duration';
  final String columnNotes = 'notes';
  final String databaseName = 'joeNotes.db';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();

    return _db;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    //await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreateDatabase);
    return db;
  }

  void _onCreateDatabase(Database db, int newVersion) async {
    db.execute(
        'CREATE TABLE $practiceTable ($columnId INTEGER PRIMARY KEY, $columnStartTime TEXT,$columnDuration INTEGER, $columnNotes TEXT)');
  }

  Future<int> savePracticeSession(PracticeSession ps) async {
    var dbClient = await db;
    return await dbClient.insert(practiceTable, ps.toMap());
  }

  Future<List<PracticeSession>> getPracticeSessions() async {
    var dbClient = await db;
    var result = await dbClient
        .query(practiceTable, columns: [columnId, columnStartTime, columnDuration, columnNotes]);
    var practiceSessions = new List<PracticeSession>();
    for(var x = 0; x<result.length; x++){
      practiceSessions.add(new PracticeSession.fromMap(result[x]));
    }
    return practiceSessions;
  }

  Future<PracticeSession> getPracticeSession(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(practiceTable,
        columns: [columnId, columnStartTime, columnDuration, columnNotes],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (result.length > 0) {
      return new PracticeSession.fromMap(result.first);
    }
    return null;
  }

  Future<int> getPracticeSessionCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $practiceTable'));
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
