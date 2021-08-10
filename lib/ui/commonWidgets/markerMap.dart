import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerMap extends StatefulWidget {
  final GeoPoint point;
  final double height;
  const MarkerMap({Key? key, required this.point, required this.height})
      : super(key: key);

  @override
  _MarkerMapState createState() => _MarkerMapState();
}

class _MarkerMapState extends State<MarkerMap> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

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
    LatLng position = LatLng(widget.point.latitude, widget.point.longitude);
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
  }
}
