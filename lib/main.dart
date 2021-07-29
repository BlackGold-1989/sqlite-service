import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqlite_service/pages/pMain.dart';
import 'dart:async';

import 'package:sqlite_service/services/svSqlite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ZureSqliteService.initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ZureMainScreen(),
    );
  }
}
