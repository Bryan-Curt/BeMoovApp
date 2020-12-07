import 'package:flutter/material.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
//Première vue de l'application, correspond à la première page, une page servant d'affichage, de temporisation avant de rediriger vers les connexions ble et aviitam

class FirstView extends StatelessWidget {
  //Classe composée de widgets
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    //construction des widgets
    Widget imagesection = Container(
      // premier widget gérant l'image
      //height: screenHeight,
      width: screenWidth,
      padding: EdgeInsets.only(top: screenHeight * 0.06),
      child: Image.asset(
        'images/logoaccueil1.png',
        fit: BoxFit.cover,
      ),
    );

    Widget titlesection = Container(
      //deuxième widget gérant le titre (BEMOOV)
      width: screenWidth * 0.1,
      height: screenHeight * 0.8,
      //padding: const EdgeInsets.only(top: screenHeight * 90, bottom: 90),
      padding: EdgeInsets.only(top: screenHeight * 0.05),
      child: Text(
        'BEMOOV',
        style: TextStyle(
          fontFamily: 'RobotoThin',
          fontStyle: FontStyle.normal,
          fontSize: screenHeight * 0.060,
        ),
        textAlign: TextAlign.center,
      ),
    );

    Widget buttonsection = Container(
      //troisième widget gérant le bouton de connexion
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.170, vertical: screenHeight * 0.056),
      child: FlatButton(
        onPressed: () async {
          Navigator.pushNamed(context, 'bleConnexionPage');
        },
        child: Text('CONNEXION', style: TextStyle(color: Colors.red)),
        textColor: Colors.red,
        padding: EdgeInsets.all(screenHeight * 0.0223),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.red, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(25)),
      ),
    );

    return MaterialApp(
      //Ce qui est renvoyé à l'écran
      title: 'BeMoov',
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.022),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            imagesection, //appel de l'image
            titlesection, // appel du titre
          ],
        ),
        bottomNavigationBar: buttonsection, // appel du bouton
      ),
    );
  }
}
