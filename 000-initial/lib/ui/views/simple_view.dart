import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/user.dart';
import 'package:responsive_screen/responsive_screen.dart';

class InitSimpleMonitoring extends StatefulWidget {
  @override
  SimpleMonitoring createState() => SimpleMonitoring();
}

class SimpleMonitoring extends State<InitSimpleMonitoring> {
  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  String leftDataLabel = "BPM";
  String leftDataValue = "175";
  String leftDataUnit = "BPM";
  String leftDataImg = "pulse.png";

  String rightDataLabel = "Vitesse";
  String rightDataValue = "175";
  String rightDataUnit = "KM/H";
  String rightDataImg = "pulse.png";

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  void initStopWatch() {
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      if (mounted)
        setState(() {
          hoursStr =
              ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
          minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
          secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    if (secondsStr == '00' && minutesStr == '00') {
      initStopWatch();
    }

    Widget stopwatchsection = Container(
      padding: EdgeInsets.only(top: screenHeight * 0.060),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("TEMPS",
              style: TextStyle(
                fontSize: screenHeight * 0.025,
              )),
          Text(
            "$hoursStr:$minutesStr:$secondsStr",
            style: TextStyle(
              fontSize: screenHeight * 0.10,
            ),
          ),
        ],
      ),
    );

    Widget circularprogressbarsection = SizedBox(
      height: 250.0,
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: screenWidth * 0.60,
              height: screenWidth * 0.60,
              child: new CircularProgressIndicator(
                strokeWidth: screenWidth * 0.036,
                value: (double.parse(secondsStr) % 60) / 60,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                backgroundColor: Colors.grey,
              ),
            ),
          ),
          Center(
              child: Text(
            (((double.parse(secondsStr) % 60) / 60) * 100)
                    .truncate()
                    .toString() +
                " %",
            style: TextStyle(
              fontSize: screenHeight * 0.065,
            ),
          )),
        ],
      ),
    );

    Widget leftData = Container(
        padding: EdgeInsets.only(right: screenWidth * 0.3),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(leftDataLabel, style: TextStyle(fontSize: 25)),
            Text(leftDataValue, style: TextStyle(fontSize: 40)),
            Text(leftDataUnit, style: TextStyle(fontSize: 25)),
          ],
        ));

    Widget rightData = Container(
        //padding: EdgeInsets.only(left: 20),
        child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(rightDataLabel, style: TextStyle(fontSize: 25)),
        Text(rightDataValue, style: TextStyle(fontSize: 40)),
        Text(rightDataUnit, style: TextStyle(fontSize: 25)),
      ],
    ));

    Widget secondaryData = Container(
        padding: EdgeInsets.only(top: screenHeight * 0.03),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [leftData, rightData],
          )
        ]));

    Widget pausebutton = Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.169, vertical: screenHeight * 0.030),
      child: FlatButton(
        color: Colors.red,
        onPressed: () async {
          Navigator.pushNamed(context, 'pause');
        },
        child: Text(
          "PAUSE",
          style: TextStyle(color: Colors.white, fontSize: 50),
        ),
        padding: EdgeInsets.all(screenHeight * 0.022),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.red, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(15)),
      ),
    );

    return Provider<MyMode>(
      create: (context) => MyMode(),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.022),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            stopwatchsection,
            circularprogressbarsection,
            secondaryData
          ],
        ),
        bottomNavigationBar: pausebutton,
      ),
    );
  }
}
