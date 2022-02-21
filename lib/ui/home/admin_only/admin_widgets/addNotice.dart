import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/controllers/imageController.dart';
import 'package:durkhawpui/model/creator.dart';
import 'package:durkhawpui/model/ngo.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

import 'addMarkerName.dart';
import 'selectMapGeo.dart';

class AddNewNotice extends StatefulWidget {
  AddNewNotice({Key? key}) : super(key: key);

  @override
  _AddNewNoticeState createState() => _AddNewNoticeState();
}

class _AddNewNoticeState extends State<AddNewNotice> {
  final userCtrl = Get.find<UserController>();
  final _title = TextEditingController();
  final _fire = FirebaseFirestore.instance;
  List<String> ngoList = [];
  String? selectedNgo;
  String? _markerName;

  String description = "";

  PlatformFile? attachmentFile;
  int attachType = 0;
  bool notiOn = true;
  bool useMap = false;
  GeoPoint? geoPoint;
  /* 
  notice attachment types
  0=none
  1=image
  2=pdf
   */

  @override
  void initState() {
    super.initState();
    getNgos();
  }

  void getNgos() async {
    var result =
        await _fire.collection('ngos').orderBy('name', descending: true).get();
    var docs = result.docs;
    docs.forEach((element) {
      NgoModel model = NgoModel.fromJson(element.data(), element.id);
      ngoList.add(model.name);
    });
    setState(() {
      if (ngoList.isNotEmpty) selectedNgo = ngoList.first;
    });
  }

  void confirmPressed() async {
    if (description.length < 1) {
      Get.snackbar(
        'Error',
        "Sawifiahna(Description) ziah angai",
        backgroundColor: Colors.red,
      );
      return;
    }
    if (selectedNgo == null) {
      Get.snackbar(
        'Error',
        "Thu chhuahtu NGO thlan angai",
        backgroundColor: Colors.red,
      );
      return;
    }
    // _title
    if (_title.text.isEmpty) {
      Get.snackbar(
        'Error',
        "Thupui(Title) ziah angai",
        backgroundColor: Colors.red,
      );
      return;
    }
    //map check
    if (useMap && geoPoint == null) {
      Get.snackbar(
        'Error',
        "Map hman ala nilo",
        backgroundColor: Colors.red,
      );
      return;
    }
    String regular = description.replaceAll(new RegExp(r'(?:_|[^\w\s])+'), '');
    String excerpt = "";
    if (regular.length > 100) {
      excerpt = regular.substring(0, 100);
    } else {
      excerpt = regular;
    }
    if (attachmentFile == null) {
      Notice model = Notice(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        docId: '',
        ngo: selectedNgo!,
        likes: 0,
        commentCount: 0,
        viewCount: 0,
        title: _title.text,
        desc: description,
        markerName: _markerName,
        excerpt: excerpt,
        attachmentType: attachType,
        attachmentLink: null,
        createdBy: Creator(
          id: userCtrl.user.value.userId,
          name: userCtrl.user.value.name,
        ),
        useMap: useMap,
        geoPoint: geoPoint,
      );
      _fire.collection('posts').add(model.toJson());
      Get.back();
    } else {
      var ctrl = Get.find<ImageController>();
      var upStream = ctrl.uploadImage(attachmentFile!);
      Get.dialog(Center(
        child: CupertinoActivityIndicator(),
      ));
      upStream.listen((event) async {
        switch (event.state) {
          case TaskState.paused:
            break;
          case TaskState.running:
            Get.dialog(Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(),
              ),
            ));
            break;
          case TaskState.success:
            String? _url;
            if (attachmentFile != null) {
              _url = await event.ref.getDownloadURL();
              print(_url.toString());
            }
            Notice model = Notice(
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              docId: '',
              likes: 0,
              commentCount: 0,
              viewCount: 0,
              ngo: selectedNgo!,
              title: _title.text,
              markerName: _markerName,
              desc: description,
              excerpt: excerpt,
              attachmentType: attachType,
              attachmentLink: _url,
              createdBy: Creator(
                id: userCtrl.user.value.userId,
                name: userCtrl.user.value.name,
              ),
              useMap: useMap,
              geoPoint: geoPoint,
            );
            _fire.collection('posts').add(model.toJson());
            Get.back();
            Get.back();
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thuchhuah thar siamna"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Align(alignment: Alignment.centerLeft, child: Text('Title')),
              SizedBox(
                height: 5,
              ),
              _buildTitleInput(),
              SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.centerLeft, child: Text('Description')),
              SizedBox(
                height: 5,
              ),
              _buildDescriptionInput(),
              _buildPreviewBtn(),
              SizedBox(
                height: 10,
              ),
              _selectNgo(),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Notification "),
                  Spacer(),
                  //TODO notification thawn ngai
                  Switch(
                      value: notiOn,
                      onChanged: (newValue) {
                        setState(() {
                          notiOn = newValue;
                        });
                      })
                ],
              ),
              Row(
                children: [
                  Text("Map a tarlan"),
                  Spacer(),
                  Switch(
                    value: useMap,
                    onChanged: (newValue) async {
                      if (newValue) {
                        var result = await Get.dialog(
                          Center(
                            child: SelectMapGeo(
                              location: GeoPoint(23.7801, 92.7278),
                            ),
                          ),
                        );
                        if (result != null) {
                          var markerName = await Get.dialog(AddMarkerName());
                          if (markerName != null) {
                            setState(() {
                              _markerName = markerName;
                              useMap = newValue;
                              geoPoint = result;
                            });
                          } else {
                            setState(() {
                              _markerName = null;
                              useMap = false;
                              geoPoint = null;
                            });
                          }
                        }
                      } else {
                        setState(() {
                          _markerName = null;
                          useMap = false;
                          geoPoint = null;
                        });
                      }
                    },
                  ),
                ],
              ),
              _selectAttachment(),
              _buildConfirmBtn(),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectAttachment() {
    return Row(
      children: [
        Text("Attachment: "),
        if (attachmentFile != null)
          Expanded(child: Text(attachmentFile!.name.toString())),
        if (attachmentFile == null) Spacer(),
        IconButton(
          onPressed: () async {
            var ctrl = Get.find<ImageController>();
            PlatformFile? imgFile = await ctrl.selectImage();
            if (imgFile == null) return;
            File _file = File(imgFile.path!);
            if (imgFile.extension != "pdf") {
              var confirmed = await Get.dialog(
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.grey[500],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: new BoxConstraints(
                              maxHeight: Get.height * 0.7,
                            ),
                            child: Image.file(_file),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                    return null;
                                  },
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    attachType = 1;
                                    Get.back(result: true);
                                  },
                                  icon: Icon(
                                    Icons.done_rounded,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
              if (confirmed != null && confirmed) {
                setState(() {
                  attachmentFile = imgFile;
                });
              }
            } else {
              setState(() {
                attachType = 2;
                attachmentFile = imgFile;
              });
            }
          },
          icon: Icon(
            Icons.attachment_rounded,
          ),
        )
      ],
    );
  }

