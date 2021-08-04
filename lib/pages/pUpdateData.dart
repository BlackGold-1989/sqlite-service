import 'package:flutter/material.dart';
import 'package:sqlite_service/components/cAppbar.dart';
import 'package:sqlite_service/themes/tDimens.dart';

class ZureUpdateDataScreen extends StatefulWidget {
  const ZureUpdateDataScreen({Key key}) : super(key: key);

  @override
  _ZureUpdateDataScreenState createState() => _ZureUpdateDataScreenState();
}

class _ZureUpdateDataScreenState extends State<ZureUpdateDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZureAppBar(
        sTitle: 'Update Data',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: cOffsetBase, vertical: cOffsetMd,),
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
