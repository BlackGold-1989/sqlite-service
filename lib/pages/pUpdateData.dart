import 'package:flutter/material.dart';
import 'package:sqlite_service/components/cAppbar.dart';
import 'package:sqlite_service/components/cManualBash.dart';
import 'package:sqlite_service/themes/tDimens.dart';

import '../components/cButton.dart';
import '../models/mTable.dart';
import '../services/svNavigator.dart';
import '../services/svSqlite.dart';
import '../themes/tColors.dart';
import '../themes/tStyle.dart';

class ZureUpdateDataScreen extends StatefulWidget {
  final String sTable;

  const ZureUpdateDataScreen({
    Key key,
    this.sTable,
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
    setState(() {});
  }

  Widget _autoWidget() {
    return Container();
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
                sSample: 'UPDATE employees SET city = \'Toronto\', state = \'ON\', postalcode = \'M5P 2N7\' WHERE employeeid = 4;',
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

    }
  }
}
