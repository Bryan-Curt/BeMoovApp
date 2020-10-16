import 'package:flutter/material.dart';

class AviitamConnexion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 700),
          children: [
            Text(
              "connexion aviitam pas encore implémentée",
            ),
            FlatButton(
              onPressed: () async {
                Navigator.pushNamed(context, 'startPage');
              },
              child: Text('ECRAN DEPART', style: TextStyle(color: Colors.red)),
              textColor: Colors.red,
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.red, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(25)),
            ),
          ],
        ),
      ),
    );
  }
}
