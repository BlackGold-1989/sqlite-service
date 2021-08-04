import 'package:flutter/material.dart';
import 'package:sqlite_service/components/cAppbar.dart';
import 'package:sqlite_service/components/cButton.dart';
import 'package:sqlite_service/pages/pCreateTable.dart';
import 'package:sqlite_service/pages/pInsertData.dart';
import 'package:sqlite_service/pages/pViewTable.dart';
import 'package:sqlite_service/services/svNavigator.dart';
import 'package:sqlite_service/services/svSqlite.dart';
import 'package:sqlite_service/themes/tDimens.dart';


class ZureMainScreen extends StatefulWidget {
  const ZureMainScreen({Key key}) : super(key: key);

  @override
  _ZureMainScreenState createState() => _ZureMainScreenState();
}

class _ZureMainScreenState extends State<ZureMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ZureSqliteService.initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ZureAppBar(
        sTitle: 'Sqlite Management',
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: cOffsetBase,
            vertical: cOffsetMd,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ZureFullButton(
              //   sTitle: 'Init Database',
              //   fAction: () => ZureNavigatorService(context).zurePushToWidget(
              //     pNext: ZureInitDatabaseScreen(),
              //     fPopAction: (bOpen) {
              //       if (bOpen) {
              //         ZureNavigatorService(context).zureShowSnackBar(
              //             'Securit Database Created!', _scaffoldKey);
              //       }
              //     },
              //   ),
              // ),
              // SizedBox(
              //   height: cOffsetBase,
              // ),
              ZureFullButton(
                sTitle: 'Create Table',
                fAction: () => ZureNavigatorService(context).zurePushToWidget(
                    pNext: ZureCreateTableScreen(),
                    fPopAction: (bCreate) {
                      if (bCreate) {
                        ZureNavigatorService(context).zureShowSnackBar(
                            'Successful Created Table!', _scaffoldKey);
                      }
                    }),
              ),
              SizedBox(
                height: cOffsetBase,
              ),
              ZureFullButton(
                sTitle: 'View Table',
                fAction: () => ZureNavigatorService(context)
                    .zurePushToWidget(pNext: ZureViewTableScreen()),
              ),
              SizedBox(
                height: cOffsetBase,
              ),
              ZureFullButton(
                sTitle: 'Insert Data',
                fAction: () => ZureNavigatorService(context)
                    .zurePushToWidget(pNext: ZureInsertDataScreen()),
              ),
              SizedBox(
                height: cOffsetBase,
              ),
              ZureFullButton(
                sTitle: 'Update Data',
                fAction: () {},
              ),
              SizedBox(
                height: cOffsetBase,
              ),
              ZureFullButton(
                sTitle: 'Delete Data',
                fAction: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
