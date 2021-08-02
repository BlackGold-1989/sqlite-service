import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sqlite_service/components/cAppbar.dart';
import 'package:sqlite_service/themes/tColors.dart';
import 'package:sqlite_service/themes/tDimens.dart';

class ZureInsertDataScreen extends StatefulWidget {
  const ZureInsertDataScreen({Key key}) : super(key: key);

  @override
  _ZureInsertDataScreenState createState() => _ZureInsertDataScreenState();
}

class _ZureInsertDataScreenState extends State<ZureInsertDataScreen> {
  var bManual = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text(bManual ? 'Manual Option' : 'Auto Correction'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
