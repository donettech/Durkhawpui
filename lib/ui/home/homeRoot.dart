import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:durkhawpui/controllers/secureStorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      appBar: AppBar(title: Text("Bottom Nav Bar")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<SecureController>().storage.deleteAll().then((value) {
            setState(() {});
          });
          FirebaseAuth.instance.signOut();
        },
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              color: Colors.blueGrey,
            ),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.blue,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(title: Text('Item One'), icon: Icon(Icons.home)),
          BottomNavyBarItem(title: Text('Item Two'), icon: Icon(Icons.apps)),
          BottomNavyBarItem(
              title: Text('Item Three'), icon: Icon(Icons.chat_bubble)),
          BottomNavyBarItem(
              title: Text('Item Four'), icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}
