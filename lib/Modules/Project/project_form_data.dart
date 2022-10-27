import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../Model/Project.dart';

class ProjectFormData extends ChangeNotifier {
  ProjectFormData();

  final TextEditingController name = TextEditingController();
  String type = 'House';
  final TextEditingController location = TextEditingController();

  String? docId;
  String? coverPhoto;

  List<String> deletedPhotos = [];

  Uint8List? coverPhototData;
  Future<void> pickCoverPhoto() async {
    var mediaInfo = await ImagePickerWeb.getImageInfo;
    if (mediaInfo!.data != null && mediaInfo.fileName != null) {
      coverPhototData = mediaInfo.data;
    }
    notifyListeners();
    return;
  }

  void onChanged(String? val) {
    type = val ?? type;
    notifyListeners();
  }

  factory ProjectFormData.fromProject(Project project) {
    var fromData = ProjectFormData();
    fromData.docId = project.docId;
    fromData.name.text = project.name;
    fromData.location.text = project.location;
    fromData.type = project.type;
    fromData.coverPhoto = project.coverPhoto;
    return fromData;
  }

  Project get object => Project(name: name.text, type: type, location: location.text, coverPhoto: coverPhoto, docId: docId);

  void removeCoverPhoto() {
    if ((coverPhoto ?? '').isNotEmpty) {
      deletedPhotos.add(coverPhoto!);
    }
    coverPhoto = null;
    coverPhototData = null;
    notifyListeners();
  }
}
