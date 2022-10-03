import 'package:cloud_firestore/cloud_firestore.dart';

class Agent {
  String firstName;
  String? lastName;
  String phoneNumber;
  String? panCardNumber;
  String? addressLine1;
  String? addressLine2;
  String? street;
  String? state;
  String? country;
  String? pincode;
  String? accountHolderName;
  String? accountNumber;
  String? bankName;
  String? branch;
  String? ifscCode;
  String? docId;
  String? email;
  DocumentReference? agentReference;
  DocumentReference? approvedStaffReference;
  Agent? superAgent;
  Agent? approvedStaff;
  bool isStaff;
  bool isAdmin;

  loadRefrences() async {
    if (agentReference != null) {
      superAgent = await agentReference!.get().then((value) => Agent.fromSnapshot(value));
    }
    if (approvedStaffReference != null) {
      approvedStaff = await approvedStaffReference!.get().then((value) => Agent.fromSnapshot(value));
    }
  }

  Agent({
    this.panCardNumber,
    this.agentReference,
    this.approvedStaffReference,
    required this.docId,
    required this.phoneNumber,
    required this.firstName,
    this.lastName,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.street,
    this.state,
    this.country,
    this.pincode,
    this.accountHolderName,
    this.accountNumber,
    this.bankName,
    this.branch,
    this.ifscCode,
    this.isAdmin = false,
    this.isStaff = false,
  });

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "street": street,
        "state": state,
        "country": country,
        "pincode": pincode,
        "accountHolderName": accountHolderName,
        "accountNumber": accountNumber,
        "bankName": bankName,
        "branch": branch,
        "ifscCode": ifscCode,
      };

  static Agent fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Agent(docId: snapshot.id, phoneNumber: data["phoneNumber"], firstName: data["firstName"]);
  }
}
