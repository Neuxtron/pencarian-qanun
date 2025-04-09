import 'dart:developer';

import 'package:path/path.dart';
import 'package:pencarian_qanun_mobile/core/models/komisi.dart';
import 'package:pencarian_qanun_mobile/core/models/qanun.dart';
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
            id varchar(191) PRIMARY KEY NOT NULL,
            nama_komisi varchar(191) NOT NULL,
            nomor_komisi INTEGER NOT NULL
          )
        """);

        //-----/ Migrate Qanun Table /-----//
        await db.execute("""
          CREATE TABLE qanun (
            id varchar(191) PRIMARY KEY NOT NULL,
            id_komisi varchar(191) NOT NULL,
            tahun INTEGER NOT NULL,
            nomor_qanun INTEGER NOT NULL,
            nama_qanun varchar(191) NOT NULL,
            nama_file varchar(191) NOT NULL,
            FOREIGN KEY(id_komisi) REFERENCES komisi(id) ON DELETE CASCADE ON UPDATE CASCADE
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
    final riwayatPencarianMap =
        await db.query('riwayat_pencarian', orderBy: "id DESC");
    return riwayatPencarianMap.map((e) => e["text"] as String).toList();
  }

  Future addRiwayatPencarian(String text) async {
    final db = await database;
    await db.delete("riwayat_pencarian", where: "text=?", whereArgs: [text]);
    await db.insert('riwayat_pencarian', {"text": text});
  }

  Future hapusRiwayatPencarian() async {
    final db = await database;
    await db.delete('riwayat_pencarian');
  }

  //-----/ Komisi /-----//
  Future _saveKomisi(Komisi komisi) async {
    final db = await database;
    final exist =
        await db.query("komisi", where: "id=?", whereArgs: [komisi.id]);
    if (exist.isEmpty) {
      await db.insert("komisi", komisi.toSaveMap());
    }
  }

  //-----/ Qanun /-----//
  Future readQanun(Qanun qanun) async {
    try {
      final db = await database;
      await db.delete("riwayat", where: "id_qanun=?", whereArgs: [qanun.id]);
      await db.insert("riwayat", qanun.toReadMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Future saveQanun(Qanun qanun) async {
    try {
      final db = await database;
      await _saveKomisi(qanun.komisi!);
      await db.insert("qanun", qanun.toSaveMap());
    } catch (e) {
      log("Failed to save qanun: $e");
    }
  }

  Future<bool> checkIsDownloaded(String id) async {
    try {
      final db = await database;
      final exist = await db.query("qanun", where: "id=?", whereArgs: [id]);
      return exist.isNotEmpty;
    } catch (e) {
      log("Failed to check is downloaded: $e");
      return false;
    }
  }

  //-----/ Tag /-----//
}
