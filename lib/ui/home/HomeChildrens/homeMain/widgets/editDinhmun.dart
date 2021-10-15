import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/stats.dart';
import 'package:durkhawpui/ui/commonWidgets/dialogCommon.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditDinhmunDialog extends StatefulWidget {
  final CovStats stat;
  EditDinhmunDialog({Key? key, required this.stat}) : super(key: key);

  @override
  _EditDinhmunDialogState createState() => _EditDinhmunDialogState();
}

class _EditDinhmunDialogState extends State<EditDinhmunDialog> {
  final _total = TextEditingController();
  final _active = TextEditingController();
  final _deceased = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _fire = FirebaseFirestore.instance.collection('home').doc('stats');

  @override
  void initState() {
    _total.text = widget.stat.total.toString();
    _active.text = widget.stat.active.toString();
    _deceased.text = widget.stat.deceased.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CommonDialog(
        title: "Statistics tihdanglamna",
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _total,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: "Kai tawh zawng zawng",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(6.0),
                      borderSide: new BorderSide(color: Constants.primary),
                    ),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(6.0),
                      borderSide: new BorderSide(color: Constants.primary),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null) {
                      return 'Kai tawh zawng zawng ziah angai';
                    } else if (value.isEmpty) {
                      return 'Kai tawh zawng zawng ziah angai';
                    } else
                      return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _active,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: "Enkawl mek",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(6.0),
                      borderSide: new BorderSide(color: Constants.primary),
                    ),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(6.0),
                      borderSide: new BorderSide(color: Constants.primary),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null) {
                      return 'Enkawl mek zat ziah angai';
                    } else if (value.isEmpty) {
                      return 'Enkawl mek zat ziah angai';
                    } else
                      return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _deceased,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: "Boral pui tawh zat",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(6.0),
                      borderSide: new BorderSide(color: Constants.primary),
                    ),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(6.0),
                      borderSide: new BorderSide(color: Constants.primary),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null) {
                      return 'Boral pui tawh zat ziah angai';
                    } else if (value.isEmpty) {
                      return 'Boral pui tawh zat ziah angai';
                    } else
                      return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Constants.primary),
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      widget.stat.total = int.parse(_total.text);
                      widget.stat.active = int.parse(_active.text);
                      widget.stat.deceased = int.parse(_deceased.text);
                      _fire.update(widget.stat.toJson());
                      Get.back();
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
