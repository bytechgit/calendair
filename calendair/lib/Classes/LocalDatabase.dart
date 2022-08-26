import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:calendair/models/User.dart';

class LocalDatabase {
  static final LocalDatabase _singleton = LocalDatabase._internal();
  factory LocalDatabase() {
    return _singleton;
  }
  Future<Database>? database;
  LocalDatabase._internal() {
    initialize();
  }
  // Get a location using getDatabasesPath

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'User_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE Users(UID TEXT PRIMARY KEY, fullName TEXT, city TEXE,streetAddress TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertUser(UserData u) async {
    // Get a reference to the database.
    final db = await database;

    await db?.delete("Users");
    await db?.insert(
      'Users',
      u.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserData?> GetUser() async {
    final db = await database;
    if (db != null) {
      final List<Map<String, dynamic>> maps = await db.query('Users');
      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return UserData(
          UID: maps[i]['UID'],
          fullName: maps[i]['fullName'],
          city: maps[i]['city'],
          streetAddress: maps[i]['streetAddress'],
        );
      }).first;
    }
    return null;
  }
}
