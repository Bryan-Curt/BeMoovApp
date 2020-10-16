import 'package:flutter/material.dart';

//Première vue de l'application, correspond à la première page, une page servant d'affichage, de temporisation avant de rediriger vers les connexions ble et aviitam

class FirstView extends StatelessWidget {
  //Classe composée de widgets
  @override
  Widget build(BuildContext context) {
    //construction des widgets
    Widget imagesection = Container(
      // premier widget gérant l'image
      padding: const EdgeInsets.only(top: 60),
      child: Image.asset(
        'images/logoaccueil.jpg',
        fit: BoxFit.cover,
      ),
    );

    Widget titlesection = Container(
      //deuxième widget gérant le titre (BEMOOV)
      padding: const EdgeInsets.only(top: 60, bottom: 90),
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
      //troisième widget gérant le bouton de connexion
      padding: EdgeInsets.symmetric(horizontal: 70),
      child: FlatButton(
        onPressed: () async {
          Navigator.pushNamed(context, 'bleConnexionPage');
        },
        child: Text('CONNEXION', style: TextStyle(color: Colors.red)),
        textColor: Colors.red,
        padding: EdgeInsets.all(20),
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
          padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            imagesection, //appel de l'image
            titlesection, // appel du titre
            buttonsection, // appel du bouton
          ],
        ),
      ),
    );
  }
}
