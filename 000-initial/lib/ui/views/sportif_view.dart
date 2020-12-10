import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/mainDisplayed.dart';
import 'package:provider_architecture/core/models/user.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider_architecture/ui/views/pause_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InitSportifMonitoring extends StatefulWidget {
  @override
  SportifMonitoring createState() => SportifMonitoring();
}

class SportifMonitoring extends State<InitSportifMonitoring> {
  //String _mainData = "BPM";
  List<String> _dataMap = ["BPM", "KM/H", "KM", "WATTS", "RPM"];
  bool _isSportif = true;

  @override
  void initState() {
    super.initState();
    _loadIsSportif();
    _mainDataIs();
  }

  _loadIsSportif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSportif = (prefs.getBool('isSportif') ??
          true); // Try reading data from the mainData key. If it doesn't exist, return 0.
    });
  }

  _mainDataIs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _dataMap = (prefs.getStringList('dataMap') ??
          [
            "BPM",
            "KM/H",
            "KM",
            "WATTS",
            "RPM"
          ]); // Try reading data from the mainData key. If it doesn't exist, return BPM.
    });
  }

  String mainDataLabel;
  String mainDataValue;
  String mainDataUnit;
  String mainDataImg;

  String tlDataLabel;
  String tlDataValue;
  String tlDataUnit;

  String trDataLabel;
  String trDataValue;
  String trDataUnit;

  String blDataLabel;
  String blDataValue;
  String blDataUnit;

  String brDataLabel;
  String brDataValue;
  String brDataUnit;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr;
  String minutesStr;
  String secondsStr;

  var donnees = List(5);
  var donneesPause = List(5);
  int counter;
  bool firstgo = true;
  bool inPause = false;

  String mode = "sportif";

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    if (donneesPause != null) {
      if (donneesPause[4] != null) {
        counter = donneesPause[4];
        hoursStr = donneesPause[1];
        minutesStr = donneesPause[2];
        secondsStr = donneesPause[3];
        //inPause = donneesPause[5];
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
    firstgo = false;
    timerStream = stopWatchStream();
    mode = "sportif";
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
    Future<String> getDbPath() async {
      String pathDb = await getDatabasesPath();
      return pathDb;
    }

    var databasesPath = getDbPath();
    String path = join(databasesPath.toString(), 'data4.db');
    print(path);

    if (inPause == false) {
      void createDataBase() async {
        Database database = await openDatabase(path,
            version: 1, onCreate: (Database db, int version) async {});

        await database.transaction((txn) async {
          int t = (int.parse(hoursStr) * 3600).round() +
              (int.parse(minutesStr) * 60).round() +
              int.parse(secondsStr);
          await txn.rawInsert(
              'INSERT INTO DataMoy(speed,power,heartbeat,cadency, time, idSortie) VALUES (14,110,130,75,' +
                  t.toString() +
                  ',(SELECT max(id) FROM DataSortie))');
          //print('inserted1: $id1');
        });

        List<Map> list = await database.rawQuery(
            'SELECT * FROM DataMoy WHERE id=(SELECT max(id) FROM DataMoy)');
        print(list);
        //print(inPause);
      }

      createDataBase();
    }

    var colorAssistance;
    var colorSportifButton;

    if (_isSportif) {
      colorAssistance = Colors.grey;
      colorSportifButton = Colors.orange;
    } else {
      colorAssistance = Colors.blue;
      colorSportifButton = Colors.grey;
    }

    switch (_dataMap[0]) {
      case "BPM":
        {
          mainDataLabel = "Fréquence Cardiaque";
          mainDataValue = "175";
          mainDataUnit = "BPM";
          mainDataImg = "pulse.png";
        }
        break;
      case "KMH":
        {
          mainDataLabel = "Vitesse";
          mainDataValue = "25";
          mainDataUnit = "KM/H";
          mainDataImg = "speedometer.png";
        }
        break;
      case "KM":
        {
          mainDataLabel = "Distance";
          mainDataValue = "4.07";
          mainDataUnit = "KM";
          mainDataImg = "distance.png";
        }
        break;
      case "WATTS":
        {
          mainDataLabel = "Puissance";
          mainDataValue = "120";
          mainDataUnit = "WATTS";
          mainDataImg = "thunderbolt.png";
        }
        break;
      case "RPM":
        {
          mainDataLabel = "Cadence";
          mainDataValue = "75";
          mainDataUnit = "RPM";
          mainDataImg = "pedal.png";
        }
        break;
      default:
        {
          mainDataLabel = "Fréquence Cardiaque";
          mainDataValue = "175";
          mainDataUnit = "BPM";
          mainDataImg = "pulse.png";
        }
    }

    switch (_dataMap[1]) {
      case "BPM":
        {
          tlDataLabel = "Fréquence";
          tlDataValue = "175";
          tlDataUnit = "BPM";
        }
        break;
      case "KMH":
        {
          tlDataLabel = "Vitesse";
          tlDataValue = "25";
          tlDataUnit = "KM/H";
        }
        break;
      case "KM":
        {
          tlDataLabel = "Distance";
          tlDataValue = "4.07";
          tlDataUnit = "KM";
        }
        break;
      case "WATTS":
        {
          tlDataLabel = "Puissance";
          tlDataValue = "120";
          tlDataUnit = "WATTS";
        }
        break;
      case "RPM":
        {
          tlDataLabel = "Cadence";
          tlDataValue = "75";
          tlDataUnit = "RPM";
        }
        break;
      default:
        {
          tlDataLabel = "Vitesse";
          tlDataValue = "25";
          tlDataUnit = "KM/H";
        }
    }
    switch (_dataMap[2]) {
      case "BPM":
        {
          trDataLabel = "Fréquence";
          trDataValue = "175";
          trDataUnit = "BPM";
        }
        break;
      case "KMH":
        {
          trDataLabel = "Vitesse";
          trDataValue = "25";
          trDataUnit = "KM/H";
        }
        break;
      case "KM":
        {
          trDataLabel = "Distance";
          trDataValue = "4.07";
          trDataUnit = "KM";
        }
        break;
      case "WATTS":
        {
          trDataLabel = "Puissance";
          trDataValue = "120";
          trDataUnit = "WATTS";
        }
        break;
      case "RPM":
        {
          trDataLabel = "Cadence";
          trDataValue = "75";
          trDataUnit = "RPM";
        }
        break;
      default:
        {
          trDataLabel = "Distance";
          trDataValue = "4.07";
          trDataUnit = "KM";
        }
    }
    switch (_dataMap[3]) {
      case "BPM":
        {
          blDataLabel = "Fréquence";
          blDataValue = "175";
          blDataUnit = "BPM";
        }
        break;
      case "KMH":
        {
          blDataLabel = "Vitesse";
          blDataValue = "25";
          blDataUnit = "KM/H";
        }
        break;
      case "KM":
        {
          blDataLabel = "Distance";
          blDataValue = "4.07";
          blDataUnit = "KM";
        }
        break;
      case "WATTS":
        {
          blDataLabel = "Puissance";
          blDataValue = "120";
          blDataUnit = "WATTS";
        }
        break;
      case "RPM":
        {
          blDataLabel = "Cadence";
          blDataValue = "75";
          blDataUnit = "RPM";
        }
        break;
      default:
        {
          blDataLabel = "Puissance";
          blDataValue = "120";
          blDataUnit = "WATTS";
        }
    }

    switch (_dataMap[4]) {
      case "BPM":
        {
          brDataLabel = "Fréquence";
          brDataValue = "175";
          brDataUnit = "BPM";
        }
        break;
      case "KMH":
        {
          brDataLabel = "Vitesse";
          brDataValue = "25";
          brDataUnit = "KM/H";
        }
        break;
      case "KM":
        {
          brDataLabel = "Distance";
          brDataValue = "4.07";
          brDataUnit = "KM";
        }
        break;
      case "WATTS":
        {
          brDataLabel = "Puissance";
          brDataValue = "120";
          brDataUnit = "WATTS";
        }
        break;
      case "RPM":
        {
          brDataLabel = "Cadence";
          brDataValue = "75";
          brDataUnit = "RPM";
        }
        break;
      default:
        {
          brDataLabel = "Cadence";
          brDataValue = "75";
          brDataUnit = "RPM";
        }
    }
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    donneesPause = ModalRoute.of(context).settings.arguments;

    if (firstgo) {
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

    if (firstgo) {
      initStopWatch();
    }

    Widget stopwatchsection = Container(
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
        onPressed: () {
          pause();
          inPause = true;
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
        child: Column(
      children: [
        Text(tlDataLabel, style: TextStyle(fontSize: screenHeight * 0.035)),
        Text(tlDataValue, style: TextStyle(fontSize: screenHeight * 0.06)),
        Text(tlDataUnit, style: TextStyle(fontSize: screenHeight * 0.035)),
      ],
    ));

    Widget trData = Container(
        child: Column(
      children: [
        Text(trDataLabel, style: TextStyle(fontSize: screenHeight * 0.035)),
        Text(trDataValue, style: TextStyle(fontSize: screenHeight * 0.06)),
        Text(trDataUnit, style: TextStyle(fontSize: screenHeight * 0.035)),
      ],
    ));

    Widget blData = Container(
        padding: EdgeInsets.only(top: screenWidth * 0.05),
        child: Column(
          children: [
            Text(blDataLabel, style: TextStyle(fontSize: screenHeight * 0.035)),
            Text(blDataValue, style: TextStyle(fontSize: screenHeight * 0.06)),
            Text(blDataUnit, style: TextStyle(fontSize: screenHeight * 0.035)),
          ],
        ));

    Widget brData = Container(
        padding: EdgeInsets.only(top: screenWidth * 0.05),
        child: Column(
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
            children: <Widget>[
              Expanded(child: tlData),
              Expanded(child: trData),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: blData),
              Expanded(child: brData),
            ],
          )
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
                  if (_dataMap[0] == "BPM")
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 40.0,
                    ),
                  Text('RYTHME CARDIAQUE', textAlign: TextAlign.center),
                ]),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    _dataMap = ["BPM", "KM/H", "KM", "WATTS", "RPM"];
                    prefs.setStringList('dataMap', _dataMap);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
            Container(
              width: screenWidth * .5,
              child: FlatButton(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (_dataMap[0] == "KMH")
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 40.0,
                    ),
                  Text('VITESSE', textAlign: TextAlign.center),
                ]),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    _dataMap = ["KMH", "BPM", "KM", "WATTS", "RPM"];
                    prefs.setStringList('dataMap', _dataMap);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
            Container(
              width: screenWidth * .5,
              child: FlatButton(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (_dataMap[0] == "KM")
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 40.0,
                    ),
                  Text('DISTANCE', textAlign: TextAlign.center),
                ]),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    _dataMap = ["KM", "BPM", "KMH", "WATTS", "RPM"];
                    prefs.setStringList('dataMap', _dataMap);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
            Container(
              width: screenWidth * .5,
              child: FlatButton(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (_dataMap[0] == "WATTS")
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 40.0,
                    ),
                  Text('PUISSANCE', textAlign: TextAlign.center),
                ]),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    _dataMap = ["WATTS", "KM/H", "KM", "BPM", "RPM"];
                    prefs.setStringList('dataMap', _dataMap);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
            Container(
              width: screenWidth * .5,
              child: FlatButton(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (_dataMap[0] == "RPM")
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 40.0,
                    ),
                  Text('CADENCE', textAlign: TextAlign.center),
                ]),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    _dataMap = ["RPM", "BPM", "KM", "WATTS", "KMH"];
                    prefs.setStringList('dataMap', _dataMap);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
            separator,
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenHeight * .05,
                  vertical: screenHeight * .025),
              child: FlatButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    _isSportif = false;
                    prefs.setBool('isSportif', _isSportif);
                  });
                  Navigator.pop(context);
                },
                child: Text('ASSISTANCE FORCÉE',
                    style: TextStyle(color: colorAssistance)),
                padding: EdgeInsets.all(screenHeight * .025),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: colorAssistance,
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenHeight * .05),
              child: FlatButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    _isSportif = true;
                    prefs.setBool('isSportif', _isSportif);
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "MODE SPORTIF",
                  style: TextStyle(color: colorSportifButton),
                ),
                padding: EdgeInsets.all(screenHeight * .025),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: colorSportifButton,
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20)),
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
