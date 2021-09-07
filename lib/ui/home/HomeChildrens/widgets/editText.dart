import 'package:flutter/material.dart';

class EditTextDialog extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onConfirm;
  final bool enterNumber;
  EditTextDialog(
      {Key? key,
      required this.controller,
      required this.enterNumber,
      required this.onConfirm})
      : super(key: key);

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.grey[700],
          ),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: controller,
                  autofocus: true,
                  keyboardType:
                      enterNumber ? TextInputType.phone : TextInputType.text,
                  validator: (value) {
                    if (enterNumber) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length == 10) {
                        return null;
                      }
                      return "Number digit 10 chhut luh angai";
                    } else {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length > 2) {
                        return null;
                      }
                      return "Hming hawrawp 2 aia tlem lo chhut angai";
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      onConfirm!();
                    }
                  },
                  child: Text("Confirm"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
