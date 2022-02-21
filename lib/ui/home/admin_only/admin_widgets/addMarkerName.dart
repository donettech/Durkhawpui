import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMarkerName extends StatelessWidget {
  AddMarkerName({Key? key}) : super(key: key);
  final _text = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            color: Colors.grey[800],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  color: Constants.primary,
                ),
                child: Center(
                    child: Text("Marker hming ziak rawh (e.g Mitthi in)")),
              ),
              Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    controller: _text,
                    autofocus: true,
                    validator: (value) {
                      if (value == null) return "Marker hming ziah angai";
                      if (value.length < 3)
                        return "Marker hming letter 3 aiin a tlem";
                      else
                        return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Constants.primary,
                ),
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    Get.back(result: _text.text);
                  }
                },
                child: Text("Confirm"),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
