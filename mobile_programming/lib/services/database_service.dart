import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, 'homework7.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY,
        event_name TEXT,
        number_of_people INTEGER,
        date_selection TEXT,
        image_route TEXT
      )
    ''');
  }

  Future<void> insertEvent(Event event) async {
    final db = await instance.database;
    await db.insert('events', event.toMap());
  }

  Future<List<Event>> getAllEvents() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) {
      return Event(
        id: maps[i]['id'],
        eventName: maps[i]['event_name'],
        numberOfPeople: maps[i]['number_of_people'],
        dateSelection: maps[i]['date_selection'],
        imageRoute: maps[i]['image_route'],
      );
    });
  }

  Future<void> updateEvent(Event event) async {
    final db = await instance.database;
    await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(int id) async {
    final db = await instance.database;
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Event {
  final int? id;
  final String eventName;
  final int numberOfPeople;
  final String dateSelection;
  final String imageRoute;

  Event({
    this.id,
    required this.eventName,
    required this.numberOfPeople,
    required this.dateSelection,
    required this.imageRoute,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_name': eventName,
      'number_of_people': numberOfPeople,
      'date_selection': dateSelection,
      'image_route': imageRoute,
    };
  }
}
