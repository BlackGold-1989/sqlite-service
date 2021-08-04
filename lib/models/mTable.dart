import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_service/models/mField.dart';
import 'package:sqlite_service/scripts/sConstants.dart';
import 'package:sqlite_service/services/svSqlite.dart';
import 'package:sqlite_service/themes/tColors.dart';
import 'package:sqlite_service/themes/tDimens.dart';
import 'package:sqlite_service/themes/tStyle.dart';

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
          '\n${field.sName} ${field.sType}${field.bPrimary ? ' PRIMARY KEY' : ''}';
      fields.add(fieldCommand);
    }

    var command = 'CREATE TABLE $sName (${fields.join(',')}\n)';
    print('[DB] command: $command');
    print('[DB] create table: $sName');
    await ZureSqliteService.command(command);

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

  Future<int> getCountTableRow() async {
    return (await ZureSqliteService.getAllTbRows(sName)).length;
  }

  Widget wReadOnlyWidget(
      {Function() remove, Function() edit, Function() view}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(cOffsetBase)),
      ),
      child: Container(
        padding: EdgeInsets.all(cOffsetBase),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: getCountTableRow(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '$sName (${snapshot.data})',
                          style: cZureBoldTitle.copyWith(fontSize: cFontMd),
                        );
                      } else {
                        return Text(
                          sName,
                          style: cZureBoldTitle.copyWith(fontSize: cFontMd),
                        );
                      }
                    },
                  ),
                ),
                InkWell(
                  onTap: () => view(),
                  child: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  width: cOffsetSm,
                ),
                InkWell(
                  onTap: () => edit(),
                  child: Icon(
                    Icons.edit,
                    color: zurePrimaryColor,
                  ),
                ),
                SizedBox(
                  width: cOffsetSm,
                ),
                InkWell(
                  onTap: () => remove(),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: cOffsetSm,
            ),
            for (var field in models)
              Container(
                padding: EdgeInsets.only(left: cOffsetSm, top: cOffsetXSm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        field.sName,
                        style: cZureMediumText,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        field.sType,
                        style: cZureMediumText,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        field.bPrimary ? scPrimaryKey : '',
                        style: cZureMediumText,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
