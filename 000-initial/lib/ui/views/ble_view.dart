// import 'package:flutter/material.dart';
// import 'package:responsive_screen/responsive_screen.dart';

// class BleConnexion extends StatelessWidget {
//   // Gestion de la future connexion bluetooth
//   @override
//   Widget build(BuildContext context) {
//     dynamic screenHeight = MediaQuery.of(context).size.height;
//     dynamic screenWidth = MediaQuery.of(context).size.width;
//     return MaterialApp(
//       title: 'Flutter layout demo',
//       home: Scaffold(
//         body: ListView(
//           padding: EdgeInsets.symmetric(vertical: screenHeight * 0.70),
//           children: [
//             Text(
//               "BLE pas encore implémenté",
//             ),
//           ],
//         ),
//         bottomNavigationBar: Container(
//           padding: EdgeInsets.only(bottom: screenHeight * 0.112),
//           child: FlatButton(
//             onPressed: () async {
//               Navigator.pushNamed(context, 'aviitamConnexionPage');
//             },
//             child:
//                 Text('CONNEXION AVIITAM', style: TextStyle(color: Colors.red)),
//             textColor: Colors.red,
//             padding: EdgeInsets.all(screenHeight * .025),
//             shape: RoundedRectangleBorder(
//                 side: BorderSide(
//                     color: Colors.red, width: 1, style: BorderStyle.solid),
//                 borderRadius: BorderRadius.circular(25)),
//           ),
//         ),
//       ),
//     );
//   }
// }

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

//Copyright 2017, Paul DeMarco.
//All rights reserved. Use of this source code is governed by a
//BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/widgets.dart';
import 'package:provider_architecture/ui/views/widgets.dart';

import 'aviitam_view.dart';

// void main() {
//   runApp(FlutterBlueApp());
// }

class BleConnexion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.red,
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
      backgroundColor: Colors.red,
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
        title: Text('Sélectionnez votre vélo'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          DeviceScreen(device: d),
                                    )),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
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

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  recuperationJSON() {
    print("RECUP JSON");
    Stream<List<int>> listStream;
    String serviceOui = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";
    String charOui = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

    List<BluetoothService> services =
        device.discoverServices() as List<BluetoothService>;
    //checking each services provided by device
    services.forEach((service) {
      if (service.uuid.toString() == serviceOui) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == charOui) {
            //Updating stream to perform read operation.
            listStream = characteristic.value;
          }
        });
      }
    });

    StreamBuilder<List<int>>(
      stream: listStream, //here we're using our char's value
      initialData: [],
      builder: (c, snapshot) {
        final value = snapshot.data;
        String receivedStr = ascii.decode(value);
        print("receivedStr: " + receivedStr);
      },
    );
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      await c.write(_getRandomBytes(), withoutResponse: true);
                      await c.read();
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RecupJSON {
  RecupJSON(BluetoothDevice device) : device = device;
  final BluetoothDevice device;
}

//---------------------------------------------------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// class BleConnexion extends StatefulWidget {
//   BleConnexion({Key key, this.title}) : super(key: key);
//   final FlutterBlue flutterBlue = FlutterBlue.instance;
//   final String title;
//   final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<BleConnexion> {
//   BluetoothDevice _connectedDevice;
//   List<BluetoothService> _services = new List<BluetoothService>();

//   _addDeviceTolist(final BluetoothDevice device) {
//     if (!widget.devicesList.contains(device)) {
//       setState(() {
//         widget.devicesList.add(device);
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     widget.flutterBlue.connectedDevices
//         .asStream()
//         .listen((List<BluetoothDevice> devices) {
//       for (BluetoothDevice device in devices) {
//         _addDeviceTolist(device);
//       }
//     });
//     widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
//       for (ScanResult result in results) {
//         _addDeviceTolist(result.device);
//       }
//     });
//     widget.flutterBlue.startScan();
//   }

//   ListView _buildListViewOfDevices() {
//     List<Container> containers = new List<Container>();
//     for (BluetoothDevice device in widget.devicesList) {
//       containers.add(
//         Container(
//           height: 50,
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 child: Column(
//                   children: <Widget>[
//                     Text(device.name == '' ? '(unknown device)' : device.name),
//                     Text(device.id.toString()),
//                   ],
//                 ),
//               ),
//               FlatButton(
//                 color: Colors.blue,
//                 child: Text(
//                   'Connect',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   setState(() async {
//                     widget.flutterBlue.stopScan();
//                     try {
//                       await device.connect();
//                     } catch (e) {
//                       if (e.code != 'already_connected') {
//                         throw e;
//                       }
//                     } finally {
//                       _services = await device.discoverServices();
//                     }
//                     _connectedDevice = device;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return ListView(
//       padding: const EdgeInsets.all(8),
//       children: <Widget>[
//         ...containers,
//       ],
//     );
//   }

//   ListView _buildView() {
//     if (_connectedDevice != null) {
//       return _buildConnectDeviceView();
//     }
//     return _buildListViewOfDevices();
//   }

//   List<ButtonTheme> _buildReadWriteNotifyButton(
//       BluetoothCharacteristic characteristic) {
//     List<ButtonTheme> buttons = new List<ButtonTheme>();

//     if (characteristic.properties.read) {
//       buttons.add(
//         ButtonTheme(
//           minWidth: 10,
//           height: 20,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: RaisedButton(
//               color: Colors.blue,
//               child: Text('READ', style: TextStyle(color: Colors.white)),
//               onPressed: () {},
//             ),
//           ),
//         ),
//       );
//     }
//     if (characteristic.properties.write) {
//       buttons.add(
//         ButtonTheme(
//           minWidth: 10,
//           height: 20,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: RaisedButton(
//               child: Text('WRITE', style: TextStyle(color: Colors.white)),
//               onPressed: () {},
//             ),
//           ),
//         ),
//       );
//     }
//     if (characteristic.properties.notify) {
//       buttons.add(
//         ButtonTheme(
//           minWidth: 10,
//           height: 20,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: RaisedButton(
//               child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
//               onPressed: () {},
//             ),
//           ),
//         ),
//       );
//     }

//     return buttons;
//   }

//   ListView _buildConnectDeviceView() {
//     List<Container> containers = new List<Container>();

//     for (BluetoothService service in _services) {
//       List<Widget> characteristicsWidget = new List<Widget>();
//       for (BluetoothCharacteristic characteristic in service.characteristics) {
//         characteristic.value.listen((value) {
//           print(value);
//         });
//         characteristicsWidget.add(
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Column(
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Text(characteristic.uuid.toString(),
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     ..._buildReadWriteNotifyButton(characteristic),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ),
//         );
//       }
//       containers.add(
//         Container(
//           child: ExpansionTile(
//               title: Text(service.uuid.toString()),
//               children: characteristicsWidget),
//         ),
//       );
//     }

//     return ListView(
//       padding: const EdgeInsets.all(8),
//       children: <Widget>[
//         ...containers,
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: Text('Sélectionnez votre vélo'),
//         ),
//         body: _buildView(),
//       );
// }
