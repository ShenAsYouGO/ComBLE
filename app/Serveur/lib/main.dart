import 'package:flutter/material.dart';
import 'package:serveur_app/recepteur.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bluetooth Receiver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothReceiver(),
    );
  }
}