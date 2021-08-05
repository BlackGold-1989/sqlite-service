import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqlite_service/components/cAppbar.dart';
import 'package:sqlite_service/models/mTable.dart';
import 'package:sqlite_service/pages/pInsertData.dart';
import 'package:sqlite_service/services/svNavigator.dart';
import 'package:sqlite_service/services/svSqlite.dart';
import 'package:sqlite_service/services/svString.dart';
import 'package:sqlite_service/themes/tColors.dart';
import 'package:sqlite_service/themes/tDimens.dart';
import 'package:sqlite_service/themes/tStyle.dart';

class ZureTableDetailScreen extends StatefulWidget {
  final ZureTableModel tmSelect;

  const ZureTableDetailScreen({
    Key key,
    @required this.tmSelect,
  }) : super(key: key);

  @override
  _ZureTableDetailScreenState createState() => _ZureTableDetailScreenState();
}

class _ZureTableDetailScreenState extends State<ZureTableDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> tbMap = [];
  var bDecryptData = false;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      _getTableData();
    });
  }

  void _getTableData() async {
    tbMap = await ZureSqliteService.getAllTbRows(widget.tmSelect.sName);
    print('[DB] table data: ${jsonEncode(tbMap)}');
    for (var values in tbMap) {
      for (var key in values.keys) {
        print('[Map] value: $key => ${values[key]}');
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ZureAppBar(
        sTitle: widget.tmSelect.sName,

      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: cOffsetBase,
            vertical: cOffsetMd,
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    bDecryptData = !bDecryptData;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      bDecryptData
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                      color: zurePrimaryColor,
                    ),
                    SizedBox(
                      width: cOffsetBase,
                    ),
                    Text(
                      'Show Decrypt Data',
                      style: cZureBoldTitle,
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () =>
                          ZureNavigatorService(context).zurePushToWidget(
                        pNext: ZureInsertDataScreen(
                          sTable: widget.tmSelect.sName,
                        ),
                        fPopAction: (result) {
                          if (result != null) {
                            ZureNavigatorService(context).zureShowSnackBar(
                              'Success input data (id = $result).',
                              _scaffoldKey,
                            );
                            _getTableData();
                          }
                        },
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: cOffsetBase, vertical: cOffsetSm),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(cOffsetSm),
                          ),
                        ),
                        child: Text(
                          'ADD',
                          style: cZureBoldTitle.copyWith(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: cOffsetBase,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      for (var field in widget.tmSelect.models)
                        Container(
                          width: 120.0,
                          child: Text(
                            field.sName,
                            style: cZureBoldTitle.copyWith(fontSize: cFontMd),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              for (var values in tbMap)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        for (var i = 0; i < values.length; i++)
                          i == 0
                              ? Container(
                                  alignment: Alignment.center,
                                  width: 120.0,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: cOffsetSm),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          var result = await ZureSqliteService.deleteData(widget.tmSelect.sName, 'id', ['${values[values.keys.elementAt(0)]}']);
                                          if (result != null) {
                                            ZureNavigatorService(context).zureShowSnackBar('Success delete item', _scaffoldKey);
                                            _getTableData();
                                          }
                                        },
                                        child: Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(
                                        width: cOffsetBase,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          var result = await ZureSqliteService.deleteData(widget.tmSelect.sName, 'id', ['${values[values.keys.elementAt(0)]}']);
                                          if (result != null) {
                                            ZureNavigatorService(context).zureShowSnackBar('Success delete item', _scaffoldKey);
                                            _getTableData();
                                          }
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(
                                        width: cOffsetBase,
                                      ),
                                      Text(
                                        '${values[values.keys.elementAt(i)]}',
                                        style: cZureBoldTitle.copyWith(
                                            fontSize: cFontMd),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 120.0,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: cOffsetSm),
                                  child: Text(
                                    (bDecryptData &&
                                            widget.tmSelect.models[i].sType ==
                                                'TEXT')
                                        ? ZureStringService.decryptString(
                                            '${values[values.keys.elementAt(i)]}')
                                        : '${values[values.keys.elementAt(i)]}',
                                    style: cZureBoldTitle.copyWith(
                                        fontSize: cFontMd),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
