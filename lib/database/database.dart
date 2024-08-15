import 'package:Talks/modals/userModal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TalksDatabase {
  //user Table
  final databaseName = "Talks.db";

  //initializing userTable
  String userTable =
      "CREATE TABLE users (usrId  INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE NOT NULL, usrPassword TEXT NOT NULL , usrPhoneNumber TEXT NOT NULL)";

  //Initialize database
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(userTable);
    });
  }

  //login method
  Future<bool> login(String usrName, String usrPassword) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "select * from users where usrName = '$usrName' AND usrPassword = '$usrPassword'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //signup method
  Future<int> signup(Users user) async {
    final Database db = await initDB();
    return db.insert('users', user.toMap());
  }
}
