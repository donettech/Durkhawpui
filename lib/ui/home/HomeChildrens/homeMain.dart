import 'package:durkhawpui/utils/constants.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'subPages/calendarEdit.dart';
import 'widgets/dinhmun.dart';
import 'widgets/todayData.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Get.to(() => CalendarEdit());
        //   },
        //   child: Icon(Icons.edit),
        // ),
        floatingActionButton: FabCircularMenu(
          fabSize: 50,
          key: fabKey,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Get.to(() => CalendarEdit());
                }),
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Get.to(() => CalendarEdit());
                }),
            IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Get.to(() => CalendarEdit());
                })
          ],
          alignment: Alignment.topLeft,
          fabMargin: EdgeInsets.only(
            top: 10,
            left: 10,
          ),
          ringDiameter: 300,
          ringWidth: 70,
          fabColor: Constants.secondary,
          ringColor: Constants.secondary.withOpacity(0.55),
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TodayData(),
              DinhmunCard(),
            ],
          ),
        ),
      ),
    );
  }
}
