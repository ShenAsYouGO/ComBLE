import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Communication BLE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BLE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;

  void _incrementCounter() {
    setState(() {
      //_counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pick one',
            ),
            SizedBox(height: 20), // Add some space between the buttons and the counter
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: FloatingActionButton(
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: Text('Serveur'),
                  ),
                ),
                SizedBox(width: 20), // Add space between the buttons
                SizedBox(
                  width: 150,
                  height: 150,
                  child: FloatingActionButton(
                    onPressed: _incrementCounter, // Function for decrementing
                    tooltip: 'Decrement', // Tooltip for decrement button
                    child: Text('Client'), // Icon for decrement button
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
