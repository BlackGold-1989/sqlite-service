import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqlite_service/models/mField.dart';
import 'package:sqlite_service/models/mTable.dart';
import 'package:sqlite_service/scripts/sConstants.dart';

class ZureSqliteService {

  static Database dbService;

  static Future<void> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, '$scDatabaseName.db');
    dbService = await openDatabase(
      path,
      password: scDatabasePass,
      onCreate: (db, version) {
        print('[DB] onCreate: ${db.isOpen}');
      },
      onOpen: (db) {
        print('[DB] onOpen: ${db.isOpen}');
      },
      onConfigure: (db) {
        print('[DB] onConfigure: ${db.isOpen}');
      },
      version: 1,
    );
  }

  static Future<void> command(String sComment) async {
    await dbService.execute(sComment);
  }

  static Future<void> close() async {
    await dbService.close();
  }

  static Future<List<String>> zureAllTableList() async {
    var sql =
        'SELECT name FROM sqlite_master WHERE type=\'table\'';
    var res = await dbService.rawQuery(sql);
    print('[DB Table] list: ${jsonEncode(res)}');
    List<String> tables = [];
    for (var value in res) {
      tables.add(value['name']);
    }
    return tables;
  }

  static Future<ZureTableModel> zureTable(String tb_name) async {
    var sql =
        'PRAGMA table_info($tb_name)';
    var res = await dbService.rawQuery(sql);
    var tbModel = ZureTableModel(sName: tb_name, models: []);
    for (var field in res) {
      var fiModel = ZureFieldModel(
        sName: field['name'],
        sType: field['type'],
        sError: '',
        bPrimary: field['pk'] == 1,
      );
      tbModel.add(fiModel);
    }
    return tbModel;
  }

  static Future<List<Map<String, Object>>> getAllTbRows(String tbName) async {
    final List<Map<String, dynamic>> tbMap = await dbService.query(tbName);
    return tbMap;
  }

  static Future<int> insertData(
      String tableName, Map<String, dynamic> tbMap) async {
    var result = await dbService.insert(
      tableName,
      tbMap,
    );
    return result;
  }

  static Future<int> updateData(String tableName, Map<String, dynamic> tbMap,
      String whereField, List<String> whereVal) async {
    var result = await dbService.update(tableName, tbMap,
        where: '$whereField = ?', whereArgs: whereVal);
    return result;
  }

  static Future<int> deleteData(String tableName, Map<String, dynamic> tbMap,
      String whereField, List<String> whereVal) async {
    var result = await dbService.delete(tableName,
        where: '$whereField = ?', whereArgs: whereVal);
    return result;
  }

}
