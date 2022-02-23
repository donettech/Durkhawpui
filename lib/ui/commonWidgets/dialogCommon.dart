import 'package:flutter/material.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final Widget body;
  CommonDialog({Key? key, required this.body, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(title),
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
              body
            ],
          ),
        ),
      ),
    );
  }
}
