import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/controllers/imageController.dart';
import 'package:durkhawpui/model/creator.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNewNotice extends StatefulWidget {
  AddNewNotice({Key? key}) : super(key: key);

  @override
  _AddNewNoticeState createState() => _AddNewNoticeState();
}

class _AddNewNoticeState extends State<AddNewNotice> {
  final userCtrl = Get.find<UserController>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _fire = FirebaseFirestore.instance;

  PlatformFile? attachmentFile;
  int attachType = 0;
  bool notiOn = true;
  /* 
  notice attachment types
  0=none
  1=image
  2=pdf
   */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thuchhuah thar siamna"),
        centerTitle: true,
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _title,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  labelText: "Title",
                  hintText: "A thupui tawi fel takin",
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
                    return "Thupui ziah a ngai";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _description,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(),
                  hintText: "A sawi zau na",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(color: Constants.primary),
                  ),
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(color: Constants.primary),
                  ),
                ),
                maxLines: 5,
                validator: (val) {
                  if (val?.length == 0) {
                    return "Sawi zauna ziah a ngai";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Notification "),
                  Spacer(),
                  Switch(
                      value: notiOn,
                      onChanged: (newValue) {
                        setState(() {
                          notiOn = newValue;
                        });
                      })
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Attachment:"),
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
                                margin: EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 15),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
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
                          attachmentFile = imgFile;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.attachment_rounded,
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (!_form.currentState!.validate()) {
                    return null;
                  }
                  if (attachmentFile == null) {
                    String desc = _description.text;
                    String excerpt = desc.substring(0, 30);
                    Notice model = Notice(
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      docId: '',
                      title: _title.text,
                      desc: _description.text,
                      excerpt: excerpt,
                      attachmentType: attachType,
                      attachmentLink: null,
                      createdBy: Creator(
                          id: userCtrl.user.value.userId,
                          name: userCtrl.user.value.name),
                    );
                    _fire.collection('posts').add(model.toJson());
                    Get.back();
                  }
                  var ctrl = Get.find<ImageController>();
                  var upStream = ctrl.uploadImage(attachmentFile!);
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
                        }
                        String desc = _description.text;
                        String excerpt = desc.substring(0, 30);
                        Notice model = Notice(
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          docId: '',
                          title: _title.text,
                          desc: _description.text,
                          excerpt: excerpt,
                          attachmentType: attachType,
                          attachmentLink: _url,
                          createdBy: Creator(
                              id: userCtrl.user.value.userId,
                              name: userCtrl.user.value.name),
                        );
                        _fire.collection('posts').add(model.toJson());
                        Get.back();
                        break;
                      case TaskState.canceled:
                        break;
                      case TaskState.error:
                        break;
                    }
                  });
                  Get.back();
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
    );
  }

  // String _formatDate(DateTime date) {
  //   var _new = DateFormat("dd-MMMM-yy").format(date);
  //   return _new;
  // }
}
