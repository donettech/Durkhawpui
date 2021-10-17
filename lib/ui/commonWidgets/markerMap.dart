import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerMap extends StatefulWidget {
  final GeoPoint point;
  final double height;
  final String? address;
  const MarkerMap(
      {Key? key, this.address, required this.point, required this.height})
      : super(key: key);

  @override
  _MarkerMapState createState() => _MarkerMapState();
}

class _MarkerMapState extends State<MarkerMap> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.point.latitude,
            widget.point.longitude,
          ),
          zoom: 18,
        ),
        markers: Set<Marker>.of(_markers.values),
        onMapCreated: _onMapCreated,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    MarkerId markerId = MarkerId("UniqueId");
    mapController = controller;
    LatLng position = LatLng(widget.point.latitude, widget.point.longitude);
    Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
        onTap: () {
          final Marker? tappedMarker = _markers[markerId];
          if (tappedMarker != null) {
            setState(() {
              final MarkerId? previousMarkerId = selectedMarker;
              if (previousMarkerId != null &&
                  _markers.containsKey(previousMarkerId)) {
                final Marker resetOld = _markers[previousMarkerId]!
                    .copyWith(iconParam: BitmapDescriptor.defaultMarker);
                _markers[previousMarkerId] = resetOld;
              }
              selectedMarker = markerId;
              final Marker newMarker = tappedMarker.copyWith(
                iconParam: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
              );
              _markers[markerId] = newMarker;
            });
          }
        },
        infoWindow: InfoWindow(
          title: widget.address == null ? "" : widget.address,
          // snippet: widget.address == null ? "" : widget.address,
        ),
        onDragEnd: (value) {
          print("New position " + value.toString());
        });
    setState(() {
      _markers[markerId] = marker;
    });
    Future.delayed(Duration(seconds: 1)).then((value) {
      setState(() {
        if (mapController != null && widget.address != null) {
          mapController!.showMarkerInfoWindow(markerId);
        }
      });
    });
  }
}
