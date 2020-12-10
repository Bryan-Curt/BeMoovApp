import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/user.dart';
import 'package:provider_architecture/ui/views/simple_view.dart';
import 'package:provider_architecture/ui/views/sportif_view.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InitDBView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<String> getDbPath() async {
      String pathDb = await getDatabasesPath();
      return pathDb;
    }

    var databasesPath = getDbPath();
    String path = join(databasesPath.toString(), 'data.db');
    print(path);
    void createDataBase() async {
      Database database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE DataSortie (id INTEGER PRIMARY KEY, date TEXT)');
        await db.execute(
            'CREATE TABLE DataMoy (id INTEGER PRIMARY KEY, speed INTEGER, power INTEGER, heartbeat INTEGER, cadency INTEGER, idSortie INTEGER, FOREIGN KEY(idSortie) REFERENCES DataSortie(id))');
      });

      await database.transaction((txn) async {
        await txn.rawInsert(
            'INSERT INTO DataMoy(speed,power,heartbeat,cadency, idSortie) VALUES (14,110,130,75,1)');
        //print('inserted1: $id1');
      });

      List<Map> list = await database.rawQuery('SELECT * FROM DataSortie');
      print(list);
    }

    createDataBase();

    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.70),
          children: [
            Text(
              "BLE pas encore implémenté",
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: screenHeight * 0.112),
          child: FlatButton(
            onPressed: () async {
              Navigator.pushNamed(context, 'aviitamConnexionPage');
            },
            child:
                Text('CONNEXION AVIITAM', style: TextStyle(color: Colors.red)),
            textColor: Colors.red,
            padding: EdgeInsets.all(screenHeight * .025),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.red, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(25)),
          ),
        ),
      ),
    );
  }
}
