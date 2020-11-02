import 'package:flutter/material.dart';
import 'package:responsive_screen/responsive_screen.dart';

class BleConnexion extends StatelessWidget {
  // Gestion de la future connexion bluetooth
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
