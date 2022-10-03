import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/Model/Result.dart';
import 'package:real_estate_admin/Modules/Project/project_form_data.dart';
import 'package:real_estate_admin/Modules/Project/propertyController.dart';
import 'package:real_estate_admin/Modules/Project/property_form_data.dart';

class ProjectController extends ChangeNotifier {
  ProjectController(this.projectFormData);

  final ProjectFormData projectFormData;
  final CollectionReference<Map<String, dynamic>> projects = FirebaseFirestore.instance.collection('projects');
  DocumentReference? get currentProject => projectFormData.docId == null ? null : projects.doc(projectFormData.docId);
  String get newDocID => projects.doc().id;
  Reference get projectStorageRef => FirebaseStorage.instance.ref().child(projectFormData.docId!);
  var storage = FirebaseStorage.instance;

  Future<String> uploadFile(Uint8List file, String name) async {
    var ref = projectStorageRef.child(name);
    var url = await ref.putData(file).then((p0) => p0.ref.getDownloadURL()).catchError((error) {
      print(error.toString());
    });
    return url;
  }

  Future<Result> addProject() async {
    projectFormData.docId = newDocID;
    if (projectFormData.coverPhototData != null) {
      projectFormData.coverPhoto = await uploadFile(projectFormData.coverPhototData!, "coverPhoto.jpg");
    }
    var project = projectFormData.object;
    return projects
        .doc(project.docId)
        .set(project.toJson())
        .then((value) => Result(tilte: Result.success, message: "Project Added Successfully"))
        .onError((error, stackTrace) => Result(tilte: Result.failure, message: 'Project Addition Failed.\n ${error.toString()}'));
  }

  Future<Result> updateProject() async {
    if (projectFormData.coverPhototData != null) {
      projectFormData.coverPhoto = await uploadFile(projectFormData.coverPhototData!, "coverPhoto");
    }
    if (projectFormData.deletedPhotos.isNotEmpty) {
      try {
        for (var element in projectFormData.deletedPhotos) {
          storage.refFromURL(element).delete();
        }
      } catch (e) {
        print(e.toString());
      }
    }
    var project = projectFormData.object;
    return projects
        .doc(project.docId)
        .update(project.toJson())
        .then((value) => Result(tilte: Result.success, message: "Project Added Successfully"))
        .onError((error, stackTrace) {
      print(error.toString());
      return Result(tilte: Result.failure, message: 'Project Addition Failed.\n ${error.toString()}');
    });
  }

  Future<Result> deleteProject() async {
    if ((projectFormData.coverPhoto ?? '').isNotEmpty) {
      storage.refFromURL(projectFormData.coverPhoto!).delete();
    }
    await projects.doc(projectFormData.docId).collection('properties').get().then((snapshot) {
      var thisProperties = snapshot.docs.map((e) => Property.fromSnapshot(e));
      for (var property in thisProperties) {
        var propertyFormData = PropertyViewModel.fromProperty(property);
        var controller = PropertyController(propertyFormData: propertyFormData, project: projectFormData.object);
        controller.deleteProperty();
      }
    });
    return projects
        .doc(projectFormData.docId)
        .delete()
        .then((value) => Result(tilte: Result.success, message: "Project Deleted Successfully"))
        .onError((error, stackTrace) => Result(tilte: Result.failure, message: 'Project Deletion Failed.\n ${error.toString()}'));
  }

  Stream<List<Property>> getPropertiesAsStream() {
    return currentProject!.collection('properties').snapshots().map((event) {
      return event.docs.map((e) => Property.fromSnapshot(e)).toList();
    });
  }
}
