import 'package:flutter/material.dart';
import 'package:sqlite_service/themes/tDimens.dart';
import 'package:sqlite_service/themes/tStyle.dart';

class ZureNavigatorService {
  final BuildContext context;

  ZureNavigatorService(this.context);

  void zurePushToWidget({
    @required Widget pNext,
    bool bReplace = false,
    Function(dynamic) fPopAction,
  }) {
    if (bReplace) {
      Navigator.of(context)
          .pushReplacement(
              MaterialPageRoute<Object>(builder: (context) => pNext))
          .then((value) => {if (fPopAction != null) fPopAction(value)});
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute<Object>(builder: (context) => pNext))
          .then((value) => {if (fPopAction != null) fPopAction(value)});
    }
  }

  void zureShowCustomBottomModal(Widget pChild) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(cOffsetBase),
            topLeft: Radius.circular(cOffsetBase),
          ),
        ),
        backgroundColor: Colors.blueGrey,
        builder: (_) => Container(
              padding: EdgeInsets.all(cOffsetBase),
              child: pChild,
            ));
  }

  void zureShowSnackBar(
    String sContent,
    GlobalKey<ScaffoldState> gScaffoldKey, {
    ZureSnackBarType type = ZureSnackBarType.SUCCESS,
  }) {
    var backgroundColor = Colors.white;
    switch (type) {
      case ZureSnackBarType.SUCCESS:
        backgroundColor = Colors.green;
        break;
      case ZureSnackBarType.WARING:
        backgroundColor = Colors.orange;
        break;
      case ZureSnackBarType.INFO:
        backgroundColor = Colors.blueGrey;
        break;
      case ZureSnackBarType.ERROR:
        backgroundColor = Colors.red;
        break;
    }

    // ignore: deprecated_member_use
    gScaffoldKey.currentState.showSnackBar(SnackBar(
      content: Card(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cOffsetSm)),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.all(cOffsetBase),
          child: Text(
            sContent,
            style: cZureMediumText.copyWith(
              fontSize: cFontMd,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: Duration(milliseconds: 1500),
    ));
  }
}

enum ZureSnackBarType { SUCCESS, WARING, INFO, ERROR }
