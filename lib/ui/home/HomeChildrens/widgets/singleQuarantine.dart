import 'package:durkhawpui/model/quarantine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class QuarantineDetails extends StatefulWidget {
  final Quarantine model;
  QuarantineDetails({Key? key, required this.model}) : super(key: key);

  @override
  _QuarantineDetailsState createState() => _QuarantineDetailsState();
}

class _QuarantineDetailsState extends State<QuarantineDetails> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
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
              // height: Get.height * 0.5,
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.model.location.latitude,
                    widget.model.location.longitude,
                  ),
                  zoom: 18,
                ),
                markers: Set<Marker>.of(_markers.values),
                onMapCreated: _onMapCreated,
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

  void _onMapCreated(GoogleMapController controller) async {
    MarkerId markerId = MarkerId("UniqueId");
    LatLng position =
        LatLng(widget.model.location.latitude, widget.model.location.longitude);
    Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
        onDragEnd: (value) {
          print("New position " + value.toString());
        });
    setState(() {
      _markers[markerId] = marker;
    });

    // Future.delayed(Duration(seconds: 1), () async {
    //   GoogleMapController controller = await _mapController.future;
    //   controller.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(
    //         target: position,
    //         zoom: 17.0,
    //       ),
    //     ),
    //   );
    // });
  }

  String _formatDate(DateTime date) {
    var _new = DateFormat("dd-MMMM-yy").format(date);
    return _new;
  }
}
