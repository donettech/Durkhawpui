import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class ImageController extends GetxController {
  final storage.Reference storageRef = storage.FirebaseStorage.instance.ref();

  void handleNoticeAttachment(
      {required Function(storage.Reference ref) onDone}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowCompression: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null) {
      print(result.toString());
      PlatformFile file = result.files.first;
      if (file.extension == "jpg" ||
          file.extension == "png" ||
          file.extension == "jpeg") {
        Get.dialog(
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
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
                      child: Image.file(
                        io.File(file.path!),
                      ),
                    ),
                    StreamBuilder(
                        stream: uploadImage(file),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            storage.TaskSnapshot task =
                                snap.data as storage.TaskSnapshot;
                            print(task.toString());
                            switch (task.state) {
                              case storage.TaskState.paused:
                                break;
                              case storage.TaskState.running:
                                return LinearProgressIndicator();
                              case storage.TaskState.success:
                                Get.snackbar("Success", "Upload completed");
                                var _reference = task.ref;
                                return Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          Get.back();
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
                                          onDone(_reference);
                                          Get.back();
                                        },
                                        icon: Icon(
                                          Icons.done_rounded,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              case storage.TaskState.canceled:
                                break;
                              case storage.TaskState.error:
                                break;
                            }
                          }
                          return SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (file.extension == "pdf") {
        Get.dialog(Center(child: Material(child: Text("PDF"))));
      } else {
        Get.snackbar('Error', "Pdf,jpg,jpeg emaw png file choh a thlan theih");
      }
    }
  }

  Future<PlatformFile?> selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowCompression: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null) {
      if (result.files.length > 1) {
        Get.snackbar(
          "Error",
          "File pakhat choh thlan phal ani",
          backgroundColor: Colors.red,
        );
        return null;
      }
      if (result.files.first.extension == "jpg" ||
          result.files.first.extension == "jpeg" ||
          result.files.first.extension == "png" ||
          result.files.first.extension == "pdf") {
        return result.files.first;
      }
      Get.snackbar(
        "Error",
        "Thlalak/PDF chiah a thlan theih (pdf/jpg/jpeg/png extensions only)",
        backgroundColor: Colors.red,
      );
      return null;
    } else
      return null;
  }

  Stream<storage.TaskSnapshot> uploadImage(PlatformFile file) {
    storage.UploadTask uploadTask;
    var ext = file.extension;
    late String _contentType;
    if (ext == "pdf") {
      _contentType = "file/pdf";
    } else {
      _contentType = "image/jpeg";
    }
    var fileName =
        DateTime.now().millisecondsSinceEpoch.toString() + "." + ext!;
    storage.Reference ref = storage.FirebaseStorage.instance
        .ref()
        .child('Posts')
        .child('/$fileName');
    io.File _newFile = io.File(file.path!);
    final metadata = storage.SettableMetadata(
        contentType: _contentType,
        customMetadata: {'picked-file-path': _newFile.path});
    uploadTask = ref.putFile(io.File(_newFile.path), metadata);
    return uploadTask.asStream();
  }
}
