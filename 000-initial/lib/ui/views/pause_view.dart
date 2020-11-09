import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/user.dart';
import 'package:provider_architecture/ui/views/simple_view.dart';
import 'package:responsive_screen/responsive_screen.dart';

class InitPauseView extends StatefulWidget {
  @override
  PauseView createState() => PauseView();
}

class PauseView extends State<InitPauseView> {
  String firstDataLabel = "DISTANCE";
  String firstDataValue = "10.3";
  String firstDataUnit = "KM";

  String secondDataLabel = "TEMPS";
  String secondDataValue = "00 H 30 M 00 S";
  String secondDataUnit = "";

  String thirdDataLabel = "VITESSE MOYENNE";
  String thirdDataValue = "15";
  String thirdDataUnit = "KM/H";

  String fourthDataLabel = "PUISSANCE MOYENNE";
  String fourthDataValue = "130";
  String fourthDataUnit = "WATTS";

  String fifthDataLabel = "BPM MOYENS";
  String fifthDataValue = "140";
  String fifthDataUnit = "BPM";

  String sixthDataLabel = "CADENCE MOYENNE";
  String sixthDataValue = "88";
  String sixthDataUnit = "RPM";

  //Test test;
  //PauseView({Key key, @required this.test});

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    final List<String> donnees = ModalRoute.of(context).settings.arguments;
    String mode = donnees[0];
    print('mode');
    Widget bandeauPause = Container(
      //padding: EdgeInsets.only(right: screenWidth * 0.3),
      child: Container(
        color: Colors.red,
        width: screenWidth,
        height: screenHeight * 0.08,
        child: Text(
          "EN PAUSE",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.07),
        ),
      ),
    );

    Widget title = Container(
      padding: EdgeInsets.only(
          top: screenHeight * 0.08,
          left: screenHeight * 0.03,
          right: screenHeight * 0.03),
      child: Text('VOS PERFORMANCES EN COURS',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: screenHeight * 0.04, fontWeight: FontWeight.bold)),
    );

    Widget firstData = Container(
        child: Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(firstDataLabel,
            style: TextStyle(
                fontSize: screenHeight * 0.025, fontWeight: FontWeight.bold)),
        Text(' : ',
            style: TextStyle(
                fontSize: screenHeight * 0.025, fontWeight: FontWeight.bold)),
        Text(firstDataValue, style: TextStyle(fontSize: screenHeight * 0.025)),
        Text(firstDataUnit, style: TextStyle(fontSize: screenHeight * 0.025)),
      ],
    ));

    Widget secondData = Container(
        padding: EdgeInsets.only(top: screenHeight * 0.025),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(secondDataLabel,
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(' : ',
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(secondDataValue,
                style: TextStyle(fontSize: screenHeight * 0.025)),
            Text(secondDataUnit,
                style: TextStyle(fontSize: screenHeight * 0.025)),
          ],
        ));

    Widget thirdData = Container(
        padding: EdgeInsets.only(top: screenHeight * 0.025),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(thirdDataLabel,
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(' : ',
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(thirdDataValue,
                style: TextStyle(fontSize: screenHeight * 0.025)),
            Text(thirdDataUnit,
                style: TextStyle(fontSize: screenHeight * 0.025)),
          ],
        ));

    Widget fourthData = Container(
        padding: EdgeInsets.only(top: screenHeight * 0.025),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(fourthDataLabel,
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(' : ',
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(fourthDataValue,
                style: TextStyle(fontSize: screenHeight * 0.025)),
            Text(fourthDataUnit,
                style: TextStyle(fontSize: screenHeight * 0.025)),
          ],
        ));

    Widget fifthData = Container(
        padding: EdgeInsets.only(top: screenHeight * 0.025),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(fifthDataLabel,
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(' : ',
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(fifthDataValue,
                style: TextStyle(fontSize: screenHeight * 0.025)),
            Text(fifthDataUnit,
                style: TextStyle(fontSize: screenHeight * 0.025)),
          ],
        ));

    Widget sixthData = Container(
        padding: EdgeInsets.only(top: screenHeight * 0.025),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(sixthDataLabel,
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(' : ',
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(sixthDataValue,
                style: TextStyle(fontSize: screenHeight * 0.025)),
            Text(sixthDataUnit,
                style: TextStyle(fontSize: screenHeight * 0.025)),
          ],
        ));

    Widget datas = Container(
        padding:
            EdgeInsets.only(top: screenHeight * 0.1, left: screenHeight * 0.01),
        child: Column(children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [firstData],
          ),
          Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [secondData]),
          Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [thirdData]),
          Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [fourthData]),
          Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [fifthData]),
          Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [sixthData])
        ]));

    Widget reprendrebutton = Container(
      width: screenWidth * 0.45,
      height: screenHeight * 0.09,
      //padding: EdgeInsets.only(top: screenHeight * 0.08),
      child: FlatButton(
        color: Colors.white,
        onPressed: () async {
          if (mode == 'simple') {
            Navigator.pushNamed(context, 'simple');
          } else if (mode == 'sportif') {
            Navigator.pushNamed(context, 'sportif');
          }
        },
        child: Text(
          "REPRENDRE",
          style: TextStyle(color: Colors.green, fontSize: 25),
        ),
        //padding: EdgeInsets.all(screenHeight * 0.022),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.green, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(15)),
      ),
    );

    Widget finbutton = Container(
      width: screenWidth * 0.45,
      height: screenHeight * 0.09,
      margin: EdgeInsets.only(left: screenHeight * 0.03),
      child: FlatButton(
        color: Colors.white,
        onPressed: () async {
          Navigator.pushNamed(context, 'pause');
        },
        child: Text(
          "ARRÊTER",
          style: TextStyle(color: Colors.red, fontSize: 25),
        ),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.red, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(15)),
      ),
    );

    Widget boutons = Container(
        padding: EdgeInsets.only(top: screenHeight * 0.1),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [reprendrebutton, finbutton],
          )
        ]));

    return Provider<MyMode>(
      create: (context) => MyMode(),
      child: Scaffold(
        body: ListView(
          //padding: EdgeInsets.symmetric(vertical: screenHeight * 0.022),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            bandeauPause,
            title,
            datas,
            boutons,
          ],
        ),
      ),
    );
  }
}
