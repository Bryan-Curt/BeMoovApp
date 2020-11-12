import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/user.dart';
import 'package:provider_architecture/ui/views/pause_view.dart';
import 'package:responsive_screen/responsive_screen.dart';

class InitSimpleMonitoring extends StatefulWidget {
  @override
  SimpleMonitoring createState() => SimpleMonitoring();
}

class SimpleMonitoring extends State<InitSimpleMonitoring> {
  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr;

  String minutesStr;
  String secondsStr;

  String leftDataLabel = "BPM";
  String leftDataValue = "175";
  String leftDataUnit = "BPM";
  String leftDataImg = "pulse.png";

  String rightDataLabel = "Vitesse";
  String rightDataValue = "175";
  String rightDataUnit = "KM/H";
  String rightDataImg = "pulse.png";

  String mode = "simple";

  var donnees = List(5);

  var donneesTest = List(5);
  int counter;
  bool firstgo = true;

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);

    if (donneesTest != null) {
      if (donneesTest[4] != null) {
        counter = donneesTest[4];
        hoursStr = donneesTest[1];
        minutesStr = donneesTest[2];
        secondsStr = donneesTest[3];
      }
    } else {
      counter = 0;
    }

    if (counter == 0) {
      hoursStr = '00';
      minutesStr = '00';
      secondsStr = '00';
    }

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
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
    firstgo = false;
    timerStream = stopWatchStream();
    mode = "simple";
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

  void pause() {
    donnees[0] = mode;
    donnees[1] = hoursStr;
    donnees[2] = minutesStr;
    donnees[3] = secondsStr;
    donnees[4] = counter;
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    donneesTest = ModalRoute.of(context).settings.arguments;

    if (firstgo) {
      initStopWatch();
    }

    Widget stopwatchsection = Container(
      padding: EdgeInsets.only(top: screenHeight * 0.060),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('TEMPS',
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
          children: [
            Text(leftDataLabel, style: TextStyle(fontSize: 25)),
            Text(leftDataValue, style: TextStyle(fontSize: 40)),
            Text(leftDataUnit, style: TextStyle(fontSize: 25)),
          ],
        ));

    Widget rightData = Container(
        child: Column(
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
        onPressed: () {
          pause();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InitPauseView(),
                  // Pass the arguments as part of the RouteSettings. The
                  // DetailScreen reads the arguments from these settings.
                  settings: RouteSettings(arguments: donnees)));
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
