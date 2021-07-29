import 'package:flutter/material.dart';
import 'package:sqlite_service/components/cAppbar.dart';
import 'package:sqlite_service/components/cButton.dart';
import 'package:sqlite_service/components/cTextField.dart';
import 'package:sqlite_service/scripts/sConstants.dart';
import 'package:sqlite_service/services/svSqlite.dart';
import 'package:sqlite_service/services/svString.dart';
import 'package:sqlite_service/themes/tDimens.dart';
import 'package:sqlite_service/themes/tStyle.dart';

class ZureInitDatabase extends StatefulWidget {
  const ZureInitDatabase({Key key}) : super(key: key);

  @override
  _ZureInitDatabaseState createState() => _ZureInitDatabaseState();
}

class _ZureInitDatabaseState extends State<ZureInitDatabase> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var tcDBName = TextEditingController();
  var tcDBPass = TextEditingController();

  var bValidName = false;
  var bValidPass = false;
  var bValids = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    tcDBName.addListener(() => _validName());
    tcDBPass.addListener(() => _validPassword());
  }

  void _validName() {
    var name = tcDBName.text;
    var validStr = ZureStringService.zureCheckFormatter(name);
    bValidName = validStr.isEmpty;
    setState(() {});
  }

  void _validPassword() {
    var password = tcDBPass.text;

    bool hasUppercase = new RegExp(r'[A-Z]').hasMatch(password);
    bool hasLowercase = new RegExp(r'[a-z]').hasMatch(password);
    bool hasNumber = new RegExp(r'[0-9]').hasMatch(password);
    bool hasSpecialChar =
        new RegExp(r'[`[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    if (hasUppercase &&
        hasLowercase &&
        hasNumber &&
        hasSpecialChar &&
        password.length > 7) {
      bValidPass = true;
    } else {
      bValidPass = false;
    }

    bValids = [
      hasLowercase,
      hasUppercase,
      hasNumber,
      hasSpecialChar,
      password.length > 7,
    ];
    setState(() {});
  }

  @override
  void dispose() {
    tcDBName.dispose();
    tcDBPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: ZureAppBar(
          sTitle: 'Init Database',
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: cOffsetBase,
            vertical: cOffsetMd,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(cOffsetBase),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius:
                        BorderRadius.all(Radius.circular(cOffsetBase)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Database Name',
                        style: cZureBoldTitle.copyWith(fontSize: cFontMd),
                      ),
                      SizedBox(
                        height: cOffsetSm,
                      ),
                      Text(
                        'The Database Name should be only contained a~z, 0~9 and _ (Underline).\nAnd The first character should be only a~z.',
                        style: cZureMediumText.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: cOffsetSm,
                      ),
                      ZureUnderLineTextField(
                        tcController: tcDBName,
                        sHint: 'Database Name',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: cOffsetBase,
                ),
                Container(
                  padding: EdgeInsets.all(cOffsetBase),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius:
                        BorderRadius.all(Radius.circular(cOffsetBase)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Database Password',
                        style: cZureBoldTitle.copyWith(fontSize: cFontMd),
                      ),
                      SizedBox(
                        height: cOffsetSm,
                      ),
                      Text(
                        'The Database Name should be only followed below',
                        style: cZureMediumText,
                      ),
                      SizedBox(
                        height: cOffsetXSm,
                      ),
                      for (var str in scPassValid)
                        Text(
                          str,
                          style: cZureMediumText.copyWith(
                            color: bValids[scPassValid.indexOf(str)]
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      SizedBox(
                        height: cOffsetSm,
                      ),
                      ZureUnderLineTextField(
                        tcController: tcDBPass,
                        sHint: 'Database Password',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: cOffsetLg,),
                ZureFullButton(
                  sTitle: 'Init Database',
                  fAction: (bValidName && bValidPass)? () async {
                    // var bOpen = await ZureSqliteService.initDatabase(tcDBName.text, tcDBPass.text);
                    // Navigator.of(context).pop(bOpen);
                  } : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
