import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/Model/Result.dart';
import 'package:real_estate_admin/Model/Staff.dart';
import 'Agent.dart';

enum LeadStatus { lead, pendingApproval, sold }

class Lead {
  String name;
  String? phoneNumber;
  String? address;
  String? email;
  String? governmentId;
  DateTime enquiryDate;
  LeadStatus leadStatus;
  double? sellingAmount;
  DocumentReference? staffRef;
  Commission? staffComission;
  DocumentReference? agentRef;
  Commission? agentComission;

  Commission? superAgentComission;

  DocumentReference reference;

  DocumentReference get propertyRef => FirebaseFirestore.instance.doc(reference.path.split('/leads').first);

  Agent? agent;
  Staff? staff;

  Lead({
    this.sellingAmount,
    this.staffComission,
    this.agentComission,
    this.superAgentComission,
    required this.name,
    this.phoneNumber,
    this.address,
    this.email,
    required this.enquiryDate,
    this.agentRef,
    this.staff,
    this.staffRef,
    this.agent,
    this.governmentId,
    required this.reference,
    this.leadStatus = LeadStatus.lead,
  });

  void assignStaff(DocumentReference staffRefence) async {
    staff = await staffRefence.get().then((value) => Staff.fromSnapshot(value));
    staffRef = staffRefence;
    reference.update(toJson());
  }

  toJson() => {
        "name": name,
        "phoneNumber": phoneNumber,
        "address": address,
        "email": email,
        "enquiryDate": enquiryDate,
        "agentRef": agentRef,
        "staffRef": staffRef,
        "agent": agent?.toJson(),
        "staff": staff?.toJson(),
        "governmentId": governmentId,
        "reference": reference,
        "leadStatus": leadStatus.index,
      };
  factory Lead.fromJson(json, DocumentReference reference) {
    return Lead(
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      address: json["address"],
      email: json["email"],
      enquiryDate: json["enquiryDate"].toDate(),
      governmentId: json['governmentId'],
      agentRef: json["agentRef"],
      staffRef: json["staffRef"],
      reference: reference,
      leadStatus: LeadStatus.values.elementAt(json["leadStatus"]),
      agent: json["agent"] != null ? Agent.fromJson(json["agent"]) : null,
      staff: json["staff"] != null ? Staff.fromJson(json["staff"]) : null,
    );
  }
  factory Lead.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> json = snapshot.data()!;
    return Lead(
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      address: json["address"],
      email: json["email"],
      enquiryDate: json["enquiryDate"].toDate(),
      governmentId: json['governmentId'],
      agentRef: json["agentRef"],
      staffRef: json["staffRef"],
      reference: snapshot.reference,
      leadStatus: LeadStatus.values.elementAt(json["leadStatus"]),
      // agent: json["agent"] != null ? Agent.fromJson(json["agent"]) : null,
      // staff: json["staff"] != null ? Staff.fromJson(json["staff"]) : null,
    );
  }

  double get staffComissionAmount {
    if (staffComission != null && sellingAmount != null) {
      if (staffComission!.comissionType == ComissionType.percent) {
        return sellingAmount! * staffComission!.value / 100;
      } else {
        return staffComission!.value;
      }
    } else {
      return 0.0;
    }
  }

  double get agentComissionAmount {
    if (staffComission != null && sellingAmount != null) {
      if (agentComission!.comissionType == ComissionType.percent) {
        return sellingAmount! * agentComission!.value / 100;
      } else {
        return agentComission!.value;
      }
    } else {
      return 0.0;
    }
  }

  double get superAgentComissionAmount {
    if (staffComission != null && sellingAmount != null) {
      if (superAgentComission!.comissionType == ComissionType.percent) {
        return sellingAmount! * superAgentComission!.value / 100;
      } else {
        return superAgentComission!.value;
      }
    } else {
      return 0.0;
    }
  }

  static Stream<List<Lead>> getLeads() {
    return FirebaseFirestore.instance.collectionGroup('leads').snapshots().map((event) {
      return event.docs.map((e) => Lead.fromSnapshot(e)).toList();
    });
  }

  static Stream<List<Lead>> getSales({Agent? agent, Staff? staff}) {
    return FirebaseFirestore.instance.collectionGroup('leads').where('leadStatus', isNotEqualTo: LeadStatus.lead.index).snapshots().map((event) {
      return event.docs.map((e) => Lead.fromSnapshot(e)).toList();
    });
  }

  Future<Result> convertToSale({
    required double sellingAmount,
    required Commission staffComission,
    required Commission agentComission,
    required Commission superAgentComission,
  }) async {
    this.sellingAmount = sellingAmount;
    this.staffComission = staffComission;
    this.agentComission = agentComission;
    this.superAgentComission = superAgentComission;

    await agent?.loadRefrences();

    return propertyRef.get().then((value) {
      if (value.exists) {
        var property = Property.fromSnapshot(value);
        if (property.isSold) {
          return Result(tilte: Result.failure, message: "The Property has been already sold");
        } else {
          return FirebaseFirestore.instance
              .runTransaction((transaction) async {
                transaction.update(reference, toJson());
                transaction.update(propertyRef, {'isSold': true});
                if (staffRef != null) {
                  transaction.update(staffRef!, {'commissionAmount': FieldValue.increment(staffComissionAmount)});
                }
                if (agent?.reference != null) {
                  transaction.update(agent!.reference, {
                    'commissionAmount': FieldValue.increment(agentComissionAmount),
                    'sharedComissionAmount': FieldValue.increment(superAgentComissionAmount),
                  });
                }
                if (agent?.superAgentReference != null) {
                  transaction.update(agent!.superAgentReference!, {'commissionAmount': FieldValue.increment(superAgentComissionAmount)});
                }
                return transaction;
              })
              .then((value) => Result(tilte: Result.success, message: "The property is now marked as sold"))
              .onError((error, stackTrace) => Result(tilte: Result.failure, message: error.toString()));
        }
      } else {
        return Result(tilte: Result.failure, message: "Error occured, Could not load property");
      }
    });
  }
}
