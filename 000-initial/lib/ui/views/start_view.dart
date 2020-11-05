import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/user.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

//classe de déppart avant de lancer l'activitée
class InitStartView extends StatefulWidget {
  @override
  StartView createState() => StartView();
}

class StartView extends State<InitStartView> {
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    final mode = Provider.of<User>(context);
    var colorSimpleButton;
    var colorSportifButton;
    if (mode.modeIsSimple) {
      colorSimpleButton = Colors.green;
      colorSportifButton = Colors.grey;
    } else {
      colorSimpleButton = Colors.grey;
      colorSportifButton = Colors.orange;
    }

    Widget menusection = Container(
      padding: EdgeInsets.only(
          top: screenHeight * .025, right: 0, left: screenWidth * 0.80),
      child: RawMaterialButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return Dialog(
                    insetPadding: EdgeInsets.only(top: screenHeight * .065),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Container(
                      height: screenHeight * .5,
                      width: screenWidth * .91,
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: screenHeight * .025),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Accueil",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              /*...*/
                            },
                            child: Text(
                              "Voir vos précédents entraînements",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              /*...*/
                            },
                            child: Text(
                              "Moyenne de vos efforts",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                            ),
                          ),
                          Divider(color: Colors.black),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenHeight * .05,
                                vertical: screenHeight * .025),
                            child: FlatButton(
                              onPressed: () async {
                                mode.modeIsSimple = true;
                                setState(() {
                                  colorSimpleButton = Colors.green;
                                  colorSportifButton = Colors.grey;
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                "MODE SIMPLE",
                                style: TextStyle(color: colorSimpleButton),
                              ),
                              padding: EdgeInsets.all(screenHeight * .025),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: colorSimpleButton,
                                      width: 2,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenHeight * .05),
                            child: FlatButton(
                              onPressed: () async {
                                mode.modeIsSimple = false;
                                setState(() {
                                  colorSimpleButton = Colors.grey;
                                  colorSportifButton = Colors.orange;
                                });
                                Navigator.pop(context);
                              },
                              child: Text('MODE SPORTIF',
                                  style: TextStyle(color: colorSportifButton)),
                              padding: EdgeInsets.all(screenHeight * .025),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: colorSportifButton,
                                      width: 2,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
              });
        },
        elevation: 0,
        fillColor: Colors.transparent,
        splashColor: Colors.black26,
        child: Icon(
          Icons.dehaze,
          size: screenHeight * .05,
        ),
        padding: EdgeInsets.all(screenHeight * .017),
        shape: CircleBorder(),
      ),
    );

    Widget imagesection = Container(
      padding: EdgeInsets.only(top: screenHeight * .011),
      child: Image.asset(
        'images/logoaccueil1.png',
        //fit: BoxFit.cover,
        alignment: Alignment.center,
        height: 225,
      ),
    );

    Widget titlesection = Container(
      padding: EdgeInsets.only(
          top: screenHeight * .0335, bottom: screenHeight * .15),
      child: Text(
        'BEMOOV',
        style: TextStyle(
          fontFamily: 'RobotoThin',
          fontStyle: FontStyle.normal,
          fontSize: screenHeight * .07,
        ),
        textAlign: TextAlign.center,
      ),
    );

    Widget buttonsection = Container(
        padding: EdgeInsets.symmetric(horizontal: screenHeight * .08),
        child: RawMaterialButton(
          onPressed: () {
            if (mode.modeIsSimple) {
              Navigator.pushNamed(context, 'simple');
            } else {
              Navigator.pushNamed(context, 'sportif');
            }
          },
          elevation: 2.0,
          fillColor: Colors.red,
          child: Icon(
            Icons.play_arrow,
            size: screenHeight * .13,
          ),
          padding: EdgeInsets.all(screenHeight * .02),
          shape: CircleBorder(),
        ));

    return Provider<MyMode>(
      create: (context) => MyMode(),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: screenHeight * .025),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            menusection,
            imagesection,
            titlesection,
            buttonsection,
          ],
        ),
      ),
    );
  }
}
