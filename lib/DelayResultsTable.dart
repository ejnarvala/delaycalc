import 'package:flutter/material.dart';

import 'DelayCalculator.dart';
import 'package:delaycalc/utils.dart';

class DelayResultsTable extends StatelessWidget {
  final DelayCalculator delayCalc;
  DelayResultsTable(this.delayCalc);

  TableRow resultTableRow(String first, String second) => TableRow(
    children: [
      Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text(first, style: TextStyle(fontSize: 18)))),
      Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text(second, style: TextStyle(fontSize: 18))))
    ]
  );

  @override
  Widget build(BuildContext context) => Table(
    border: TableBorder.all(color: Colors.black45),
    children: [
      resultTableRow("[0X] Delay Time", delayCalc.delayTime0x.toHoursMinutesString()),
      resultTableRow("[??] Delay Time", delayCalc.delayTime.toHoursMinutesString()),
      resultTableRow("Total Delay Time", delayCalc.totalDelayTime.toHoursMinutesString()),
      resultTableRow("[09] Delay Time", delayCalc.delayTime09.toHoursMinutesString()),
    ],
  );
}