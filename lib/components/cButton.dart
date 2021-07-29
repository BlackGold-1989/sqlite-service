import 'package:flutter/material.dart';
import 'package:sqlite_service/themes/tColors.dart';
import 'package:sqlite_service/themes/tDimens.dart';
import 'package:sqlite_service/themes/tStyle.dart';

// ignore: deprecated_member_use
class ZureFullButton extends FlatButton {
  ZureFullButton({
    String sTitle,
    Widget wTitle,
    Color cColor = zurePrimaryColor,
    void Function() fAction,
    Color cTextColor = Colors.white,
    double cButtonRadius = cOffsetSm,
    double dHeight = cHeightButton,
    double dWidth,
    double dFontSize = cFontMd,
    // ignore: deprecated_member_use
  }) : super(
          child: Container(
            height: dHeight,
            alignment: Alignment.center,
            width: dWidth == null
                ? double.maxFinite
                : dWidth == 0
                    ? null
                    : dWidth,
            margin: EdgeInsets.symmetric(vertical: cOffsetXSm),
            child: wTitle == null
                ? Text(
                    sTitle,
                    textAlign: TextAlign.center,
                    style: cZureTitle.copyWith(
                      color: cTextColor,
                      fontSize: dFontSize,
                    ),
                  )
                : wTitle,
          ),
          onPressed: fAction,
          color: cColor,
          disabledColor: cColor.withOpacity(0.5),
          textColor: cTextColor,
          disabledTextColor: cTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cButtonRadius),
          ),
        );
}
