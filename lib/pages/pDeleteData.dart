import 'package:flutter/material.dart';

import '../components/cAppbar.dart';

class ZureDeleteDataScreen extends StatefulWidget {
  const ZureDeleteDataScreen({Key key}) : super(key: key);

  @override
  _ZureDeleteDataScreenState createState() => _ZureDeleteDataScreenState();
}

class _ZureDeleteDataScreenState extends State<ZureDeleteDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZureAppBar(
        sTitle: 'Delete Data',
      ),
    );
  }
}
