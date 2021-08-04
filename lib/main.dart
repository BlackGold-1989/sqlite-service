import 'package:flutter/material.dart';
import 'package:sqlite_service/pages/pMain.dart';

import 'package:sqlite_service/services/svSqlite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
