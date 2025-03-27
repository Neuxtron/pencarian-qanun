import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'qanun.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        //-----/ Migrate Komisi Table /-----//
        await db.execute("""
          CREATE TABLE komisi (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nama_komisi varchar(191) NOT NULL,
            nomor_komisi INTEGER NOT NULL
          )
        """);

        //-----/ Migrate Qanun Table /-----//
        await db.execute("""
          CREATE TABLE qanun (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            idKomisi varchar(191) NOT NULL,
            tahun INTEGER NOT NULL,
            nomor_qanun INTEGER NOT NULL,
            nama_qanun varchar(191) NOT NULL,
            nama_file varchar(191) NOT NULL,
            FOREIGN KEY(idKomisi) REFERENCES komisi(id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        """);

        //-----/ Migrate Riwayat Pencarian Table /-----//
        await db.execute("""
          CREATE TABLE riwayat_pencarian (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            text VARCHAR NOT NULL
          )
        """);

        //-----/ Migrate Riwayat Table /-----//
        await db.execute("""
          CREATE TABLE  riwayat (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            id_qanun VARCHAR NOT NULL,
            nomor_komisi INTEGER NOT NULL,
            tahun INTEGER NOT NULL,
            nama INTEGER NOT NULL,
            nomor INTEGER NOT NULL
          )
        """);

        //-----/ Migrate Qanun Dibintang Table /-----//
        await db.execute("""
          CREATE TABLE qanun_dibintang (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            id_qanun VARCHAR NOT NULL,
            nomor_komisi INTEGER NOT NULL,
            tahun INTEGER NOT NULL,
            nama INTEGER NOT NULL,
            nomor INTEGER NOT NULL
          )
        """);
      },
    );
  }

  //-----/ Qanun Dibintang /-----//

  //-----/ Riwayat /-----//

  //-----/ Riwayat Pencarian /-----//
  Future<List<String>> getRiwayatPencarian() async {
    final db = await database;
    final riwayatPencarianMap = await db.query('riwayat_pencarian');
    return riwayatPencarianMap.map((e) => e["text"] as String).toList();
  }

  Future addRiwayatPencarian(String text) async {
    final db = await database;
    await db.insert('riwayat_pencarian', {"text": text});
  }

  Future hapusRiwayatPencarian() async {
    final db = await database;
    await db.delete('riwayat_pencarian');
  }

  //-----/ Komisi /-----//

  //-----/ Qanun /-----//

  //-----/ Tag /-----//
}
