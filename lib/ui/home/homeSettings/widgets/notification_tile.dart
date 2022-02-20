import 'package:durkhawpui/controllers/secureStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationTile extends StatefulWidget {
  const NotificationTile({Key? key}) : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  final storage = Get.find<SecureController>();
  bool notiState = false;

  @override
  void initState() {
    super.initState();
    _readState();
  }

  void _readState() {
    storage.checkNotiStatus().then((value) {
      setState(() {
        notiState = value;
      });
    });
  }

  void updateState(bool state) {
    setState(() {
      notiState = state;
    });
    storage.switchNoti(newValue: state);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.notifications_none),
      title: Text("Notifications"),
      trailing: Switch(value: notiState, onChanged: updateState),
      onTap: () {
        updateState(!notiState);
      },
    );
  }
}
