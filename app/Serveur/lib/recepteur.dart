import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothReceiver extends StatefulWidget {
  @override
  _BluetoothReceiverState createState() => _BluetoothReceiverState();
}

class _BluetoothReceiverState extends State<BluetoothReceiver> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;
  List<BluetoothService> services = [];
  BluetoothCharacteristic? targetCharacteristic;
  StreamSubscription<BluetoothConnectionState>? deviceConnection;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!devicesList.contains(r.device)) {
          setState(() {
            devicesList.add(r.device);
          });
        }
      }
    });
    FlutterBluePlus.stopScan();
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
    });

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

    discoverServices();
  }

  void discoverServices() async {
    if (connectedDevice != null) {
      services = await connectedDevice!.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.read) {
            setState(() {
              targetCharacteristic = characteristic;
            });
            break;
          }
        }
      }
    }
  }

  void readData() async {
    if (targetCharacteristic != null) {
      var value = await targetCharacteristic!.read();
      print('Received data: ${String.fromCharCodes(value)}');
    }
  }

  ListView buildListViewOfDevices() {
    List<Widget> containers = [];
    for (BluetoothDevice device in devicesList) {
      containers.add(
        ListTile(
          title: Text(device.platformName == '' ? '(Unknown Device)' : device.name),
          subtitle: Text(device.remoteId.toString()),
          onTap: () {
            connectToDevice(device);
          },
        ),
      );
    }
    return ListView(
      children: containers,
    );
  }

  ListView buildListViewOfServices() {
    List<Widget> containers = [];
    for (BluetoothService service in services) {
      List<Widget> characteristicsWidget = [];
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          ListTile(
            title: Text('Characteristic: ${characteristic.uuid.toString()}'),
            onTap: () {
              setState(() {
                targetCharacteristic = characteristic;
              });
              readData();
            },
          ),
        );
      }
      containers.add(
        ExpansionTile(
          title: Text('Service: ${service.uuid.toString()}'),
          children: characteristicsWidget,
        ),
      );
    }
    return ListView(
      children: containers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Receiver'),
      ),
      body: connectedDevice == null
          ? buildListViewOfDevices()
          : buildListViewOfServices(),
    );
  }
}
