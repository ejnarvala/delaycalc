import 'dart:math';

import 'Aircraft.dart';
import 'consts.dart';

class DelayCalculator {
  DateTime scheduledArrival, actualArrival, scheduledDeparture, actualDeparture;
  Duration delayTime0x, totalDelayTime, delayTime, delayTime09;

  DelayCalculator({this.scheduledArrival, this.actualArrival, this.scheduledDeparture, this.actualDeparture, crewChange = false, aircraft = Aircraft.A320}) {
    if (scheduledDeparture == scheduledArrival) {
      throw DelayCalcValidationException("No delay ya dummy");
    } else if (scheduledDeparture.isBefore(scheduledArrival)) {
      throw DelayCalcValidationException("Check ya math einstein (departure is before arrival"); // 09 delay code not acceptable for this flight
    }


    var actualTurnTime = actualDeparture.difference(actualArrival);
    var scheduledTurnTime = scheduledDeparture.difference(scheduledArrival);

    totalDelayTime = actualDeparture.difference(scheduledDeparture);
    var standardTurnTime = AircraftDelayMap[aircraft] + Duration(minutes: (crewChange ? 5 : 0 ));
    if (scheduledTurnTime > standardTurnTime) {
      if (scheduledTurnTime.inMinutes > 90) scheduledTurnTime = Duration(minutes: 90);
      standardTurnTime = scheduledTurnTime;
    }

//    [??]
    var departureSequence = Duration(minutes: min(0, actualArrival.difference(scheduledArrival).inMinutes));
    var delayTimeRemainder = Duration(minutes: max(0, ((actualTurnTime + departureSequence) - scheduledTurnTime).inMinutes));
    delayTimeRemainder = Duration(minutes: min(delayTimeRemainder.inMinutes, totalDelayTime.inMinutes));

//    [0X]
    delayTime0x = scheduledArrival.isAfter(actualArrival) ? 0 : Duration(minutes: min((actualArrival.difference(scheduledArrival)).inMinutes, (totalDelayTime - delayTimeRemainder).inMinutes));

//    [??]
    delayTimeRemainder = totalDelayTime - delayTime0x;

//    [09]
    delayTime09 = Duration(minutes: max(0, (standardTurnTime - scheduledTurnTime).inMinutes));
    delayTime09 = Duration(minutes: min(delayTime09.inMinutes, totalDelayTime.inMinutes));
    delayTime09 = Duration(minutes: min(delayTime09.inMinutes, delayTimeRemainder.inMinutes));

    delayTime = delayTimeRemainder;
  }

}


class DelayCalcValidationException implements Exception {
  final String message;
  const DelayCalcValidationException([this.message = ""]);

  @override
  String toString() => message;
}
