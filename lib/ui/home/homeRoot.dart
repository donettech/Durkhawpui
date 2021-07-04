import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/controllers/secureStorage.dart';
import 'package:durkhawpui/model/user.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeMain.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeNotices.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeQuarantines.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeSettings.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeRoot extends StatefulWidget {
  HomeRoot({Key? key}) : super(key: key);

  @override
  _HomeRootState createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Get.find<SecureController>().storage.deleteAll().then((value) {
      //     //   setState(() {});
      //     // });
      //     // FirebaseAuth.instance.signOut();
      //     var user = Get.find<UserController>().user.value;
      //     print(user.email);
      //   },
      // ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            HomeMain(),
            HomeNotices(),
            HomeQuarantines(),
            HomeSettings(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        backgroundColor: Constants.secondary,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text(
              'Home',
              style: GoogleFonts.roboto(
                color: Colors.white,
              ),
            ),
            icon: Icon(Icons.home),
            activeColor: Constants.primary,
            inactiveColor: Colors.black87,
          ),
          BottomNavyBarItem(
            title: Text(
              'Notices',
              style: GoogleFonts.roboto(
                color: Colors.white,
              ),
            ),
            icon: Icon(Icons.list),
            activeColor: Constants.primary,
            inactiveColor: Colors.black87,
          ),
          BottomNavyBarItem(
            title: Text(
              'Quarantines',
              style: GoogleFonts.roboto(
                color: Colors.white,
              ),
            ),
            icon: Icon(Icons.person_outlined),
            activeColor: Constants.primary,
            inactiveColor: Colors.black87,
          ),
          BottomNavyBarItem(
            title: Text(
              'Settings',
              style: GoogleFonts.roboto(
                color: Colors.white,
              ),
            ),
            icon: Icon(Icons.settings),
            activeColor: Constants.primary,
            inactiveColor: Colors.black87,
          ),
        ],
      ),
    );
  }
}