import 'package:durkhawpui/model/quarantine.dart';
import 'package:durkhawpui/ui/commonWidgets/markerMap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class QuarantineDetails extends StatefulWidget {
  final Quarantine model;
  QuarantineDetails({Key? key, required this.model}) : super(key: key);

  @override
  _QuarantineDetailsState createState() => _QuarantineDetailsState();
}

class _QuarantineDetailsState extends State<QuarantineDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  _formatDate(widget.model.quarantineFrom),
                  style: Theme.of(context).textTheme.headline6,
                ),
                Spacer(),
                Text(
                  "atanga",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Spacer(),
                Text(
                  _formatDate(widget.model.quarantineTo),
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: MarkerMap(
                height: 250,
                point: widget.model.location,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.28,
                        child: Text(
                          "Hming: ",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.model.name,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.model.ymaSection + ", " + widget.model.veng,
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.28,
                        child: Text(
                          "Contact tu: ",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.model.contactor,
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    var _new = DateFormat("dd-MMMM-yy").format(date);
    return _new;
  }
}
