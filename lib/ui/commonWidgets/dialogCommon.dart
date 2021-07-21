import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final Widget body;
  CommonDialog({Key? key, required this.body, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
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
                child: Text(title),
              ),
            ),
            body
          ],
        ),
      ),
    );
  }
}
