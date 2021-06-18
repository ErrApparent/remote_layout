import 'package:flutter/material.dart';

import 'package:remote_layout/remote_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Layout Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final RemoteBoxConstraints constraints;
  late final RemoteLayoutController controller;

  @override
  void initState() {
    super.initState();
    constraints = RemoteBoxConstraints();
    controller = RemoteLayoutController(
        destination: constraints,
        adaptor: (constraints, size) => BoxConstraints.loose(size));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Layout Example'),
        centerTitle: true,
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(children: [
                Container(height: 100, width: 100, color: Colors.red),
                RemoteLayoutTransmitter(
                  controller: controller,
                  child: Expanded(
                      child: Container(height: 100, color: Colors.green)),
                ),
                Container(height: 100, width: 100, color: Colors.blue),
              ]),
              SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(child: Container(color: Colors.redAccent)),
                    ConstrainedBox(
                      constraints: constraints,
                      child: Container(color: Colors.greenAccent),
                    ),
                    Flexible(child: Container(color: Colors.blueAccent)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
