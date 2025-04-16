import 'dart:convert';
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
            id VARCHAR PRIMARY KEY NOT NULL,
            nama_komisi VARCHAR NOT NULL,
            nomor_komisi INTEGER NOT NULL
          )
        """);

        //-----/ Migrate Qanun Table /-----//
        await db.execute("""
          CREATE TABLE qanun (
            id VARCHAR PRIMARY KEY NOT NULL,
            id_komisi VARCHAR NOT NULL,
            tahun INTEGER NOT NULL,
            nomor_qanun INTEGER NOT NULL,
            nama_qanun VARCHAR NOT NULL,
            nama_file VARCHAR NOT NULL,
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
            id_komisi VARCHAR NOT NULL,
            tahun INTEGER NOT NULL,
            nama_qanun INTEGER NOT NULL,
            nomor_qanun INTEGER NOT NULL,
            FOREIGN KEY(id_komisi) REFERENCES komisi(id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        """);

        //-----/ Migrate Qanun Dibintang Table /-----//
        await db.execute("""
          CREATE TABLE qanun_dibintang (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            id_qanun VARCHAR NOT NULL,
            id_komisi INTEGER NOT NULL,
            tahun INTEGER NOT NULL,
            nama_qanun INTEGER NOT NULL,
            nomor_qanun INTEGER NOT NULL,
            FOREIGN KEY(id_komisi) REFERENCES komisi(id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        """);

        //-----/ Migrate Tags Table /-----//
        await db.execute("""
          CREATE TABLE tag (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            id_qanun VARCHAR NOT NULL,
            text VARCHAR NOT NULL
          )
        """);
      },
    );
  }

  //-----/ Qanun Dibintang /-----//
  Future<bool> bintangQanun(Qanun qanun) async {
    try {
      final db = await database;
      final exist = await db
          .query("qanun_dibintang", where: "id_qanun=?", whereArgs: [qanun.id]);

      if (exist.isEmpty) {
        // Bintang qanun
        await db.insert("qanun_dibintang", qanun.toReadMap());

        // Simpan komisi
        final komisiExist = await db
            .query("komisi", where: "id=?", whereArgs: [qanun.komisi!.id]);
        if (komisiExist.isEmpty) {
          await db.insert("komisi", qanun.komisi!.toSaveMap());
        }
        return true;
      } else {
        // Hapus bintang qanun
        await db.delete("qanun_dibintang",
            where: "id_qanun=?", whereArgs: [qanun.id]);
        return false;
      }
    } catch (e) {
      log("Failed to star qanun: $e");
      rethrow;
    }
  }

  Future<bool> checkIsDibintang(String id) async {
    try {
      final db = await database;
      final exist = await db
          .query("qanun_dibintang", where: "id_qanun=?", whereArgs: [id]);
      return exist.isNotEmpty;
    } catch (e) {
      log("Failed to check is bintang: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getQanunDibintang() async {
    final db = await database;
    const sql = """
      SELECT qanun_dibintang.*, qanun_dibintang.id_qanun as id,
      komisi.id as id_komisi, komisi.nama_komisi, komisi.nomor_komisi
      FROM qanun_dibintang LEFT JOIN komisi ON komisi.id=qanun_dibintang.id_komisi
      ORDER BY qanun_dibintang.id DESC
    """;
    return await db.rawQuery(sql);
  }

  //-----/ Riwayat /-----//
  Future readQanun(Qanun qanun) async {
    try {
      final db = await database;
      await db.delete("riwayat", where: "id_qanun=?", whereArgs: [qanun.id]);
      await db.insert("riwayat", qanun.toReadMap());

      final komisiExist = await db
          .query("komisi", where: "id=?", whereArgs: [qanun.komisi!.id]);
      if (komisiExist.isEmpty) {
        await db.insert("komisi", qanun.komisi!.toSaveMap());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getRiwayatQanun() async {
    final db = await database;
    const sql = """
      SELECT riwayat.*, riwayat.id_qanun as id,
      komisi.id as id_komisi, komisi.nama_komisi, komisi.nomor_komisi
      FROM riwayat LEFT JOIN komisi ON komisi.id=riwayat.id_komisi
      ORDER BY riwayat.id DESC
    """;
    return await db.rawQuery(sql);
  }

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

  Future<List<Map<String, dynamic>>> getKomisi() async {
    final db = await database;
    final listQanun = await db.query("qanun");
    final listIdKomisi = [];
    for (var qanun in listQanun) {
      final idKomisi = qanun["id_komisi"];
      if (!listIdKomisi.contains(idKomisi)) listIdKomisi.add(idKomisi);
    }

    final inArgs =
        jsonEncode(listIdKomisi).replaceAll("[", "(").replaceAll("]", ")");
    final sql =
        "SELECT * FROM komisi WHERE id IN $inArgs ORDER BY nomor_komisi ASC";
    final filteredKomisi = await db.rawQuery(sql);
    return filteredKomisi;
  }

  //-----/ Qanun /-----//
  Future saveQanun(Qanun qanun) async {
    try {
      final db = await database;
      await _saveKomisi(qanun.komisi!);
      await db.insert("qanun", qanun.toSaveMap());
      await _saveTags(qanun.details!.tags, qanun.id);
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

  Future<List<Map<String, dynamic>>> getQanunByKomisi(String idKomisi) async {
    final db = await database;
    final sql = """
      SELECT qanun.*, komisi.nama_komisi, komisi.nomor_komisi
      FROM qanun LEFT JOIN komisi ON qanun.id_komisi=komisi.id
      WHERE id_komisi='$idKomisi'
    """;
    return db.rawQuery(sql);
  }

  Future<Map<String, dynamic>> getDetailQanun(String id) async {
    final db = await database;
    final sql = """
      SELECT qanun.*, komisi.nama_komisi, komisi.nomor_komisi
      FROM qanun LEFT JOIN komisi ON qanun.id_komisi=komisi.id
      WHERE qanun.id='$id'
    """;
    final qanunReadOnly = (await db.rawQuery(sql)).first;
    final tags = await _getQanunTags(id);

    final qanun = jsonDecode(jsonEncode(qanunReadOnly));
    qanun["details"] = {
      "namaFile": qanun["nama_file"],
      "tags": tags,
    };
    return qanun;
  }

  //-----/ Tag /-----//
  Future _saveTags(List<String> tags, String idQanun) async {
    final db = await database;
    return Future.wait(tags.map((tag) {
      return db.insert("tag", {
        "text": tag,
        "id_qanun": idQanun,
      });
    }));
  }

  Future<List<Map<String, dynamic>>> _getQanunTags(String id) async {
    final db = await database;
    return db.query("tag", where: "id_qanun=?", whereArgs: [id]);
  }
}
