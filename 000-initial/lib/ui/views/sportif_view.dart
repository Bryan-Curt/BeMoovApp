import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/mainDisplayed.dart';
import 'package:provider_architecture/core/models/user.dart';
import 'package:responsive_screen/responsive_screen.dart';

class InitSportifMonitoring extends StatefulWidget {
  @override
  SportifMonitoring createState() => SportifMonitoring();
}

class SportifMonitoring extends State<InitSportifMonitoring> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  String mainDataLabel = "Fréquence Cardiaque";
  String mainDataValue = "175";
  String mainDataUnit = "BPM";
  String mainDataImg = "pulse.png";

  String tlDataLabel = "Vitesse";
  String tlDataValue = "175";
  String tlDataUnit = "KM/H";
  String tlDataImg = "pulse.png";

  String trDataLabel = "Distance";
  String trDataValue = "4.07";
  String trDataUnit = "KM";
  String trDataImg = "pulse.png";

  String blDataLabel = "Puissance";
  String blDataValue = "120";
  String blDataUnit = "WATTS";
  String blDataImg = "pulse.png";

  String brDataLabel = "Cadence";
  String brDataValue = "75";
  String brDataUnit = "RPM";
  String brDataImg = "pulse.png";

  List<String> map = ["BPM", "KM/H", "KM", "WATTS", "RPM"];

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
    final mainDisplayed = Provider.of<User>(context);

    if (secondsStr == '00' && minutesStr == '00') {
      initStopWatch();
    }

    Widget menusection = Container(
        padding: EdgeInsets.only(
            top: screenHeight * 0.005, right: 0, left: screenWidth * 0.8),
        child: RawMaterialButton(
          onPressed: () {
            _scaffoldKey.currentState.openEndDrawer();
          },
          elevation: 0,
          fillColor: Colors.transparent,
          splashColor: Colors.black26,
          child: Icon(
            Icons.settings,
            size: 40.0,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ));

    Widget stopwatchsection = Container(
      //padding: EdgeInsets.only(top: 0, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("TEMPS",
              style: TextStyle(
                fontSize: screenHeight * 0.022,
              )),
          Text(
            "$hoursStr:$minutesStr:$secondsStr",
            style: TextStyle(
              fontSize: screenHeight * 0.08,
            ),
          ),
        ],
      ),
    );

    Widget pausebutton = Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.17, vertical: screenHeight * 0.02),
      child: FlatButton(
        color: Colors.red,
        onPressed: () async {},
        child: Text(
          "PAUSE",
          style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.06),
        ),
        padding: EdgeInsets.all(screenHeight * 0.022),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.red, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(15)),
      ),
    );

    Widget separator = Divider(
      color: Colors.black,
      indent: screenWidth * 0.097,
      endIndent: screenWidth * 0.097,
    );

    Widget mainData = Container(
        padding: EdgeInsets.only(
            top: screenHeight * 0.011, bottom: screenHeight * 0.011),
        child: Column(children: [
          Text(mainDataLabel, style: TextStyle(fontSize: screenHeight * 0.03)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Image.asset("images/" + mainDataImg, height: screenHeight * 0.1),
            Text(mainDataValue, style: TextStyle(fontSize: screenHeight * 0.1)),
            Text(mainDataUnit,
                style: TextStyle(fontSize: screenHeight * 0.044)),
          ])
        ]));

    Widget tlData = Container(
        padding: EdgeInsets.only(
            left: screenWidth * 0.20, bottom: screenHeight * 0.016),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tlDataLabel, style: TextStyle(fontSize: screenHeight * 0.035)),
            Text(tlDataValue, style: TextStyle(fontSize: screenHeight * 0.06)),
            Text(tlDataUnit, style: TextStyle(fontSize: screenHeight * 0.035)),
          ],
        ));

    Widget trData = Container(
        padding: EdgeInsets.only(
            left: screenWidth * 0.20, bottom: screenHeight * 0.016),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(trDataLabel, style: TextStyle(fontSize: screenHeight * 0.035)),
            Text(trDataValue, style: TextStyle(fontSize: screenHeight * 0.06)),
            Text(trDataUnit, style: TextStyle(fontSize: screenHeight * 0.035)),
          ],
        ));

    Widget blData = Container(
        padding: EdgeInsets.only(left: screenWidth * 0.17),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(blDataLabel, style: TextStyle(fontSize: screenHeight * 0.035)),
            Text(blDataValue, style: TextStyle(fontSize: screenHeight * 0.06)),
            Text(blDataUnit, style: TextStyle(fontSize: screenHeight * 0.035)),
          ],
        ));

    Widget brData = Container(
        padding: EdgeInsets.only(left: screenWidth * 0.15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(brDataLabel, style: TextStyle(fontSize: screenHeight * 0.035)),
            Text(brDataValue, style: TextStyle(fontSize: screenHeight * 0.06)),
            Text(brDataUnit, style: TextStyle(fontSize: screenHeight * 0.035)),
          ],
        ));

    Widget secondaryData = Container(
        padding: EdgeInsets.only(top: screenHeight * 0.01),
        child: Column(children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [tlData, trData],
          ),
          Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [blData, brData])
        ]));

    Widget tiroir = Container(
        width: 800,
        child: Drawer(
            child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(top: 50, right: 0, left: 325),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  elevation: 0,
                  fillColor: Colors.black,
                  splashColor: Colors.black,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  padding: EdgeInsets.all(5.0),
                  shape: CircleBorder(),
                )),
            Container(
                width: screenWidth * .5,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 50),
                child: Text(
                  'DONNÉE PRINCIPALE',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                )),
            Container(
              width: screenWidth * .5,
              child: FlatButton(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (mainDisplayed.mainDisplayedData == "BPM")
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 40.0,
                    ),
                  Text('RYTHME CARDIAQUE', textAlign: TextAlign.center),
                ]),
                onPressed: () {
                  mainDisplayed.mainDisplayedData = "BPM";
                },
              ),
            ),
            Container(
              width: screenWidth * .5,
              child: FlatButton(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (mainDisplayed.mainDisplayedData == "KMH")
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 40.0,
                    ),
                  Text('VITESSE', textAlign: TextAlign.center),
                ]),
                onPressed: () {
                  mainDisplayed.mainDisplayedData = "KMH";
                },
              ),
            ),
            Container(
              width: screenWidth * .5,
              child: FlatButton(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (mainDisplayed.mainDisplayedData == "KM")
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 40.0,
                    ),
                  Text('DISTANCE', textAlign: TextAlign.center),
                ]),
                onPressed: () {
                  mainDisplayed.mainDisplayedData = "KM";
                },
              ),
            ),
            Container(
              width: screenWidth * .5,
              child: FlatButton(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (mainDisplayed.mainDisplayedData == "WATTS")
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 40.0,
                    ),
                  Text('PUISSANCE', textAlign: TextAlign.center),
                ]),
                onPressed: () {
                  mainDisplayed.mainDisplayedData = "WATTS";
                },
              ),
            ),
            Container(
              width: screenWidth * .5,
              child: FlatButton(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (mainDisplayed.mainDisplayedData == "RPM")
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 40.0,
                    ),
                  Text('CADENCE', textAlign: TextAlign.center),
                ]),
                onPressed: () {
                  mainDisplayed.mainDisplayedData = "RPM";
                },
              ),
            ),
          ],
        )));

    return Provider<MyMode>(
      create: (context) => MyMode(),
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: tiroir,
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            menusection,
            stopwatchsection,
            separator,
            mainData,
            separator,
            secondaryData
          ],
        ),
        bottomNavigationBar: pausebutton,
      ),
    );
  }
}
