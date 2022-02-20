import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/controllers/secureStorage.dart';
import 'package:durkhawpui/model/user.dart';
import 'package:durkhawpui/ui/commonWidgets/dialogCommon.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeSettings/widgets/aboutPage.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeSettings/widgets/editText.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/subPages/NGOList/ngoList.dart';
import 'package:durkhawpui/ui/initial/signIn.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeSettings extends StatefulWidget {
  const HomeSettings({Key? key}) : super(key: key);

  @override
  _HomeSettingsState createState() => _HomeSettingsState();
}

class _HomeSettingsState extends State<HomeSettings> {
  final _userCtrl = Get.find<UserController>();
  final decorOne = BoxDecoration(
    color: Colors.grey[700],
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(8),
    ),
  );

  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Member user = _userCtrl.user.value;
    late bool signedIn;
    if (user.userId != "") {
      signedIn = true;
    } else {
      signedIn = false;
    }
    return SafeArea(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            expandedHeight: Get.width * 0.5,
            flexibleSpace: Container(
              width: double.infinity,
              height: Get.width * 0.5,
              color: Colors.grey[800],
              child: Center(
                child: Container(
                  width: Get.width * 0.35,
                  height: Get.width * 0.35,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        foregroundImage: AssetImage('assets/dp.png'),
                        maxRadius: Get.width * 0.35,
                        minRadius: Get.width * 0.35,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              decoration: decorOne,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Obx(
                      () => Text(
                        Get.find<UserController>().user.value.name,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    leading: Icon(Icons.person_outline),
                    trailing: IconButton(
                      onPressed: () {
                        controller.text = _userCtrl.user.value.name;
                        Get.dialog(EditTextDialog(
                          controller: controller,
                          enterNumber: false,
                          onConfirm: () {
                            Get.back();
                            Get.dialog(Center(
                              child: CupertinoActivityIndicator(),
                            ));
                            _userCtrl.updateName(controller.text).then((value) {
                              Get.back();
                            });
                          },
                        ));
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 15,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      _userCtrl.user.value.email,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    leading: Icon(Icons.alternate_email),
                  ),
                  ListTile(
                    title: Obx(
                      () => Text(
                        Get.find<UserController>().user.value.phone,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    leading: Icon(Icons.phone_android),
                    trailing: IconButton(
                      onPressed: () {
                        controller.text = _userCtrl.user.value.phone;
                        Get.dialog(EditTextDialog(
                          controller: controller,
                          enterNumber: true,
                          onConfirm: () {
                            Get.back();
                            Get.dialog(Center(
                              child: CupertinoActivityIndicator(),
                            ));
                            _userCtrl
                                .updatePhone(controller.text)
                                .then((value) {
                              Get.back();
                            });
                          },
                        ));
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  FutureBuilder(
                    future: Get.find<SecureController>().checkNotiStatus(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        bool isOn = snap.data as bool;
                        return ListTile(
                          title: Text(
                            'Notifications',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          trailing: Switch(
                              value: isOn,
                              onChanged: (value) {
                                setState(() {
                                  isOn = value;
                                });
                                Get.find<SecureController>()
                                    .switchNoti(newValue: value)
                                    .then((value) {
                                  setState(() {});
                                });
                              }),
                          leading: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_active,
                              size: 25,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              isOn = !isOn;
                            });
                            Get.find<SecureController>()
                                .switchNoti(newValue: isOn)
                                .then((value) {
                              setState(() {});
                            });
                          },
                        );
                      }
                      return ListTile(
                        title: Text(
                          'Notifications',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        trailing: Switch(value: true, onChanged: (value) {}),
                        leading: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications_active,
                            size: 25,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Rate app',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    leading: IconButton(
                      onPressed: () async {
                        final String _url =
                            "https://play.google.com/store/apps/details?id=com.durtlang.app";
                        await canLaunch(_url)
                            ? await launch(_url)
                            : throw 'Could not launch ';
                      },
                      icon: Icon(
                        Icons.star_rate_rounded,
                        size: 25,
                      ),
                    ),
                    onTap: () async {
                      final String _url =
                          "https://play.google.com/store/apps/details?id=com.durtlang.app";
                      await canLaunch(_url)
                          ? await launch(_url)
                          : throw 'Could not launch ';
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Terms and Conditions',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    leading: IconButton(
                      onPressed: () async {
                        //TODO TnC link dah tur
                        final String _url =
                            "https://play.google.com/store/apps/details?id=com.durtlang.app";
                        await canLaunch(_url)
                            ? await launch(_url)
                            : throw 'Could not launch ';
                      },
                      icon: Icon(
                        Icons.view_list_outlined,
                        size: 25,
                      ),
                    ),
                    onTap: () {
                      //TODO TnC link dah tur
                    },
                  ),
                  ListTile(
                    title: Text(
                      'NGOs',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    leading: IconButton(
                      onPressed: () {
                        Get.to(() => NgoListPage());
                      },
                      icon: Icon(
                        Icons.people_alt,
                        size: 25,
                      ),
                    ),
                    onTap: () {
                      Get.to(() => NgoListPage());
                    },
                  ),
                  ListTile(
                    title: Text(
                      'About',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    leading: IconButton(
                      onPressed: () {
                        Get.to(() => AboutPage());
                      },
                      icon: Icon(
                        Icons.info_outline,
                        size: 25,
                      ),
                    ),
                    onTap: () {
                      Get.to(() => AboutPage());
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      autButtonClick(signedIn);
                    },
                    child: Text(
                      signedIn ? "Log Out" : "Sign In",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void autButtonClick(bool signedIn) {
    if (signedIn) {
      //sign out
      Get.dialog(
        Center(
          child: CommonDialog(
            title: "Attention",
            body: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Sign out I duh tak tak em?'),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Constants.primary),
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "Aih",
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Constants.primary),
                        onPressed: () async {
                          var _guest = Member(
                            userId: '',
                            name: 'Guest',
                            email: '',
                            phone: '',
                            role: 'user',
                            avatarUrl: "",
                            createdAt: DateTime.now(),
                          );
                          await FirebaseAuth.instance.signOut();
                          setState(() {
                            _userCtrl.user.value = _guest;
                          });
                          Get.back();
                        },
                        child: Text(
                          "Aw",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      Get.to(() => SignIn());
    }
  }
}
