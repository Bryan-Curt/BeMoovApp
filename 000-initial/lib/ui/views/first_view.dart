import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/enums/viewstate.dart';
import 'package:provider_architecture/core/models/post.dart';
import 'package:provider_architecture/core/models/user.dart';
import 'package:provider_architecture/core/viewmodels/home_model.dart';
import 'package:provider_architecture/ui/shared/app_colors.dart';
import 'package:provider_architecture/ui/shared/text_styles.dart';
import 'package:provider_architecture/ui/shared/ui_helpers.dart';
import 'package:provider_architecture/ui/widgets/postlist_item.dart';

import 'dart:async';
import 'dart:math';

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget imagesection = Container(
      padding: const EdgeInsets.only(top: 60),
      child: Image.asset(
        'images/logoaccueil.jpg',
        fit: BoxFit.cover,
      ),
    );

    Widget titlesection = Container(
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
      title: 'Flutter layout demo',
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            imagesection,
            titlesection,
            buttonsection,
          ],
        ),
      ),
    );
  }
}
