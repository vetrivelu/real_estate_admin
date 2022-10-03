import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../Model/Property.dart';
import 'package:image_picker_web/image_picker_web.dart';

enum Provide { network, memory, logo }

class PropertyViewModel extends ChangeNotifier {
  String? docId;
  final title = TextEditingController();
  final plotNumber = TextEditingController();
  final surveyNumber = TextEditingController();
  final dtcpNumber = TextEditingController();
  final district = TextEditingController();
  final taluk = TextEditingController();
  final features = TextEditingController();
  final description = TextEditingController();
  final propertyAmount = TextEditingController();
  var agentComission = Commission();
  var superAgentComission = Commission();
  var staffComission = Commission();

  ComissionType comissionType = ComissionType.amount;

  List<dynamic> photos = [];
  List<dynamic> deletedPhotos = [];
  String? coverPhoto;

  Uint8List? coverPhototData;
  List<Uint8List> photosData = [];
  Provide show = Provide.logo;

  PropertyViewModel({this.docId});

  Future<void> pickImages() async {
    var files = await ImagePickerWeb.getMultiImagesAsBytes();
    if ((files ?? []).isNotEmpty) {
      photosData.addAll(files!);
    }
    notifyListeners();
    return;
  }

  Future<void> pickCoverPhoto() async {
    var mediaInfo = await ImagePickerWeb.getImageInfo;
    if (mediaInfo!.data != null && mediaInfo.fileName != null) {
      coverPhototData = mediaInfo.data;
      show = Provide.memory;
      notifyListeners();
    }
    return;
  }

  List<PhotoTile> getPhotoTiles() {
    List<PhotoTile> tiles = [];
    tiles.addAll(photos.map((e) => PhotoTile(e, null, () {
          deletedPhotos.add(e);
          photos.remove(e);
          notifyListeners();
        })));
    tiles.addAll(photosData.map((e) => PhotoTile(null, e, () {
          photosData.remove(e);
          notifyListeners();
        })));
    return tiles;
  }

  Property get property => Property(
        title: title.text,
        docId: docId,
        plotNumber: plotNumber.text,
        surveyNumber: surveyNumber.text,
        dtcpNumber: dtcpNumber.text,
        district: district.text,
        taluk: taluk.text,
        features: features.text,
        description: description.text,
        coverPhoto: coverPhoto,
        photos: photos,
        propertyAmount: double.tryParse(propertyAmount.text) ?? 0,
        comissionType: comissionType,
        agentComission: agentComission,
        superAgentComission: superAgentComission,
        staffComission: staffComission,
        leads: [],
      );

  factory PropertyViewModel.fromProperty(Property property) {
    var propertyViewModel = PropertyViewModel(docId: property.docId);
    propertyViewModel.title.text = property.title;
    propertyViewModel.plotNumber.text = property.plotNumber ?? '';
    propertyViewModel.surveyNumber.text = property.surveyNumber ?? '';
    propertyViewModel.dtcpNumber.text = property.dtcpNumber ?? '';
    propertyViewModel.district.text = property.district ?? '';
    propertyViewModel.taluk.text = property.taluk ?? '';
    propertyViewModel.features.text = property.features ?? '';
    propertyViewModel.description.text = property.description ?? '';
    propertyViewModel.coverPhoto = property.coverPhoto ?? '';
    propertyViewModel.photos = property.photos;
    propertyViewModel.propertyAmount.text = property.propertyAmount.toString();
    propertyViewModel.comissionType = property.comissionType ?? ComissionType.amount;
    propertyViewModel.agentComission = property.agentComission ?? Commission();
    propertyViewModel.superAgentComission = property.superAgentComission ?? Commission();
    propertyViewModel.staffComission = property.staffComission ?? Commission();
    return propertyViewModel;
  }
}

class PhotoTile {
  final String? url;
  final Uint8List? rawData;
  final void Function() remove;

  PhotoTile(this.url, this.rawData, this.remove);

  ImageProvider get provider {
    ImageProvider provider;
    if (rawData != null) {
      provider = MemoryImage(rawData!);
    } else {
      provider = NetworkImage(url!);
    }
    return provider;
  }
}
