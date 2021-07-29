import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:sqlite_service/components/cTextField.dart';
import 'package:sqlite_service/scripts/sConstants.dart';
import 'package:sqlite_service/themes/tColors.dart';
import 'package:sqlite_service/themes/tDimens.dart';
import 'package:sqlite_service/themes/tStyle.dart';

class ZureFieldModel {
  String sName;
  String sType;
  bool bPrimary;
  String sError;

  ZureFieldModel({
    this.sName,
    this.sType,
    this.sError = '',
    this.bPrimary = false,
  });

  Widget itemWidget({
    Function() remove,
    Function() checkPrimary,
    Function(String) changeType,
    Function(String) changeName,
  }) {
    var controller = TextEditingController();
    controller.text = sName;
    controller.addListener(() => changeName(controller.text));

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(cOffsetBase)),
      ),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(cOffsetBase),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () => remove(),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'Field Name: ',
                  style: cZureBoldTitle,
                ),
                SizedBox(
                  width: cOffsetBase,
                ),
                Expanded(
                  child: ZureUnderLineTextField(
                    tcController: controller,
                    sError: sError.isNotEmpty ? sError : null,
                    sHint: 'Allow only a~z, 0~9 and _ (Underline)',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: cOffsetSm,
            ),
            Row(
              children: [
                Text(
                  'Field Type: ',
                  style: cZureBoldTitle,
                ),
                SizedBox(
                  width: cOffsetBase,
                ),
                Expanded(
                    child: DropdownButton<String>(
                  underline: Container(),
                  items: scFieldType.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: cZureMediumText,
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    sType,
                    style: cZureMediumText,
                  ),
                  onChanged: (value) {
                    changeType(value);
                  },
                )),
              ],
            ),
            SizedBox(
              height: cOffsetSm,
            ),
            InkWell(
              onTap: () => checkPrimary(),
              child: Row(
                children: [
                  Text(
                    'Primary Key: ',
                    style: cZureBoldTitle,
                  ),
                  SizedBox(
                    width: cOffsetBase,
                  ),
                  Icon(
                    bPrimary ? Icons.check_box : Icons.check_box_outline_blank,
                    color: zurePrimaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sName': sName,
      'sType': sType,
      'bPrimary': bPrimary,
    };
  }

  factory ZureFieldModel.fromMap(Map<String, dynamic> map) {
    return ZureFieldModel(
      sName: map['sName'],
      sType: map['sType'],
      bPrimary: map['bPrimary'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ZureFieldModel.fromJson(String source) =>
      ZureFieldModel.fromMap(json.decode(source));
}
