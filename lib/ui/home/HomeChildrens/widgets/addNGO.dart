import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/ngo.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNGO extends StatefulWidget {
  final NgoModel? ngoModel;
  AddNGO({Key? key, this.ngoModel}) : super(key: key);

  @override
  _AddNGOState createState() => _AddNGOState();
}

class _AddNGOState extends State<AddNGO> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _form = GlobalKey<FormState>();

  final _fire = FirebaseFirestore.instance.collection('ngos');

  @override
  void initState() {
    if (widget.ngoModel != null) {
      _title.text = widget.ngoModel!.name;
      _desc.text = widget.ngoModel!.desc;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _title,
              decoration: new InputDecoration(
                labelText: "Title(Abbreviation)",
                hintText: "Hming(Kaih tawi ni thei se)",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Constants.primary),
                ),
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Constants.primary),
                ),
              ),
              validator: (val) {
                if (val!.length == 0) {
                  return "Dah awl theih anilo";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _desc,
              decoration: new InputDecoration(
                labelText: "Description",
                hintText: "Sawifiahna",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Constants.primary),
                ),
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Constants.primary),
                ),
              ),
              maxLines: 5,
              validator: (val) {
                if (val!.length == 0) {
                  return "Dah awl theih anilo";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                if (_form.currentState!.validate()) {
                  String _slug = _desc.text.replaceAll(' ', "_").toLowerCase();
                  if (widget.ngoModel != null) {
                    widget.ngoModel!.name = _title.text;
                    widget.ngoModel!.desc = _desc.text;
                    widget.ngoModel!.slug = _slug;
                    widget.ngoModel!.updatedAt = DateTime.now();
                    _fire
                        .doc(widget.ngoModel!.docId)
                        .update(widget.ngoModel!.toJson());
                  } else {
                    NgoModel model = NgoModel(
                      docId: '',
                      name: _title.text,
                      desc: _desc.text,
                      slug: _slug,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    _fire.add(model.toJson());
                  }
                  Get.back();
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Constants.primary,
              ),
              child: Text("Confirm"),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
