import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/services/authentication_service.dart';
import 'package:provider_architecture/locator.dart';
import 'package:provider_architecture/ui/router.dart';

import 'core/models/user.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

//Main de l'application, sert à lancer l'application sur la première page (first_view) et bien définir la route
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>(
      initialData: User.initial(),
      create: (BuildContext context) =>
          locator<AuthenticationService>().userController.stream,
      child: MaterialApp(
        title: 'BeMoov',
        theme: ThemeData(),
        initialRoute: 'firstPage',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
