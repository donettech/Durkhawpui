import 'package:durkhawpui/model/quarantine.dart';
import 'package:durkhawpui/ui/commonWidgets/markerMap.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class QuarantineDetailDialog extends StatefulWidget {
  final Quarantine model;
  QuarantineDetailDialog({Key? key, required this.model}) : super(key: key);

  @override
  _QuarantineDetailDialogState createState() => _QuarantineDetailDialogState();
}

class _QuarantineDetailDialogState extends State<QuarantineDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
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
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.model.name,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.cancel_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: Get.width - 30,
                height: Get.width - 30,
                child: MarkerMap(
                  height: Get.width - 30,
                  address: widget.model.name +
                      ", " +
                      widget.model.ymaSection +
                      ", " +
                      widget.model.veng,
                  point: widget.model.location,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
