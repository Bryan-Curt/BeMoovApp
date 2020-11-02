import 'package:flutter/material.dart';

class BleConnexion extends StatelessWidget {
  // Gestion de la future connexion bluetooth
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 700),
          children: [
            Text(
              "BLE pas encore implémenté",
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: 100),
          child: FlatButton(
            onPressed: () async {
              Navigator.pushNamed(context, 'aviitamConnexionPage');
            },
            child:
                Text('CONNEXION AVIITAM', style: TextStyle(color: Colors.red)),
            textColor: Colors.red,
            padding: EdgeInsets.all(20),
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
