import 'package:flutter/material.dart';
import 'package:sqlite_service/themes/tStyle.dart';

class ZureUnderLineTextField extends TextField {
  ZureUnderLineTextField({
    TextEditingController tcController,
    TextInputType ttKeyBoard = TextInputType.text,
    String sHint,
    String sError,
    Widget wPrefix,
    Widget wSuffix,
  }) : super(
    controller: tcController,
    keyboardType: ttKeyBoard,
    cursorColor: Colors.black,
    style: cZureMediumText,
    decoration: InputDecoration(
      hintText: sHint,
      contentPadding: EdgeInsets.zero,
      enabledBorder: UnderlineInputBorder(),
      border: UnderlineInputBorder(),
      errorBorder: UnderlineInputBorder(),
      disabledBorder: UnderlineInputBorder(),
      focusedBorder: UnderlineInputBorder(),
      focusedErrorBorder: UnderlineInputBorder(),
      prefix: wPrefix,
      suffix: wSuffix,
      errorText: sError
    ),
  );
}
