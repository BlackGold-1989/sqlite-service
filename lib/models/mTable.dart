import 'dart:convert';

import 'package:sqlite_service/models/mField.dart';
import 'package:sqlite_service/scripts/sConstants.dart';
import 'package:sqlite_service/services/svSqlite.dart';

class ZureTableModel {
  String sName;
  List<ZureFieldModel> models = [];

  ZureTableModel({this.sName, this.models});

  void add(ZureFieldModel field) {
    models.add(field);
  }

  Future<bool> create() async {
    List<String> fields = [];
    for (var field in models) {
      var fieldCommand =
          ' ${field.sName} ${field.sType} ${field.bPrimary ? 'PRIMARY KEY' : ''}';
      fields.add(fieldCommand);
    }

    var commend = 'CREATE TABLE $sName (${fields.join(',')})';
    await ZureSqliteService.command(commend);
    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      'sName': sName,
      'models': models?.map((x) => x.toMap())?.toList(),
    };
  }

  factory ZureTableModel.fromMap(Map<String, dynamic> map) {
    return ZureTableModel(
      sName: map['sName'],
      models: List<ZureFieldModel>.from(
          map['models']?.map((x) => ZureFieldModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ZureTableModel.fromJson(String source) =>
      ZureTableModel.fromMap(json.decode(source));
}
