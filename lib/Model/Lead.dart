import 'package:cloud_firestore/cloud_firestore.dart';
import 'Agent.dart';

class Lead {
  String name;
  String? phoneNumber;
  String? address;
  String? email;
  String? governmentId;
  DateTime enquiryDate;
  DocumentReference agentRef;
  Agent? agent;

  Lead({
    required this.name,
    this.phoneNumber,
    this.address,
    this.email,
    required this.enquiryDate,
    required this.agentRef,
  });

  toJson() => {
        "name": name,
        "phoneNumber": phoneNumber,
        "address": address,
        "email": email,
        "enquiryDate": enquiryDate,
        "agentRef": agentRef,
      };
  factory Lead.fromJson(json) {
    return Lead(
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        email: json["email"],
        enquiryDate: json["enquiryDate"].toDate(),
        agentRef: json["agentRef"]);
  }
}
