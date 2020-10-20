import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/user.dart';

const oneSec = const Duration(seconds: 1);

//classe de déppart avant de lancer l'activitée
class SimpleMonitoring extends StatelessWidget {
  var t = new Timer.periodic(oneSec, (Timer t) => print("uygi"));
  @override
  Widget build(BuildContext context) {
    Widget sportifbuttonsection = Container(
        height: 450,
        width: 300,
        padding: EdgeInsets.only(top: 150),
        child: CircularProgressIndicator(
          value: 0.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          backgroundColor: Colors.grey,
          strokeWidth: 15,
        ));

    return Provider<MyMode>(
      create: (context) => MyMode(),
      child: Scaffold(
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Center(child: sportifbuttonsection),
          ],
        ),
      ),
    );
  }
}
