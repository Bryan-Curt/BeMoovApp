import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/user.dart';

//classe de déppart avant de lancer l'activitée
class InitStartView extends StatefulWidget {
  @override
  StartView createState() => StartView();
}

class StartView extends State<InitStartView> {
  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.only(top: 20, right: 0, left: 325),
      child: RawMaterialButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return Dialog(
                    insetPadding: EdgeInsets.only(top: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Container(
                      height: 350.0,
                      width: 360.0,
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 20),
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
                                horizontal: 40, vertical: 20),
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
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: colorSimpleButton,
                                      width: 2,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 40),
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
                              padding: EdgeInsets.all(20),
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
          size: 40.0,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
    );

    Widget imagesection = Container(
      padding: const EdgeInsets.only(top: 10),
      child: Image.asset(
        'images/logoaccueil1.png',
        //fit: BoxFit.cover,
        alignment: Alignment.center,
        height: 225,
      ),
    );

    Widget titlesection = Container(
      padding: const EdgeInsets.only(top: 30, bottom: 90),
      child: Text(
        'BEMOOV',
        style: TextStyle(
          fontFamily: 'RobotoThin',
          fontStyle: FontStyle.normal,
          fontSize: 50,
        ),
        textAlign: TextAlign.center,
      ),
    );

    Widget buttonsection = Container(
        padding: EdgeInsets.symmetric(horizontal: 70),
        child: RawMaterialButton(
          onPressed: () {
            if (mode.modeIsSimple) {
              Navigator.pushNamed(context, 'simple');
            } else {
              Navigator.pushNamed(context, 'startPage');
            }
          },
          elevation: 2.0,
          fillColor: Colors.red,
          child: Icon(
            Icons.play_arrow,
            size: 100.0,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ));

    return Provider<MyMode>(
      create: (context) => MyMode(),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
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
