import 'package:flutter/material.dart';

class HomeNotices extends StatefulWidget {
  const HomeNotices({Key? key}) : super(key: key);

  @override
  _HomeNoticesState createState() => _HomeNoticesState();
}

class _HomeNoticesState extends State<HomeNotices> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Home Notices"),
      ),
    );
  }
}
