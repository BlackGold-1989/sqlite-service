import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqlite_service/scripts/sConstants.dart';

class ZureSqliteService {

  static Database dbService;

  static Future<bool> initDatabase() async {
    dbService = await openDatabase(
      join(await getDatabasesPath(), '$scDatabaseName.db'),
      password: '$scDatabasePass',
      onCreate: (db, version) {
        return db.isOpen;
      },
      version: 1,
    );
  }

  static Future<void> command(String sComment) async {
    var batch = dbService.batch();
    batch.execute(sComment);
  }

  static Future<void> close() async {
    await dbService.close();
  }

}