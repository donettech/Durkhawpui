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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType:
                    enterNumber ? TextInputType.phone : TextInputType.text,
              ),
              SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: onConfirm,
                child: Text("Confirm"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
