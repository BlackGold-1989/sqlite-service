import 'package:flutter/material.dart';
import 'package:sqlite_service/components/cAppbar.dart';
import 'package:sqlite_service/components/cManualBash.dart';
import 'package:sqlite_service/themes/tDimens.dart';

import '../components/cButton.dart';
import '../components/cTextField.dart';
import '../models/mTable.dart';
import '../scripts/sConstants.dart';
import '../services/svNavigator.dart';
import '../services/svSqlite.dart';
import '../services/svString.dart';
import '../themes/tColors.dart';
import '../themes/tStyle.dart';

class ZureUpdateDataScreen extends StatefulWidget {
  final String sTable;
  final dynamic dItemData;

  const ZureUpdateDataScreen({
    Key key,
    this.sTable,
    this.dItemData,
  }) : super(key: key);

  @override
  _ZureUpdateDataScreenState createState() => _ZureUpdateDataScreenState();
}

class _ZureUpdateDataScreenState extends State<ZureUpdateDataScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var bManual = false;

  List<String> sTableNames = [];
  var sTableName = '';
  var tSQLSelected = ZureTableModel(sName: '', models: []);

  List<TextEditingController> tcConditionTableData = [];
  List<TextEditingController> tcUpdateTableData = [];

  var tcManualCommand = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getTableNames();
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
    tcConditionTableData.clear();
    tcUpdateTableData.clear();
    // ignore: unused_local_variable
    for (var field in tSQLSelected.models) {
      tcConditionTableData.add(TextEditingController());
      tcUpdateTableData.add(TextEditingController());
    }
    if (widget.dItemData != null) {
      for (var controller in tcConditionTableData) {
        var i = tcConditionTableData.indexOf(controller);
        var itemData = (tSQLSelected.models[i].sType == 'TEXT')
            ? ZureStringService.decryptString(
                '${widget.dItemData[widget.dItemData.keys.elementAt(i)]}')
            : '${widget.dItemData[widget.dItemData.keys.elementAt(i)]}';
        controller.text = itemData;
      }
    }
    setState(() {});
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
          'Update Values',
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Item Condition',
            style: cZureBoldTitle,
          ),
        ),
        if (tSQLSelected.sName.isNotEmpty)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(cOffsetBase),
              ),
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
                                    tcController: tcConditionTableData[
                                        tSQLSelected.models.indexOf(field)],
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Item Values',
            style: cZureBoldTitle,
          ),
        ),
        if (tSQLSelected.sName.isNotEmpty)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(cOffsetBase),
              ),
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
                                    tcController: tcUpdateTableData[
                                        tSQLSelected.models.indexOf(field)],
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: ZureAppBar(
        sTitle: 'Update Data',
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
                    bManual = !bManual;
                  });
                  if (!bManual) {
                    _getTableNames();
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      bManual ? Icons.check_box : Icons.check_box_outline_blank,
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
              bManual
                  ? ZureManualBashWidget(
                      controller: tcManualCommand,
                      sSample:
                          'UPDATE employees SET city = \'Toronto\', state = \'ON\', postalcode = \'M5P 2N7\' WHERE employeeid = 4;',
                    )
                  : _autoWidget(),
              SizedBox(
                height: cOffsetLg,
              ),
              ZureFullButton(
                sTitle: 'Update Data',
                fAction: () => _checkQuery(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkQuery() async {
    if (bManual) {
      var command = tcManualCommand.text;
      if (command.isEmpty) {
        ZureNavigatorService(context).zureShowSnackBar(
            'Please input some words.', _scaffoldKey,
            type: ZureSnackBarType.ERROR);
        return;
      }
      var result = await ZureSqliteService.command(command);
      if (result.isEmpty) {
        Navigator.of(context).pop();
      } else {
        ZureNavigatorService(context).zureShowSnackBar(result, _scaffoldKey,
            type: ZureSnackBarType.ERROR);
      }
    } else {
      var isConditionCheck = false;
      Map<String, String> tbConditionMap = Map<String, String>();
      for (var controller in tcConditionTableData) {
        if (controller.text.isNotEmpty) {
          isConditionCheck = true;
          tbConditionMap[tSQLSelected.models[tcConditionTableData.indexOf(controller)].sName] =
          tSQLSelected.models[tcConditionTableData.indexOf(controller)].sType ==
              'TEXT'
              ? ZureStringService.encryptString(controller.text)
              : controller.text;
        }
      }

      var isItemCheck = false;
      Map<String, String> tbItemMap = Map<String, String>();
      for (var controller in tcUpdateTableData) {
        if (controller.text.isNotEmpty) {
          isItemCheck = true;
          tbItemMap[tSQLSelected.models[tcUpdateTableData.indexOf(controller)].sName] =
          tSQLSelected.models[tcUpdateTableData.indexOf(controller)].sType ==
              'TEXT'
              ? ZureStringService.encryptString(controller.text)
              : controller.text;
        }
      }
      if (isConditionCheck && isItemCheck) {
        var result = await ZureSqliteService.updateData(tSQLSelected.sName, tbItemMap, 'id', [tbConditionMap['id']]);
        if (result != null) {
          Navigator.of(context).pop(result);
        } else {
          ZureNavigatorService(context).zureShowSnackBar(
              'Failed update some data.', _scaffoldKey,
              type: ZureSnackBarType.ERROR);
        }
      }
    }
  }
}
