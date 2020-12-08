import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider_architecture/ui/views/first_view.dart';
import 'package:provider_architecture/ui/views/ble_view.dart';
import 'package:provider_architecture/ui/views/aviitam_view.dart';
import 'package:provider_architecture/ui/views/simple_view.dart';
import 'package:provider_architecture/ui/views/start_view.dart';
import 'package:provider_architecture/ui/views/sportif_view.dart';
import 'package:provider_architecture/ui/views/pause_view.dart';
import 'package:provider_architecture/ui/views/bd.dart';
import 'package:provider_architecture/ui/views/pastTrainingInfo_view.dart';

// Page qui définit dynamiquement toutes les routes, permet de gérer les liens des boutons notemment.
const String initialRoute = "firstPage";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'firstPage':
        return MaterialPageRoute(builder: (_) => FirstView());
      case 'bleConnexionPage':
        return MaterialPageRoute(builder: (_) => BleConnexion());
      case 'aviitamConnexionPage':
        return MaterialPageRoute(builder: (_) => AviitamConnexion());
      case 'startPage':
        return MaterialPageRoute(builder: (_) => InitStartView());
      case 'simple':
        return MaterialPageRoute(builder: (_) => InitSimpleMonitoring());
      case 'sportif':
        return MaterialPageRoute(builder: (_) => InitSportifMonitoring());
      case 'pause':
        return MaterialPageRoute(builder: (_) => InitPauseView());
      case 'bd':
        return MaterialPageRoute(builder: (_) => InitDBView());
      case 'pastTraining':
        return MaterialPageRoute(builder: (_) => StatefullWidgetDemo());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
