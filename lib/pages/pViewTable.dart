import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqlite_service/components/cAppbar.dart';
import 'package:sqlite_service/models/mTable.dart';
import 'package:sqlite_service/pages/pTableDetail.dart';
import 'package:sqlite_service/services/svNavigator.dart';
import 'package:sqlite_service/services/svSqlite.dart';
import 'package:sqlite_service/themes/tDimens.dart';

class ZureViewTableScreen extends StatefulWidget {
  const ZureViewTableScreen({Key key}) : super(key: key);

  @override
  _ZureViewTableScreenState createState() => _ZureViewTableScreenState();
}

class _ZureViewTableScreenState extends State<ZureViewTableScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ZureTableModel> tbModels = [];

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      _getTableData();
    });
  }

  void _getTableData() async {
    tbModels.clear();
    var tbList = await ZureSqliteService.zureAllTableList();
    for (var tbName in tbList) {
      var tbModel = await ZureSqliteService.zureTable(tbName);
      tbModels.add(tbModel);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ZureAppBar(
        sTitle: 'View Table',
      ),
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: cOffsetBase, vertical: cOffsetMd),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: tbModels.length,
          itemBuilder: (context, i) {
            return tbModels[i].wReadOnlyWidget(
              view: () {
                ZureNavigatorService(context).zurePushToWidget(
                  pNext: ZureTableDetailScreen(tmSelect: tbModels[i]),
                  fPopAction: (val) => _getTableData(),
                );
              },
              edit: () {
                ZureNavigatorService(context)
                    .zureShowSnackBar('Not added yet', _scaffoldKey);
              },
              remove: () {},
            );
          },
        ),
      ),
    );
  }
}
