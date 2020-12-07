import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/user.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

//classe de déppart avant de lancer l'activitée
class InitStartView extends StatefulWidget {
  @override
  StartView createState() => StartView();
}

class StartView extends State<InitStartView> {
  bool _isSimple = true;

  @override
  void initState() {
    super.initState();
    _loadIsSimple();
  }

  _loadIsSimple() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSimple = (prefs.getBool('isSimple') ??
          true); // Try reading data from the mainData key. If it doesn't exist, return 0.
    });
  }

  _getIsSimple() async {}

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    final mode = Provider.of<User>(context);

    var colorSimpleButton;
    var colorSportifButton;
    if (_isSimple) {
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  _isSimple = true;
                                  prefs.setBool('isSimple', _isSimple);
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  _isSimple = false;
                                  prefs.setBool('isSimple', _isSimple);
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
            Future<String> getDbPath() async {
              String pathDb = await getDatabasesPath();
              print(pathDb);
              return pathDb;
            }

            var databasesPath = getDbPath();
            String path = join(databasesPath.toString(), 'data4.db');
            void createDataBase() async {
              Database database = await openDatabase(path, version: 1,
                  onCreate: (Database db, int version) async {
                // When creating the db, create the table
                await db.execute(
                    'CREATE TABLE DataSortie (id INTEGER PRIMARY KEY, date TEXT)');
                await db.execute(
                    'CREATE TABLE DataMoy (id INTEGER PRIMARY KEY, speed INTEGER, power INTEGER, heartbeat INTEGER, cadency INTEGER, time INTEGER, idSortie INTEGER, FOREIGN KEY(idSortie) REFERENCES DataSortie(id))');
              });

              await database.transaction((txn) async {
                DateTime now = DateTime.now();
                String formattedDate =
                    DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
                print(formattedDate);
                await txn.rawInsert('INSERT INTO DataSortie (date) VALUES ("' +
                    formattedDate +
                    '")');
                //print('inserted1: $id1');
              });

              List<Map> list =
                  await database.rawQuery('SELECT * FROM DataSortie');
              print(list);
            }

            createDataBase();
            if (_isSimple) {
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
