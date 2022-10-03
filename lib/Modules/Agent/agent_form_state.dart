import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  TextEditingController street = TextEditingController();
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
  Agent? approvedStaff;

  Agent get agent => Agent(
        panCardNumber: panCardNumber.text,
        agentReference: agentReference,
        approvedStaffReference: approvedStaffReference,
        docId: docId,
        phoneNumber: phoneNumber.text,
        firstName: firstName.text,
        lastName: lastName.text,
        email: email.text,
        addressLine1: addressLine1.text,
        addressLine2: addressLine2.text,
        street: street.text,
        state: state.text,
        country: country.text,
        pincode: pincode.text,
        accountHolderName: accountHolderName.text,
        accountNumber: accountNumber.text,
        bankName: bankName.text,
        branch: branch.text,
        ifscCode: ifscCode.text,
      );
}
