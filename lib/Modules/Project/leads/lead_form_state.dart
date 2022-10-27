import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:real_estate_admin/Model/Lead.dart';

import '../../../Model/Agent.dart';
import '../../../Model/Staff.dart';
// import '../../../Model/staff.dart';

class LeadFormController {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController governmentId = TextEditingController();
  DateTime enquiryDate = DateTime.now();
  DocumentReference? agentRef;
  DocumentReference? staffRef;
  Agent? agent;
  Staff? staff;
  DocumentReference? _reference;

  DocumentReference get reference => _reference ?? propertyRef.collection('leads').doc();

  LeadFormController(this.propertyRef);

  final DocumentReference propertyRef;

  factory LeadFormController.fromLead(Lead lead) {
    var controller = LeadFormController(lead.propertyRef);
    controller.name.text = lead.name;
    controller.phoneNumber.text = lead.phoneNumber ?? '';
    controller.address.text = lead.address ?? '';
    controller.email.text = lead.email ?? '';
    controller.governmentId.text = lead.governmentId ?? '';
    controller.enquiryDate = lead.enquiryDate;
    controller.agentRef = lead.agentRef;
    controller.staffRef = lead.staffRef;
    controller.agent = lead.agent;
    controller.staff = lead.staff;
    controller._reference = lead.reference;
    return controller;
  }

  Lead get lead {
    return Lead(
      name: name.text,
      enquiryDate: enquiryDate,
      agentRef: agentRef,
      address: address.text,
      agent: agent,
      email: email.text,
      governmentId: governmentId.text,
      phoneNumber: phoneNumber.text,
      reference: reference,
      staff: staff,
      staffRef: staffRef,
    );
  }
}
