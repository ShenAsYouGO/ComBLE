import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

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
        '/': (context) => BleScanner(),
        '/home': (context) => home(),
      },
    );
  }
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  _homeState createState() => _homeState();
}

class BleScanner extends StatefulWidget {
  const BleScanner({super.key});

  @override
  _BleScannerState createState() => _BleScannerState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          children: [
              Text('You are connected to the device'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Disconnect'),
              ),
          ],
        ),
      ),
    );
  }
}

class _BleScannerState extends State<BleScanner> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devices = [];
  bool isLoggedIn = false;
  BluetoothDevice? connectedDevice;
  StreamSubscription<BluetoothConnectionState>? deviceConnection;


  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
      });
      // Listen to the connection state of this device
      deviceConnection = device.connectionState.listen((BluetoothConnectionState state) {
        if (state == BluetoothConnectionState.connected) {
          print('Device connected: ${device.platformName} (${device.remoteId})');
          // Update the state to reflect the connected device
          setState(() {
            //change the page to the next page
            Navigator.pushNamed(context, '/home');
          });
        } else if (state == BluetoothConnectionState.disconnected) {
          print('Device disconnected: ${device.platformName} (${device.remoteId})');
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
    if (isLoggedIn = true) {
      setState(() {
        isLoggedIn = false;
      });
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
            if(result.device.platformName != ''){
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
        title: Text(isLoggedIn ? 'Logged' : 'BLE Scanner'),
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
                    setState(() {
                      isLoggedIn = true;
                    });
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
                  onPressed: (){
                    setState(() {
                      devices.clear();
                    });
                    startScanning();
                  },
                  tooltip: 'Actualisé',
                  child: const Text('Actualisé'),
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