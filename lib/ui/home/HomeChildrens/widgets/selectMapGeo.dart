import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectMapGeo extends StatefulWidget {
  final GeoPoint location;
  SelectMapGeo({required this.location});
  @override
  State<StatefulWidget> createState() => SelectMapGeoState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class SelectMapGeoState extends State<SelectMapGeo> {
  // SelectMapGeoState();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  GeoPoint? newLocation;
  bool permissionGranted = false;
  Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    newLocation = widget.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.9,
      height: Get.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: Colors.white,
            ),
            margin: EdgeInsets.all(8),
            width: Get.width * 0.9,
            height: Get.height * 0.6,
            child: GoogleMap(
              markers: Set<Marker>.of(_markers.values),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(widget.location.latitude, widget.location.longitude),
                zoom: 15.0,
              ),
              mapToolbarEnabled: false,
              myLocationEnabled: false,
              onCameraMove: (CameraPosition position) {
                if (_markers.length > 0) {
                  MarkerId markerId = MarkerId(_markerIdVal());
                  Marker? marker = _markers[markerId];
                  Marker updatedMarker = marker!.copyWith(
                    positionParam: position.target,
                  );
                  setState(() {
                    _markers[markerId] = updatedMarker;
                    newLocation = GeoPoint(
                        position.target.latitude, position.target.longitude);
                  });
                }
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Constants.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Hmun tihlan i duh awmna lai ah Pin hi dah rawh le",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            child: _buildDoneBtn(),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position =
        LatLng(widget.location.latitude, widget.location.longitude);
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

    Future.delayed(Duration(seconds: 1), () async {
      GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 17.0,
          ),
        ),
      );
    });
    setState(() {
      newLocation = GeoPoint(position.latitude, position.longitude);
    });
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  Widget _buildDoneBtn() {
    return ElevatedButton(
      onPressed: () {
        Get.back(result: newLocation);
      },
      style: ElevatedButton.styleFrom(
        primary: Constants.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Text(
          "Confirm",
          style: GoogleFonts.roboto(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
