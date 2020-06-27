import 'package:delaycalc/consts.dart';
import 'package:delaycalc/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeInputFormField extends StatelessWidget {
  final String title;
  final Key formFieldKey;
  final String helpText;
  final bool iconUp;
  final bool focusNext;
  final ValueChanged<String> onFieldSubmitted;

  TimeInputFormField({this.title, this.formFieldKey, this.helpText, this.focusNext = true, this.iconUp = false, this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
        key: formFieldKey,
        decoration: InputDecoration(
            labelText: title,
            prefixIcon: Icon((iconUp) ? Icons.flight_takeoff : Icons.flight_land),
            suffixIcon: IconButton(
              icon: Icon(Icons.help),
              onPressed: () => showAlertDialog("$title Info", helpText, context),
            ),
            border: OutlineInputBorder()
        ),
        textInputAction: ((focusNext) ? TextInputAction.next : TextInputAction.done),
        keyboardType: TextInputType.number,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(TIME_INPUT_CHAR_LENGTH)
        ],
        onFieldSubmitted: onFieldSubmitted,
        validator: validateTimeInput
    ),
  );
}
