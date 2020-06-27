import 'dart:math';

import 'Aircraft.dart';
import 'consts.dart';

class DelayCalculator {
  DateTime scheduledArrival, actualArrival, scheduledDeparture, actualDeparture;
  Duration delayTime0x, totalDelayTime, delayTimeQQ, delayTime09;

  Duration calculateScheduledTurnTime({DateTime scheduledDeparture, DateTime scheduledArrival, Duration standardTurnTime}) {
    var scheduledTurnTime = scheduledDeparture.difference(scheduledArrival);
    if (scheduledTurnTime > standardTurnTime) {
      if (scheduledTurnTime.inMinutes > 90) scheduledTurnTime = Duration(minutes: 90);
      standardTurnTime = scheduledTurnTime;
    }
    return scheduledTurnTime;
  }

  Duration calculateStandardTurnTime({Aircraft aircraft, bool crewChange}) => AircraftDelayMap[aircraft] + Duration(minutes: (crewChange ? 5 : 0 ));

  Duration calculateActualTurnTime({DateTime actualDeparture, DateTime actualArrival}) => actualDeparture.difference(actualArrival);

  Duration calculateTotalDelayTime({DateTime scheduledDeparture, DateTime actualDeparture}) => actualDeparture.difference(scheduledDeparture);

  Duration calculateDelayTimeQQ({Duration totalDelayTime, Duration delayTime0x}) => totalDelayTime - delayTime0x;

  Duration calculateDelayTime0x({DateTime actualArrival, DateTime scheduledArrival, Duration actualTurnTime, Duration scheduledTurnTime, Duration totalDelayTime}) {
    var totalDelayTimeMin = totalDelayTime.inMinutes;
    var arrivalDifferenceMin = actualArrival.difference(scheduledArrival).inMinutes;
    var departureSequenceMin = min(0, arrivalDifferenceMin);
    var delayTimeRemainderMin = max(0, (actualTurnTime.inMinutes + departureSequenceMin) - scheduledTurnTime.inMinutes);
    delayTimeRemainderMin = min(delayTimeRemainderMin, totalDelayTimeMin);

    return scheduledArrival.isAfter(actualArrival) ? Duration() : Duration(minutes: min(arrivalDifferenceMin, totalDelayTimeMin - delayTimeRemainderMin));
}

  Duration calculateDelayTime09({Duration standardTurnTime, Duration scheduledTurnTime, Duration totalDelayTime, Duration delayTimeQQ}) {
    var delayTime09min = max(0, (standardTurnTime - scheduledTurnTime).inMinutes);
    delayTime09min = min(delayTime09min, totalDelayTime.inMinutes);
    delayTime09min = min(delayTime09min, delayTimeQQ.inMinutes);
    return Duration(minutes: delayTime09min);
  }


  DelayCalculator({this.scheduledArrival, this.actualArrival, this.scheduledDeparture, this.actualDeparture, crewChange = false, aircraft = Aircraft.A320}) {
    if (scheduledDeparture == scheduledArrival) {
      throw DelayCalcValidationException("No delay ya dummy");
    } else if (scheduledDeparture.isBefore(scheduledArrival)) {
      throw DelayCalcValidationException("Check ya math einstein (departure is before arrival"); // 09 delay code not acceptable for this flight
    }

    var totalDelayTime = calculateTotalDelayTime(scheduledDeparture: scheduledDeparture, actualDeparture: actualDeparture);

    var actualTurnTime = calculateActualTurnTime(actualArrival: actualArrival, actualDeparture: actualDeparture);
    var standardTurnTime = calculateStandardTurnTime(aircraft: aircraft, crewChange: crewChange);
    var scheduledTurnTime = calculateScheduledTurnTime(scheduledDeparture: scheduledDeparture, scheduledArrival: scheduledArrival, standardTurnTime: standardTurnTime);

    var delayTime0x = calculateDelayTime0x(
        actualArrival: actualArrival,
        scheduledArrival: scheduledArrival,
        actualTurnTime: actualTurnTime,
        scheduledTurnTime: scheduledTurnTime,
        totalDelayTime: totalDelayTime);
    var delayTimeQQ = calculateDelayTimeQQ(totalDelayTime: totalDelayTime, delayTime0x: delayTime0x);
    var delayTime09 = calculateDelayTime09(standardTurnTime: standardTurnTime, scheduledTurnTime: scheduledTurnTime, totalDelayTime: totalDelayTime, delayTimeQQ: delayTimeQQ);


    this.delayTimeQQ = delayTimeQQ;
    this.delayTime09 = delayTime09;
    this.delayTime0x = delayTime0x;
    this.totalDelayTime = totalDelayTime;
  }

}


class DelayCalcValidationException implements Exception {
  final String message;
  const DelayCalcValidationException([this.message = ""]);

  @override
  String toString() => message;
}
