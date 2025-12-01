import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

@injectable
class Localdb {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'serviceOrder.db');

    _database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
            CREATE TABLE service_order (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              created_date TEXT,
              started_date TEXT,
              finalized_date TEXT,
              description TEXT NOT NULL,
              image_url TEXT NOT NULL,
              active INTEGER NOT NULL,
              status TEXT,
              address TEXT
            )
          '''
        );
      },
    );

    return _database!;
  }

  
}