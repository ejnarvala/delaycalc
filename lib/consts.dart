import 'package:flutter/material.dart';

import 'Aircraft.dart';

const TIME_INPUT_CHAR_LENGTH = 4;

const Map<Aircraft, Duration> AircraftDelayMap = const {
  Aircraft.A319: Duration(minutes: 40),
  Aircraft.A320: Duration(minutes: 45)
};


const Map<Aircraft, Color> AircraftColorMap = const {
  Aircraft.A319: Colors.green,
  Aircraft.A320: Colors.red
};

const HELP_MESSAGE = "1. Assumes a minimum 40-minute scheduled turn time \n2. With a combination of Time inputs that 'cross-over' Midnight (i.e. [In Time=2330], [Out Time=0030]), add 2400 to the 'cross-over' time inputs. [0030] becomes [2430]";