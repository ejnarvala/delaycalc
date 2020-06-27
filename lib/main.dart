import 'package:delaycalc/Aircraft.dart';
import 'package:delaycalc/DelayCalculator.dart';
import 'package:delaycalc/DelayResultsTable.dart';
import 'package:delaycalc/utils.dart';
import 'package:flutter/material.dart';

import 'TimeInputFormField.dart';
import 'consts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delay Code Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: DelayCalculatorHome(title: 'Delay Code Calculator'),
    );
  }
}

class DelayCalculatorHome extends StatefulWidget {
  DelayCalculatorHome({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DelayCalculatorHomeState createState() => _DelayCalculatorHomeState();
}

class _DelayCalculatorHomeState extends State<DelayCalculatorHome> {
  DelayCalculator calculator;
  Aircraft aircraftDropdownValue = Aircraft.A319;
  bool crewChange = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _scheduledArrivalKey = GlobalKey<FormFieldState>();
  final _actualArrivalKey = GlobalKey<FormFieldState>();
  final _scheduledDepartureKey = GlobalKey<FormFieldState>();
  final _actualDepartureKey = GlobalKey<FormFieldState>();

  void submitForm() {
    if (_formKey.currentState.validate()) {
      try {
        var calc = DelayCalculator(
          scheduledArrival: readMilitaryInput(_scheduledArrivalKey.currentState.value),
          actualArrival: readMilitaryInput(_actualArrivalKey.currentState.value),
          scheduledDeparture: readMilitaryInput(_scheduledDepartureKey.currentState.value),
          actualDeparture: readMilitaryInput(_actualDepartureKey.currentState.value),
          crewChange: crewChange,
          aircraft: aircraftDropdownValue
        );
        setState(() => calculator = calc);
      } on Exception catch (error) {
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              duration: Duration(seconds: 3),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => showAlertDialog("Info", HELP_MESSAGE, context),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: AircraftColorMap[aircraftDropdownValue]),
                    borderRadius: BorderRadius.circular(4.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Aircraft", style: TextStyle(fontSize: 18),),
                    DropdownButton(
                      value: aircraftDropdownValue,
                      items: Aircraft.values.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.toString().split('.').last,
                          style: TextStyle(color: AircraftColorMap[e]),
                        ),
                      )).toList(),
                      onChanged: (newVal) => setState(() => aircraftDropdownValue = newVal),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    border: crewChange ? Border.all(width: 2, color: Colors.blue) : Border.all(width: 1, color: Colors.black38),
                    borderRadius: BorderRadius.circular(4.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Crew Change", style: TextStyle(fontSize: 18, color: (crewChange ? Colors.blue : Colors.black54))),
                    Text(crewChange ? "(Yes)" : "(No)", style: TextStyle(fontSize: 18)),
                    Switch(
                      value: crewChange,
                      onChanged: (newVal) => setState(() => crewChange = newVal),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    TimeInputFormField(
                      title: "Scheduled Arrival",
                      formFieldKey: _scheduledArrivalKey,
                      helpText: fieldHelpText(scheduled: true, inbound: true),
                      onFieldSubmitted: (_) => FocusScope.of(context).focusInDirection(TraversalDirection.down),
                    ),
                    TimeInputFormField(
                        title: "Actual Arrival",
                        formFieldKey: _actualArrivalKey,
                        helpText: fieldHelpText(scheduled: false, inbound: true),
                        onFieldSubmitted: (_) => FocusScope.of(context).focusInDirection(TraversalDirection.down),
                    ),
                    TimeInputFormField(
                      title: "Scheduled Departure",
                      formFieldKey: _scheduledDepartureKey,
                      helpText: fieldHelpText(scheduled: true, inbound: false),
                      iconUp: true,
                      onFieldSubmitted: (_) => FocusScope.of(context).focusInDirection(TraversalDirection.down),
                    ),
                    TimeInputFormField(
                      title: "Actual Departure",
                      formFieldKey: _actualDepartureKey,
                      helpText: fieldHelpText(scheduled: false, inbound: false),
                      focusNext: false,
                      iconUp: true,
                      onFieldSubmitted: (_) => submitForm(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text("Calculate", style: TextStyle(color: Colors.white),),
                  onPressed: submitForm,
                ),
              ),
              (calculator == null) ? Container() : Container(
                child: DelayResultsTable(calculator),
              )
            ],
          ),
        )
      ),
    );
  }
}