  Widget _buildConfirmBtn() {
    return ElevatedButton(
      onPressed: confirmPressed,
      style: ElevatedButton.styleFrom(
        primary: Constants.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Confirm"),
        ],
      ),
    );
  }

  Widget _selectNgo() {
    return Row(
      children: [
        Text('Chhuahtu NGO'),
        Spacer(),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: Colors.white,
              value: selectedNgo,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white,
              items: ngoList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.start,
                  ),
                );
              }).toList(),
              hint: Text(
                "Thlan a ngai",
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedNgo = value;
                  });
                }
              },
            ),
          ),
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }

  Widget _buildPreviewBtn() {
    return TextButton(
      onPressed: () {
        if (description.length < 1) {
          return;
        }
        Get.dialog(Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Theme.of(context).backgroundColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MarkdownBody(
                    data: description,
                    shrinkWrap: true,
                    fitContent: true,
                  ),
                ],
              ),
            ),
          ),
        ));
      },
      child: Text("Check Preview"),
    );
  }

  Widget _buildDescriptionInput() {
    return MarkdownTextInput(
      (String value) {
        setState(() {
          description = value;
        });
      },
      description,
      label: 'Description',
      maxLines: 5,
    );
  }

  Widget _buildTitleInput() {
    return TextFormField(
      controller: _title,
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(
        hintText: "A thupui tawi fel takin",
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide:
              new BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide:
              new BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        //fillColor: Colors.green
      ),
      validator: (val) {
        if (val?.length == 0) {
          return "Thupui ziah a ngai";
        } else {
          return null;
        }
      },
    );
  }
}
