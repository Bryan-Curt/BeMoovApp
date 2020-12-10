import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StatefullWidgetDemo extends StatefulWidget {
  @override
  _StatefulWidgetDemoState createState() {
    return new _StatefulWidgetDemoState();
  }
}

class _StatefulWidgetDemoState extends State<StatefullWidgetDemo> {
  List _listFromFile = [];

  _StatefulWidgetDemoState() {
    getTextFromFile().then((val) => setState(() {
          _listFromFile = val.split("}, {");
          print(_listFromFile);
        }));
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Vos précédents entrainements'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: new EdgeInsets.all(8.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _listFromFile.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * .025),
              child: Text(
                _listFromFile[index],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String> getFileData(String path) async {
    Future<String> getDbPath() async {
      String pathDb = await getDatabasesPath();
      return pathDb;
    }

    var databasesPath = getDbPath();
    String path = join(databasesPath.toString(), 'data4.db');
    print(path);
    Future<String> getDatabaseText() async {
      Database database = await openDatabase(path,
          version: 1, onCreate: (Database db, int version) async {});

      List<Map> list = await database.rawQuery(
          'SELECT DataSortie.date, round(max(dataMoy.time)/60) as minutes, avg(dataMoy.speed) as vitesse, avg(dataMoy.heartbeat) as bpm, avg(dataMoy.power) as puissance, avg(dataMoy.cadency) as cadence FROM DataMoy INNER JOIN DataSortie ON (DataSortie.id = DataMoy.idSortie) GROUP BY DataSortie.id');
      // print(list.toString());
      return list.toString();
    }

    return getDatabaseText();
  }

  Future<String> getTextFromFile() async {
    return await getFileData("test.txt");
  }
}
