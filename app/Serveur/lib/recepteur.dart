import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

void main() => runApp(const FlutterBlePeripheralApp());

class FlutterBlePeripheralApp extends StatelessWidget {
  const FlutterBlePeripheralApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLE Peripheral',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BLEPeripheralPage(),
    );
  }
}

class BLEPeripheralPage extends StatefulWidget {
  const BLEPeripheralPage({Key? key}) : super(key: key);

  @override
  _BLEPeripheralPageState createState() => _BLEPeripheralPageState();
}

class _BLEPeripheralPageState extends State<BLEPeripheralPage> {
  final _flutterBlePeripheral = FlutterBlePeripheral();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  bool _isSupported = false;
  bool _isAdvertising = false;

  final AdvertiseData advertiseData = AdvertiseData(
    serviceUuid: 'bf27730d-860a-4e09-889c-2d8b6a9e0fe7',
    localName: 'test_device',
    manufacturerId: 1234,
    manufacturerData: Uint8List.fromList([1, 2, 3, 4, 5, 6]),
  );

  @override
  void initState() {
    super.initState();
    _checkBLESupport();
  }

  Future<void> _checkBLESupport() async {
    final isSupported = await _flutterBlePeripheral.isSupported;
    setState(() {
      _isSupported = isSupported;
    });
  }

  Future<void> _toggleAdvertising() async {
    if (_isAdvertising) {
      await _flutterBlePeripheral.stop();
    } else {
      await _flutterBlePeripheral.start(advertiseData: advertiseData);
    }
    setState(() {
      _isAdvertising = !_isAdvertising;
    });
  }

  Future<void> _requestPermissions() async {
    final hasPermission = await _flutterBlePeripheral.hasPermission();
    if (hasPermission == BluetoothPeripheralState.denied) {
      final result = await _flutterBlePeripheral.requestPermission();
    } else {
      _showSnackbar('Permissions already granted.');
    }
  }

  void _showSnackbar(String message) {
    _messengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: message.contains('denied') ? Colors.red : Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _messengerKey,
      appBar: AppBar(
        title: const Text('Flutter BLE Peripheral'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('BLE Supported: $_isSupported'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSupported ? _toggleAdvertising : null,
              child: Text(
                  _isAdvertising ? 'Stop Advertising' : 'Start Advertising'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestPermissions,
              child: const Text('Request Permissions'),
            ),
          ],
        ),
      ),
    );
  }
}

// class BLE extends StatelessWidget {
//   const BLE({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'BLE Scanner',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<ScanResult> scanResults = [];
//   bool isConnected = false;

//   @override
//   void initState() {
//     super.initState();
//     startScan();
//   }

//   void startScan() async {
//     if (await FlutterBluePlus.isSupported == false) {
//       print("Bluetooth not supported by this device");
//       return;
//     } else {
//       if (Platform.isAndroid) {
//         await FlutterBluePlus.turnOn();
//       }

//       setState(() {
//         scanResults.clear();
//       });

//       // Start scanning
//       FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

//       // Listen to scan results
//       FlutterBluePlus.scanResults.listen((results) {
//         setState(() {
//           scanResults = results;
//         });
//       });

//       // Stop scanning after the timeout
//       await Future.delayed(const Duration(seconds: 10));
//       FlutterBluePlus.stopScan();
//     }
//   }

//   void connection() async {
//     // Connect to a device
//     final device = scanResults.first.device;
//     await device.connect();

//     setState(() {
//       isConnected = true;
//     });

//     List<BluetoothDevice> devs = FlutterBluePlus.connectedDevices;
//     for (var d in devs) {
//       print(d);
//     }

//     // ignore: use_build_context_synchronously
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return Chat(
//         key: UniqueKey(),
//         connectedDevice: null,
//       );
//     }));

//     // Discover services
//     final services = await device.discoverServices();

//     // Print services
//     for (final service in services) {
//       print('Service: ${service.uuid}');
//       for (final characteristic in service.characteristics) {
//         print('Characteristic: ${characteristic.uuid}');
//       }
//     }

//     // Disconnect
//     await device.disconnect();
//   }

//   void disconnect() async {
//     // Disconnect from a device
//     if (isConnected == false) {
//       //ça ne marche pas.
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return const AlertDialog(
//               content: Text("Already disconnected!"),
//             );
//           });
//     }

//     final device = scanResults.first.device;
//     await device.disconnect();

//     setState(() {
//       isConnected = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('BLE Scanner'),
//         backgroundColor: isConnected ? Colors.green : Colors.blue,
//       ),
//       body: ListView.builder(
//         itemCount: scanResults.length,
//         itemBuilder: (context, index) {
//           final result = scanResults[index];
//           return ListTile(
//             title: Text(result.device.platformName.isEmpty
//                 ? 'Unknown Device'
//                 : result.device.platformName),
//             subtitle: Text(result.device.remoteId.toString()),
//             onTap: connection,
//           );
//         },
//       ),
//       floatingActionButton: Stack(
//         children: <Widget>[
//           Align(
//             alignment: Alignment.bottomRight,
//             child: FloatingActionButton(
//               onPressed: startScan,
//               child: const Icon(Icons.search),
//             ),
//           ),
//           Align(
//               alignment: Alignment.bottomCenter,
//               child: SizedBox(
//                 width: 100,
//                 child: FloatingActionButton(
//                   onPressed: disconnect,
//                   child: const Text('Disconnect'),
//                 ),
//               ))
//         ],
//       ),
//     );
//   }
// }
