import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/user.dart';

import 'package:responsive_screen/responsive_screen.dart';

class InitFinishView extends StatefulWidget {
  @override
  FinishView createState() => FinishView();
}

class FinishView extends State<InitFinishView> {
  String firstDataLabel = "DISTANCE";
  String firstDataValue = "10.3";
  String firstDataUnit = "KM";

  String secondDataLabel = "TEMPS";

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

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    final List donnees = ModalRoute.of(context).settings.arguments;
    print(donnees);
    String mode = donnees[0];
    String hoursStr = donnees[1];
    String minutesStr = donnees[2];
    String secondsStr = donnees[3];
    var temps = hoursStr + ' H ' + minutesStr + ' M ' + secondsStr + ' S';

    Widget title = Container(
      padding: EdgeInsets.only(
          top: screenHeight * 0.01,
          left: screenHeight * 0.03,
          right: screenHeight * 0.03),
      child: Text('VOTRE PERFORMANCE DU JOUR',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: screenHeight * 0.04, fontWeight: FontWeight.bold)),
    );

    Widget imagesection = Container(
      padding: EdgeInsets.only(top: screenHeight * 0.06),
      child: Image.asset(
        'images/trophy.png',
        height: screenHeight * .1882,
      ),
    );

    Widget firstData = Container(
        //padding: EdgeInsets.only(top: screenHeight * 0.002),
        child: Row(
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
          children: [
            Text(secondDataLabel,
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(' : ',
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold)),
            Text(temps, style: TextStyle(fontSize: screenHeight * 0.025)),
          ],
        ));

    Widget thirdData = Container(
        padding: EdgeInsets.only(top: screenHeight * 0.025),
        child: Row(
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
            children: [firstData],
          ),
          Row(children: [secondData]),
          Row(children: [thirdData]),
          Row(children: [fourthData]),
          Row(children: [fifthData]),
          Row(children: [sixthData])
        ]));

    Widget finbutton = Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.2170, vertical: screenHeight * 0.056),
      child: FlatButton(
        color: Colors.white,
        onPressed: () async {
          Navigator.pushNamed(context, 'startPage');
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
          child: Text(
            '''SAUVEGARDER ET 
REVENIR À 
L'ACCEUIL''',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 15),
          ),
        ),
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
          physics: const NeverScrollableScrollPhysics(),
          children: [
            title,
            imagesection,
            datas,
          ],
        ),
        bottomNavigationBar: finbutton,
      ),
    );
  }
}
