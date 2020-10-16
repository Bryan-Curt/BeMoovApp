import 'package:flutter/material.dart';

//classe de déppart avant de lancer l'activitée
class StartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget menusection = Container(
      padding: const EdgeInsets.only(top: 20, right: 0, left: 325),
      child: RawMaterialButton(
        onPressed: () {},
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
        'images/logoaccueil.jpg',
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
          onPressed: () {},
          elevation: 2.0,
          fillColor: Colors.red,
          child: Icon(
            Icons.play_arrow,
            size: 100.0,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ));

    Widget simplebuttonsection = Container(
      padding: EdgeInsets.only(top: 40, left: 70, right: 70),
      child: FlatButton(
        onPressed: () async {
          Navigator.pushNamed(context, 'bleConnexionPage');
        },
        child: Text('MODE SIMPLE', style: TextStyle(color: Colors.grey)),
        textColor: Colors.grey,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.grey, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(20)),
      ),
    );

    Widget sportifbuttonsection = Container(
      padding: EdgeInsets.only(top: 20, left: 70, right: 70),
      child: FlatButton(
        onPressed: () async {
          Navigator.pushNamed(context, 'bleConnexionPage');
        },
        child: Text('MODE SPORTIF', style: TextStyle(color: Colors.orange)),
        textColor: Colors.orange,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.orange, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(20)),
      ),
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            menusection,
            imagesection,
            titlesection,
            buttonsection,
            simplebuttonsection,
            sportifbuttonsection,
          ],
        ),
      ),
    );
  }
}
