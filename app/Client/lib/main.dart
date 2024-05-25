import 'dart:async';
import 'package:clientapp/sendmsg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Scanner',
      routes: {
        '/': (context) => const BleScanner(),
      },
    );
  }
}

class BleScanner extends StatefulWidget {
  const BleScanner({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BleScannerState createState() => _BleScannerState();
}

class _BleScannerState extends State<BleScanner> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devices = [];
  BluetoothDevice? connectedDevice;
  StreamSubscription<BluetoothConnectionState>? deviceConnection;

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
      });
      // Listen to the connection state of this device
      deviceConnection =
          device.connectionState.listen((BluetoothConnectionState state) {
        if (state == BluetoothConnectionState.connected) {
          print(
              'Device connected: ${device.platformName} (${device.remoteId})');
          // Update the state to reflect the connected device
          setState(() {
            //change the page to the next page
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Sendmsg();
            }));
          });
        } else if (state == BluetoothConnectionState.disconnected) {
          print(
              'Device disconnected: ${device.platformName} (${device.remoteId})');
          setState(() {
            connectedDevice = null;
          });
        }
      });
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  void disconnectToDevice() async {
    if (connectedDevice != null &&
        connectedDevice?.connectionState == "connected") {
      await connectedDevice?.disconnect();
    }
    // Once disconnected, you can perform operations on the device.
  }

  @override
  void initState() {
    super.initState();
    startScanning();
  }

  void startScanning() async {
    await FlutterBluePlus.startScan();
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          setState(() {
            if (result.device.platformName != '') {
              devices.add(result.device);
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].advName.toString()),
                  subtitle: Text(devices[index].remoteId.toString()),
                  onTap: () {
                    connectToDevice(devices[index]);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                width: 250,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      devices.clear();
                    });
                    startScanning();
                  },
                  tooltip: 'Actualisé',
                  child: const Text('Actualisé'),
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                height: 40,
                width: 70,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Sendmsg();
                    }));
                  },
                  tooltip: 'Connect',
                  child: const Text('Connect'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}
