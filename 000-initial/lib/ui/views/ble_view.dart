// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider_architecture/ui/views/simple_view.dart';
import 'package:provider_architecture/ui/views/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                            result: r,
                            onTap: () async {
                              List<BluetoothDevice> connectedDevices =
                                  await FlutterBlue.instance.connectedDevices;

                              if (connectedDevices.contains(r.device)) {
                                r.device.disconnect();
                              }
                              r.device.connect();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InitSimpleMonitoring(
                                              device: r.device)));
                              /*
                              Navigator.pushNamed(context, 'firstPage');
                              
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                print("AAAAAAAAA" + r.device.toString());

                                //return DeviceScreen(device: r.device);
                              }));
                              */
                            }),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

List<dynamic> getDataList(BluetoothDevice d) {
  var l = List(6);
  l.fillRange(0, 4, '00');
  l[4] = 0;
  l[5] = d;
  return l;
}

/*
class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);
  //final BuildContext context;
  final BluetoothDevice device;

  Widget build(BuildContext context) {
    //Navigator.pushNamed(context, 'simple');
    //Navigator.pushNamed(context, 'simple', arguments: device);
/*
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InitSimpleMonitoring(),
            // Pass the arguments as part of the RouteSettings. The
            // DetailScreen reads the arguments from these settings.
            settings: RouteSettings(arguments: getDataList(device))));
  }
*/
    //noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  }
}
*/
