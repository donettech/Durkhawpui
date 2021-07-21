import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/ngo.dart';
import 'package:durkhawpui/ui/commonWidgets/dialogCommon.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/widgets/addNGO.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NgoListPage extends StatefulWidget {
  const NgoListPage({Key? key}) : super(key: key);

  @override
  _NgoListPageState createState() => _NgoListPageState();
}

class _NgoListPageState extends State<NgoListPage> {
  final _fire = FirebaseFirestore.instance;
  List<NgoModel> ngoList = [];

  @override
  void initState() {
    super.initState();
    getNGOs();
  }

  void getNGOs() async {
    var res = _fire
        .collection('ngos')
        .orderBy('createdAt', descending: true)
        .snapshots();
    res.listen((event) {
      List<NgoModel> _temp = [];
      ngoList.clear();
      var docs = event.docs;
      docs.forEach((element) {
        NgoModel model = NgoModel.fromJson(element.data(), element.id);
        _temp.add(model);
      });
      setState(() {
        ngoList.addAll(_temp);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("NGO list"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(Center(
              child: CommonDialog(
                title: "NGO thar dahluhna",
                body: AddNGO(),
              ),
            ));
          },
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: ngoList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              child: ListTile(
                title: Text(ngoList[index].name),
                subtitle: Text(ngoList[index].desc),
                onTap: () {
                  Get.dialog(Center(
                    child: CommonDialog(
                      title: "NGO thar dahluhna",
                      body: AddNGO(
                        ngoModel: ngoList[index],
                      ),
                    ),
                  ));
                },
              ),
            );
          },
        ));
  }
}
