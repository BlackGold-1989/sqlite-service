import 'package:flutter/material.dart';
import 'package:sqlite_service/themes/tStyle.dart';

class ZureAppBar extends AppBar {
  ZureAppBar({
    String sTitle,
    Widget wTitle,
    List<Widget> fActions,
  }) : super(
    title: wTitle?? Text(sTitle, style: cZureTitle,),
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    centerTitle: true,
    actions: fActions,
    iconTheme: IconThemeData(color: Colors.black),
  );
}
