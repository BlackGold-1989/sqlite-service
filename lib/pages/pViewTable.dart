import 'package:flutter/material.dart';
import 'package:sqlite_service/components/cAppbar.dart';

class ZureViewTable extends StatefulWidget {
  const ZureViewTable({Key key}) : super(key: key);

  @override
  _ZureViewTableState createState() => _ZureViewTableState();
}

class _ZureViewTableState extends State<ZureViewTable> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ZureAppBar(
        sTitle: 'View Table',
      ),
    );
  }
}
