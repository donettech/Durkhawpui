import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeNotices/widgets/addNotice.dart';
import 'package:durkhawpui/ui/home/homeSettings/widgets/notification_tile.dart';
import 'package:durkhawpui/ui/home/homeSettings/widgets/them_tile.dart';
import 'package:durkhawpui/ui/home/pages/privacy_policy.dart';
import 'package:durkhawpui/ui/home/pages/tnc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/language_tile.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  final userCtrl = Get.find<UserController>();

  Future<String> getBuildInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var inf = packageInfo.version;
    return inf;
  }

  void launchUrl() async {
    String url =
        "https://play.google.com/store/apps/details?id=com.durtlang.app";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            _buildPhoto(),
            Padding(padding: const EdgeInsets.only(top: 20)),
            if (userCtrl.user.value.role == "admin")
              SliverToBoxAdapter(
                child: _buildAdminOptions(),
              ),
            Padding(padding: const EdgeInsets.only(top: 20)),
            _buildAppSettings(),
            Padding(padding: const EdgeInsets.only(top: 20)),
            _buildLegals(),
            Padding(padding: const EdgeInsets.only(top: 20)),
            const Spacer(),
            _getVersion(),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget _getVersion() {
    return FutureBuilder(
      future: getBuildInfo(),
      builder: (context, snap) {
        if (snap.hasData) {
          var data = snap.data;
          return Text(
            "v " + data.toString(),
            style: GoogleFonts.roboto(
              fontSize: 12,
            ),
          );
        }
        return Text("");
      },
    );
  }

  Widget _buildLegals() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.event_note_sharp),
            title: Text("Privacy Policy"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.to(() => PrivacyPolicy());
            },
          ),
          ListTile(
            leading: Icon(Icons.view_list_outlined),
            title: Text("Terms and Conditions"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.to(() => TermsAndConditions());
            },
          ),
          ListTile(
            leading: Icon(Icons.star_border),
            title: Text("Rate the app"),
            trailing: Icon(Icons.chevron_right),
            onTap: launchUrl,
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NotificationTile(),
          ThemeTile(),
          LanguageTile(),
        ],
      ),
    );
  }

  Widget _buildAdminOptions() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.add_comment_outlined),
            title: Text("Create Announcement"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.to(() => AddNewNotice());
            },
          ),
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text("View admins"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.to(() => AddNewNotice());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhoto() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              maxRadius: 45,
              minRadius: 45,
              child: ClipOval(
                child: Image.asset(
                  'assets/dp.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    userCtrl.user.value.name,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    userCtrl.user.value.email,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
