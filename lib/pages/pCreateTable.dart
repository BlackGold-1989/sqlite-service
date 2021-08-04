import 'package:flutter/material.dart';
import 'package:sqlite_service/components/cAppbar.dart';
import 'package:sqlite_service/components/cButton.dart';
import 'package:sqlite_service/components/cTextField.dart';
import 'package:sqlite_service/models/mField.dart';
import 'package:sqlite_service/models/mTable.dart';
import 'package:sqlite_service/scripts/sConstants.dart';
import 'package:sqlite_service/services/svNavigator.dart';
import 'package:sqlite_service/services/svString.dart';
import 'package:sqlite_service/themes/tDimens.dart';

class ZureCreateTableScreen extends StatefulWidget {
  const ZureCreateTableScreen({Key key}) : super(key: key);

  @override
  _ZureCreateTableScreenState createState() => _ZureCreateTableScreenState();
}

class _ZureCreateTableScreenState extends State<ZureCreateTableScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var mtCreateTable = ZureTableModel(sName: '', models: []);
  var tcTableName = TextEditingController();

  var sTableNameError = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tcTableName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: ZureAppBar(
          sTitle: 'Create Table',
          fActions: [
            IconButton(
              onPressed: () async {
                if (checkNameValid()) {
                  mtCreateTable.sName = tcTableName.text;
                  await mtCreateTable.create();
                  Navigator.of(context).pop(true);
                }
              },
              icon: Icon(Icons.done),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: cOffsetBase,
            vertical: cOffsetMd,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ZureUnderLineTextField(
                      tcController: tcTableName,
                      sHint: 'Table Name',
                      sError:
                          sTableNameError.isNotEmpty ? sTableNameError : null,
                    ),
                  ),
                  SizedBox(
                    width: cOffsetBase,
                  ),
                  ZureFullButton(
                    dWidth: 80,
                    sTitle: 'Add Field',
                    dHeight: 28.0,
                    dFontSize: cFontBase,
                    fAction: () {
                      var mf = ZureFieldModel(sName: '', sType: scFieldType[0]);
                      mtCreateTable.add(mf);
                      setState(() {});
                    },
                  ),
                ],
              ),
              SizedBox(
                height: cOffsetBase,
              ),
              for (var model in mtCreateTable.models)
                model.itemWidget(changeName: (name) {
                  model.sName = name;
                }, changeType: (type) {
                  setState(() {
                    model.sType = type;
                  });
                }, remove: () {
                  setState(() {
                    mtCreateTable.models.remove(model);
                  });
                }, checkPrimary: () {
                  var hasNotPrimary = true;
                  for (var item in mtCreateTable.models) {
                    if (item.bPrimary && item != model) {
                      hasNotPrimary = false;
                    }
                  }
                  if (hasNotPrimary) {
                    setState(() {
                      model.bPrimary = !model.bPrimary;
                    });
                  } else {
                    ZureNavigatorService(context).zureShowSnackBar(
                      'You can choose only one primary key',
                      _scaffoldKey,
                      type: ZureSnackBarType.INFO,
                    );
                  }
                }),
            ],
          ),
        ),
      ),
    );
  }

  bool checkNameValid() {
    var bCheckValid = true;
    if (mtCreateTable.models.isEmpty) {
      bCheckValid = false;
      ZureNavigatorService(context).zureShowSnackBar(
        'You should add some field for creating table',
        _scaffoldKey,
        type: ZureSnackBarType.ERROR,
      );
      return false;
    }
    var sTableNameValid =
        ZureStringService.zureCheckFormatter(tcTableName.text);
    sTableNameError = sTableNameValid;
    if (sTableNameValid.isNotEmpty && bCheckValid) {
      bCheckValid = false;
    }
    List<String> lNames = [];
    for (var model in mtCreateTable.models) {
      var sNameValid = ZureStringService.zureCheckFormatter(model.sName);
      model.sError = sNameValid;
      lNames.add(model.sName);
      if (sNameValid.isNotEmpty && bCheckValid) {
        bCheckValid = false;
      }
    }
    setState(() {});
    return bCheckValid;
  }
}
