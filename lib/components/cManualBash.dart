import 'package:flutter/material.dart';

import '../themes/tDimens.dart';
import '../themes/tStyle.dart';

class ZureManualBashWidget extends StatelessWidget {
  final TextEditingController controller;
  final String sSample;

  const ZureManualBashWidget({
    Key key,
    @required this.controller,
    @required this.sSample,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: cOffsetBase,
        ),
        Text(
          'That is a bash command insert option.',
          style: cZureBoldTitle.copyWith(fontSize: cFontMd),
        ),
        SizedBox(
          height: cOffsetSm,
        ),
        Text(
          'The below command is a sample command for insert data.',
          style: cZureBoldTitle.copyWith(fontSize: cFontMd),
        ),
        SizedBox(
          height: cOffsetSm,
        ),
        Text(
          sSample,
          style: cZureMediumText.copyWith(
              fontStyle: FontStyle.italic, color: Colors.black54),
        ),
        SizedBox(
          height: cOffsetSm,
        ),
        Text(
          '* IMPORTANT \nIf you use manual command, you can\'t get a callback result(success or failed of command running)',
          style: cZureMediumText.copyWith(color: Colors.red),
        ),
        SizedBox(
          height: cOffsetSm,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(cOffsetSm)),
          ),
          child: Container(
            padding: EdgeInsets.all(cOffsetSm),
            child: TextField(
              minLines: 3,
              maxLines: 5,
              controller: controller,
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintText: 'Please input one command for insert data.'),
            ),
          ),
        ),
      ],
    );
  }
}
