import 'package:delaycalc/consts.dart';
import 'package:flutter/material.dart';

DateTime readMilitaryInput(String text) {
  assert(text.length == 4);
  var hr = int.parse(text.substring(0, 2));
  var mi = int.parse(text.substring(2, 4));
  var now = DateTime.now();
  var out = DateTime(now.year, now.month, now.day, hr, mi);
  return out;
}


String validateTimeInput(String timeInput) {
  if (timeInput.length < TIME_INPUT_CHAR_LENGTH)
    return 'Must contain $TIME_INPUT_CHAR_LENGTH characters';
  return null;
}


void showAlertDialog(String title, String content, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          FlatButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      );
    },
  );
}

String fieldHelpText({bool scheduled = false, bool inbound = false}) => "Input the ORIGINALLY local ${scheduled ? "Skd" : "Act"} In Time of the ${inbound ? "In" : "Out"}bound flight.  Format:  Military Time, 4 digits (Ex. 0900).  Do not insert a colon ':'";

String twoDigits(int n) => n.toString().padLeft(2, "0");

extension ExtendedDuration on Duration {
  String toHoursMinutesString() {
    if (this.inHours > 0) return "${twoDigits(this.inHours)}${twoDigits(this.inMinutes.remainder(60))}";
    return this.inMinutes.toString();
  }
}