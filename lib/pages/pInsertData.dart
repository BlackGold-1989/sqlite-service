import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqlite_service/components/cAppbar.dart';
import 'package:sqlite_service/components/cButton.dart';
import 'package:sqlite_service/components/cTextField.dart';
import 'package:sqlite_service/models/mTable.dart';
import 'package:sqlite_service/scripts/sConstants.dart';
import 'package:sqlite_service/services/svNavigator.dart';
import 'package:sqlite_service/services/svSqlite.dart';
import 'package:sqlite_service/services/svString.dart';
import 'package:sqlite_service/themes/tColors.dart';
import 'package:sqlite_service/themes/tDimens.dart';
import 'package:sqlite_service/themes/tStyle.dart';

class ZureInsertDataScreen extends StatefulWidget {
  final String sTable;

  const ZureInsertDataScreen({Key key, this.sTable}) : super(key: key);

  @override
  _ZureInsertDataScreenState createState() => _ZureInsertDataScreenState();
}

class _ZureInsertDataScreenState extends State<ZureInsertDataScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var bManual = false;

  List<String> sTableNames = [];
  var sTableName = '';
  var tSQLSelected = ZureTableModel(sName: '', models: []);

  List<TextEditingController> tcTableData = [];

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      _getTableNames();
    });
  }

  void dispose() {
    for (var tcTable in tcTableData) {
      tcTable.dispose();
    }
    super.dispose();
  }

  void _getTableNames() async {
    sTableNames.clear();
    sTableNames = await ZureSqliteService.zureAllTableList();
    if (widget.sTable == null) {
      sTableName = sTableNames.first;
    } else {
      sTableName = widget.sTable;
    }

    _getTableFields();
  }

  void _getTableFields() async {
    tSQLSelected = await ZureSqliteService.zureTable(sTableName);
    tcTableData.clear();
    // ignore: unused_local_variable
    for (var field in tSQLSelected.models) {
      tcTableData.add(TextEditingController());
    }
    setState(() {});
  }

  Widget _manualWidget() {
    return Container();
  }

  Widget _autoWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sTableNames.isNotEmpty)
          Row(
            children: [
              Text(
                'Select Table',
                style: cZureBoldTitle,
              ),
              SizedBox(
                width: cOffsetLg,
              ),
              Expanded(
                child: DropdownButton<String>(
                  underline: Container(),
                  items: sTableNames.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: cZureMediumText,
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    sTableName,
                    style: cZureMediumText,
                  ),
                  onChanged: (value) async {
                    sTableName = value;
                    await _getTableFields();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        SizedBox(
          height: cOffsetBase,
        ),
        Text(
          'Input Values',
          style: cZureBoldTitle,
        ),
        SizedBox(
          height: cOffsetSm,
        ),
        Text(
          'You should input at least one value. But you can input the primary key value.',
          style: cZureMediumText.copyWith(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: cOffsetSm,
        ),
        if (tSQLSelected.sName.isNotEmpty)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(cOffsetBase),),
            ),
            child: Container(
              padding: EdgeInsets.all(cOffsetBase),
              child: Column(
                children: [
                  for (var field in tSQLSelected.models)
                    Container(
                      padding: EdgeInsets.only(
                        left: cOffsetSm,
                        top: (field.bPrimary ? cOffsetBase : cOffsetSm),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              field.sName,
                              style: cZureBoldTitle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              field.sType,
                              style: cZureBoldTitle,
                            ),
                          ),
                          Expanded(
                            child: field.bPrimary
                                ? Text(
                              'Primary Data',
                              style: cZureMediumText,
                            )
                                : ZureUnderLineTextField(
                              tcController:
                              tcTableData[tSQLSelected.models.indexOf(field)],
                              ttKeyBoard: field.sType == scFieldType[1]
                                  ? TextInputType.text
                                  : TextInputType.number,
                              sHint: 'Field Value',
                              bReadOnly: field.bPrimary,
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: ZureAppBar(
          sTitle: 'Insert Data',
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: cOffsetBase, vertical: cOffsetMd),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      bManual = !bManual;
                    });
                    if (!bManual) {
                      _getTableNames();
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        bManual
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: zurePrimaryColor,
                      ),
                      SizedBox(
                        width: cOffsetBase,
                      ),
                      Text(
                        'Manual Option',
                        style: cZureBoldTitle,
                      ),
                    ],
                  ),
                ),
                bManual ? _manualWidget() : _autoWidget(),
                SizedBox(
                  height: cOffsetLg,
                ),
                ZureFullButton(
                  sTitle: 'Insert Data',
                  fAction: () => _checkQuery(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkQuery() async {
    var isCheck = false;
    Map<String, String> tbMap = Map<String, String>();
    for (var controller in tcTableData) {
      if (controller.text.isNotEmpty) {
        isCheck = true;
        tbMap[tSQLSelected.models[tcTableData.indexOf(controller)].sName] =
            tSQLSelected.models[tcTableData.indexOf(controller)].sType == 'TEXT'
                ? ZureStringService.encryptString(controller.text)
                : controller.text;
      }
    }
    if (isCheck) {
      print('[DB insert] data: ${jsonEncode(tbMap)}');
      var result = await ZureSqliteService.insertData(sTableName, tbMap);
      if (result != null) {
        Navigator.of(context).pop(result);
      }
    } else {
      ZureNavigatorService(context).zureShowSnackBar(
          'Please input some data.', _scaffoldKey,
          type: ZureSnackBarType.ERROR);
    }
  }
}
