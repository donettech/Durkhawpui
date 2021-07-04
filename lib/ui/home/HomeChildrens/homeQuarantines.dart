import 'package:flutter/material.dart';

class HomeQuarantines extends StatefulWidget {
  const HomeQuarantines({Key? key}) : super(key: key);

  @override
  _HomeQuarantinesState createState() => _HomeQuarantinesState();
}

class _HomeQuarantinesState extends State<HomeQuarantines> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Home Quarantines"),
      ),
    );
  }
}
