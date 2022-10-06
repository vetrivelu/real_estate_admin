import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_estate_admin/Model/Staff.dart';
import 'Agent.dart';

class Lead {
  String name;
  String? phoneNumber;
  String? address;
  String? email;
  String? governmentId;
  DateTime enquiryDate;
  DocumentReference? agentRef;
  DocumentReference? staffRef;
  Agent? agent;
  Staff? staff;

  DocumentReference? reference;

  Lead({
    required this.name,
    this.phoneNumber,
    this.address,
    this.email,
    required this.enquiryDate,
    required this.agentRef,
    this.staff,
    this.staffRef,
    this.agent,
    this.governmentId,
    this.reference,
  });

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
      };
  factory Lead.fromJson(json) {
    return Lead(
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        email: json["email"],
        enquiryDate: json["enquiryDate"].toDate(),
        agentRef: json["agentRef"],
        staffRef: json["staffRef"],
        reference: json["reference"],
        agent: json["agent"] != null ? Agent.fromJson(json["agent"]) : null,
        staff: json["staff"] != null ? Staff.fromJson(json["staff"]) : null);
  }
}
