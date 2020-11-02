import 'package:flutter/material.dart';
import 'package:responsive_screen/responsive_screen.dart';

class AviitamConnexion extends StatelessWidget {
  //gestion de la future connexion a aviitam
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.70),
          children: [
            Text(
              "connexion aviitam pas encore implémentée",
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: screenHeight * 0.112),
          child: FlatButton(
            onPressed: () async {
              Navigator.pushNamed(context, 'startPage');
            },
            child: Text('ECRAN DEPART', style: TextStyle(color: Colors.red)),
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
