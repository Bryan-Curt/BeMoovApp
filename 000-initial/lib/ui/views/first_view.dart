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
      padding: const EdgeInsets.only(top: 60),
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
      padding: const EdgeInsets.all(100),
      child: Container(
        //width: 10,
        //padding: EdgeInsets.symmetric(horizontal: 150, vertical: 30),
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.red),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 60,
            ),
            Text(
              "CONNEXION",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        body: ListView(
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
