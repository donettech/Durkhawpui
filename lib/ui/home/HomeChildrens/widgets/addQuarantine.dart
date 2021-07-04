import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/creator.dart';
import 'package:durkhawpui/model/quarantine.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddQuarantineDialog extends StatefulWidget {
  AddQuarantineDialog({Key? key}) : super(key: key);

  @override
  _AddQuarantineDialogState createState() => _AddQuarantineDialogState();
}

class _AddQuarantineDialogState extends State<AddQuarantineDialog> {
  final userCtrl = Get.find<UserController>();
  final _name = TextEditingController();
  final _contactor = TextEditingController();
  final _form = GlobalKey<FormState>();
  late DateTime _quarantineFrom;
  late DateTime _quarantineTo;
  Completer<GoogleMapController> _mapController = Completer();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  String _chosenSection = "Section A";
  String _chosenVeng = "Zion Veng";
  GeoPoint newLocation =
      GeoPoint(23.7779, 92.7307); // Durtlang geopoint manual a dah ani

  List<String> ymaSections = [
    "Section A",
    "Section B",
    "Section C",
    "Section D",
    "Section E",
    "Section F"
  ];
  List<String> vengList = [
    "Zion Veng",
    "Mel-5",
    "Mel-5 kawngthlang",
    "Venglai",
    "Dawrkawn",
    "Dawrkawn tlang",
    "Mualveng",
    "M.Suaka veng",
  ];

  @override
  void initState() {
    super.initState();
    _quarantineFrom = DateTime.now();
    _quarantineTo = DateTime.now().add(Duration(days: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quarantine thar dah belhna"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    labelText: "Hming",
                    hintText: "Quarantine tur hming/chhungkaw pa hming",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(color: Constants.primary),
                    ),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(color: Constants.primary),
                    ),
                    //fillColor: Colors.green
                  ),
                  validator: (val) {
                    if (val?.length == 0) {
                      return "Hming chhut a ngai";
                    } else {
                      return null;
                    }
                  },
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        focusColor: Colors.white,
                        value: _chosenVeng,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.white,
                        items: vengList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.start,
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Veng thlan a ngai",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _chosenVeng = value;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        focusColor: Colors.white,
                        value: _chosenSection,
                        //elevation: 5,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.white,
                        items: ymaSections
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.start,
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Section thlan a ngai",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _chosenSection = value;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _contactor,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    labelText: "Contact tu",
                    hintText: "Contact tu hming/Kai rinhlelhna",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(color: Constants.primary),
                    ),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(color: Constants.primary),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Quarantine Tan ni"),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.date_range_outlined,
                            ),
                          ),
                          Text(
                            _formatDate(_quarantineFrom),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Quarantine tawp ni"),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.date_range_outlined,
                            ),
                          ),
                          Text(
                            _formatDate(_quarantineTo),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "An in awmna map ah hian thlan tur ani e",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width,
                  height: Get.width,
                  child: GoogleMap(
                    markers: Set<Marker>.of(_markers.values),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        23.7779,
                        92.7307,
                      ),
                      zoom: 16.0,
                    ),
                    onMapCreated: _onMapCreated,
                    buildingsEnabled: true,
                    mapType: MapType.satellite,
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
                          newLocation = GeoPoint(position.target.latitude,
                              position.target.longitude);
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Quaratine temp = Quaratine(
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      quarantineFrom: _quarantineFrom,
                      quarantineTo: _quarantineTo,
                      docId: '',
                      name: _name.text,
                      ymaSection: _chosenSection,
                      veng: _chosenVeng,
                      contactor: _contactor.text,
                      location: newLocation,
                      createdBy: Creator(
                        id: userCtrl.user.value.userId,
                        name: userCtrl.user.value.name,
                      ),
                    );
                    FirebaseFirestore.instance
                        .collection('quarantines')
                        .add(temp.toJson())
                        .then((value) {
                      Get.back();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Constants.primary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Confirm"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = LatLng(23.7779, 92.7307);
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

  String _formatDate(DateTime date) {
    var _new = DateFormat("dd-MMMM-yy").format(date);
    return _new;
  }
}
