// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_estate_admin/Modules/Project/propertyController.dart';
import 'package:real_estate_admin/Modules/Project/property_form_data.dart';

import 'Lead.dart';
import 'Project.dart';

enum ComissionType { percent, amount }

enum PropertyType { house, apartment, plot }

enum Unit {
  sqft,
}

class Property {
  String? docId;
  Project? parentProject;
  String? plotNumber;
  String? surveyNumber;
  String? dtcpNumber;
  String? district;
  String? taluk;
  String features;
  String? description;
  List<dynamic> photos;
  double propertyAmount;
  String? coverPhoto;
  String title;
  List<Lead> leads;

  ComissionType? comissionType;
  Commission? agentComission;
  Commission? superAgentComission;
  Commission? staffComission;

  Property({
    required this.title,
    required this.docId,
    this.plotNumber,
    this.surveyNumber,
    this.dtcpNumber,
    this.district,
    this.taluk,
    required this.features,
    this.description,
    this.coverPhoto,
    required this.photos,
    this.propertyAmount = 0,
    this.comissionType,
    this.agentComission,
    this.superAgentComission,
    this.staffComission,
    this.parentProject,
    required this.leads,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "docId": docId,
        "parentProject": parentProject?.toJson(),
        "plotNumber": plotNumber,
        "surveyNumber": surveyNumber,
        "dtcpNumber": dtcpNumber,
        "district": district,
        "taluk": taluk,
        "features": features,
        "description": description,
        "coverPhoto": coverPhoto,
        "photos": photos,
        "propertyAmount": propertyAmount,
        "comissionType": comissionType?.index,
        "agentComission": agentComission?.toJson(),
        "superAgentComission": superAgentComission?.toJson(),
        "staffComission": staffComission?.toJson(),
        "leads": leads.map((e) => e.toJson()).toList()
      };

  factory Property.fromSnapshot(DocumentSnapshot snapshot) {
    var json = snapshot.data() as Map<String, dynamic>;
    var unparsedLeads = json["leads"];
    List<Lead> leads = [];
    if (unparsedLeads is List && unparsedLeads.isNotEmpty) {
      leads = unparsedLeads.map((e) => Lead.fromJson(e)).toList();
    }
    return Property(
      title: json["title"],
      parentProject: json["parentProject"] != null ? Project.fromJson(json["parentProject"]) : null,
      docId: json["docId"],
      plotNumber: json["plotNumber"],
      surveyNumber: json["surveyNumber"],
      dtcpNumber: json["dtcpNumber"],
      district: json["district"],
      taluk: json["taluk"],
      features: json["features"],
      description: json["description"],
      coverPhoto: json["coverPhoto"],
      photos: json["photos"].map((e) => e as String).toList(),
      propertyAmount: json["propertyAmount"],
      comissionType: json["comissionType"] != null ? ComissionType.values.elementAt(json["comissionType"]) : null,
      agentComission: Commission.fromJson(json["agentComission"]),
      superAgentComission: Commission.fromJson(json["superAgentComission"]),
      staffComission: Commission.fromJson(json["staffComission"]),
      leads: leads,
    );
  }
}

class Commission {
  ComissionType comissionType;
  double value;

  Commission({
    this.comissionType = ComissionType.amount,
    this.value = 0.0,
  });

  static Commission? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Commission(comissionType: ComissionType.values.elementAt(json["comissionType"]), value: json["value"]);
  }

  Map<String, dynamic> toJson() {
    return {"comissionType": comissionType.index, "value": value};
  }
}
