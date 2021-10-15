import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/creator.dart';
import 'package:durkhawpui/model/stats.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeMain/widgets/editDinhmun.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DinhmunCard extends StatefulWidget {
  DinhmunCard({Key? key}) : super(key: key);

  @override
  _DinhmunCardState createState() => _DinhmunCardState();
}

class _DinhmunCardState extends State<DinhmunCard> {
  final _fire = FirebaseFirestore.instance.collection('home');

  final userCtrl = Get.find<UserController>();
  CovStats stat = CovStats(
    active: 00,
    total: 00,
    deceased: 00,
    updatedAt: DateTime.now(),
    updatedBy: Creator(id: 'id', name: 'name'),
    createdAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    listenStat();
  }

  void listenStat() {
    _fire.doc('stats').snapshots().listen((event) {
      if (event.exists) {
        var js = event.data()!;
        CovStats _stat = CovStats.fromJson(js);
        if (mounted)
          setState(() {
            stat = _stat;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              'Covid-19 Dinhmun',
              style: GoogleFonts.ebGaramond(fontSize: 20),
            ),
            SizedBox(height: 2),
            Divider(thickness: 1),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Dam tawh',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ebGaramond(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Vei mek",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ebGaramond(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Boral tawh",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ebGaramond(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    stat.total.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    stat.active.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    stat.deceased.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
        if (userCtrl.user.value.role == "admin")
          Positioned(
            right: 5,
            child: IconButton(
              onPressed: () {
                stat.updatedBy = Creator(
                    id: userCtrl.user.value.userId,
                    name: userCtrl.user.value.name);
                Get.dialog(
                  EditDinhmunDialog(stat: stat),
                );
              },
              icon: Icon(Icons.edit),
            ),
          ),
      ],
    ));
  }
}
