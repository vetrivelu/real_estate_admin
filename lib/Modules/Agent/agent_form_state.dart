import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:real_estate_admin/Model/Staff.dart';
import 'package:real_estate_admin/Modules/Agent/agent_form.dart';

import '../../Model/Agent.dart';

class AgentFormController {
  AgentFormController({this.docId});
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController panCardNumber = TextEditingController();
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController accountHolderName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController branch = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  String? docId;
  TextEditingController email = TextEditingController();
  DocumentReference? agentReference;
  DocumentReference? approvedStaffReference;
  Agent? superAgent;
  Staff? approvedStaff;
  String? referenceCode;
  bool isApproved = false;

  factory AgentFormController.fromAgent(Agent agent) {
    var controller = AgentFormController();
    controller.referenceCode = agent.referenceCode;
    controller.panCardNumber.text = agent.panCardNumber ?? '';
    controller.agentReference = agent.agentReference;
    controller.approvedStaffReference = agent.approvedStaffReference;
    controller.docId = agent.docId;
    controller.phoneNumber.text = agent.phoneNumber;
    controller.firstName.text = agent.firstName;
    controller.lastName.text = agent.lastName ?? '';
    controller.email.text = agent.email ?? '';
    controller.addressLine1.text = agent.addressLine1 ?? '';
    controller.addressLine2.text = agent.addressLine2 ?? '';
    controller.city.text = agent.city ?? '';
    controller.state.text = agent.state ?? '';
    controller.country.text = agent.country ?? '';
    controller.pincode.text = agent.pincode ?? '';
    controller.accountHolderName.text = agent.accountHolderName ?? '';
    controller.accountNumber.text = agent.accountNumber ?? '';
    controller.bankName.text = agent.bankName ?? '';
    controller.branch.text = agent.branch ?? '';
    controller.ifscCode.text = agent.ifscCode ?? '';
    controller.isApproved = agent.isApproved;
    return controller;
  }

  String get newReferenceCode => (Random.secure().nextInt(999999) + 100000).toString();
  String get newDocId => FirebaseFirestore.instance.collection('agents').doc().id;

  Agent get agent => Agent(
        referenceCode: referenceCode ?? newReferenceCode,
        panCardNumber: panCardNumber.text,
        agentReference: agentReference,
        approvedStaffReference: approvedStaffReference,
        docId: docId ?? newDocId,
        phoneNumber: phoneNumber.text,
        firstName: firstName.text,
        lastName: lastName.text,
        email: email.text,
        addressLine1: addressLine1.text,
        addressLine2: addressLine2.text,
        city: city.text,
        state: state.text,
        country: country.text,
        pincode: pincode.text,
        accountHolderName: accountHolderName.text,
        accountNumber: accountNumber.text,
        bankName: bankName.text,
        branch: branch.text,
        ifscCode: ifscCode.text,
        isApproved: isApproved,
        approvedStaff: approvedStaff,
        superAgent: superAgent,
      );
}
