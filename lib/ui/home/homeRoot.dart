import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeMain/homeMain.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeNotices/homeNotices.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeQuarantines/homeQuarantines.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeSettings/homeSettings.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
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
        animationDuration: Duration(milliseconds: 800),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text(
              'Home',
              style: GoogleFonts.roboto(
                color: _currentIndex == 0
                    ? Constants.tabBarSelectedColor
                    : Colors.white,
              ),
            ),
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0
                  ? Constants.tabBarSelectedColor
                  : Colors.white,
            ),
            activeColor: Constants.primary,
            inactiveColor: Colors.black87,
          ),
          BottomNavyBarItem(
            title: Text(
              'Thuchhuah',
              style: GoogleFonts.roboto(
                color: _currentIndex == 1
                    ? Constants.tabBarSelectedColor
                    : Colors.white,
              ),
            ),
            icon: Icon(
              Icons.list,
              color: _currentIndex == 1
                  ? Constants.tabBarSelectedColor
                  : Colors.white,
            ),
            activeColor: Constants.primary,
            inactiveColor: Colors.black87,
          ),
          BottomNavyBarItem(
            title: Text(
              'Quarantines',
              style: GoogleFonts.roboto(
                color: _currentIndex == 2
                    ? Constants.tabBarSelectedColor
                    : Colors.white,
              ),
            ),
            icon: Icon(
              Icons.people_alt_outlined,
              color: _currentIndex == 2
                  ? Constants.tabBarSelectedColor
                  : Colors.white,
            ),
            activeColor: Constants.primary,
            inactiveColor: Colors.black87,
          ),
          BottomNavyBarItem(
            title: Text(
              'Settings',
              style: GoogleFonts.roboto(
                color: _currentIndex == 3
                    ? Constants.tabBarSelectedColor
                    : Colors.white,
              ),
            ),
            icon: Icon(
              Icons.settings,
              color: _currentIndex == 3
                  ? Constants.tabBarSelectedColor
                  : Colors.white,
            ),
            activeColor: Constants.primary,
            inactiveColor: Colors.black87,
          ),
        ],
      ),
    );
  }
}
