import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_estate_admin/Model/Staff.dart';
import 'package:real_estate_admin/Providers/session.dart';

class Agent {
  String firstName;
  String? lastName;
  String phoneNumber;
  String? panCardNumber;
  String? addressLine1;
  String? addressLine2;
  String? city;
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
  DocumentReference reference;
  DocumentReference? agentReference;
  DocumentReference? approvedStaffReference;
  Agent? superAgent;
  Staff? approvedStaff;
  bool isApproved;
  String referenceCode;

  double commissionAmount;
  double sharedComissionAmount;

  Future<void> loadRefrences() async {
    if (agentReference != null) {
      superAgent = await agentReference!.get().then((value) => Agent.fromSnapshot(value));
    }
    if (approvedStaffReference != null) {
      approvedStaff = await approvedStaffReference!.get().then((value) => Staff.fromSnapshot(value));
    }
  }

  Agent({
    required this.referenceCode,
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
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.accountHolderName,
    this.accountNumber,
    this.bankName,
    this.branch,
    this.ifscCode,
    this.approvedStaff,
    this.isApproved = false,
    this.superAgent,
    this.commissionAmount = 0,
    this.sharedComissionAmount = 0,
    required this.reference,
  });

  Map<String, dynamic> toJson() => {
        "isApproved": isApproved,
        "referenceCode": referenceCode,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "accountHolderName": accountHolderName,
        "accountNumber": accountNumber,
        "bankName": bankName,
        "branch": branch,
        "ifscCode": ifscCode,
        "panCardNumber": panCardNumber,
        "docId": docId,
        "agentReference": agentReference,
        "approvedStaffReference": approvedStaffReference,
        "email": email,
        'commissionAmount': commissionAmount,
        'sharedComissionAmount': sharedComissionAmount,
        "search": search,
      };

  static List<String> makeSearchstring(String string) {
    List<String> list = [];
    for (int i = 1; i < string.length; i++) {
      list.add(string.substring(0, i).toLowerCase());
    }
    list.add(string.toLowerCase());
    return list;
  }

  List<String> get search {
    List<String> returns = [];
    returns.addAll(makeSearchstring(firstName));
    if ((lastName ?? '').isNotEmpty) {
      returns.addAll(makeSearchstring(lastName!));
    }
    if ((panCardNumber ?? '').isNotEmpty) {
      returns.addAll(makeSearchstring(panCardNumber!));
    }
    if ((phoneNumber).isNotEmpty) {
      returns.addAll(makeSearchstring(phoneNumber));
    }
    return returns;
  }

  static Agent fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Agent(
      reference: snapshot.reference,
      email: data["email"],
      isApproved: data["isApproved"],
      referenceCode: data["referenceCode"],
      docId: snapshot.id,
      firstName: data["firstName"],
      lastName: data["lastName"],
      phoneNumber: data["phoneNumber"],
      addressLine1: data["addressLine1"],
      addressLine2: data["addressLine2"],
      city: data["city"],
      state: data["state"],
      country: data["country"],
      pincode: data["pincode"],
      accountHolderName: data["accountHolderName"],
      accountNumber: data["accountNumber"],
      bankName: data["bankName"],
      branch: data["branch"],
      ifscCode: data["ifscCode"],
      panCardNumber: data["panCardNumber"],
      agentReference: data["agentReference"],
      // approvedStaff: data['approvedStaff'],
      commissionAmount: data['commissionAmount'] ?? 0,
      sharedComissionAmount: data['sharedComissionAmount'] ?? 0,
      superAgent: data['superAgent'],
      approvedStaffReference: data["approvedStaffReference"],
    );
  }

  factory Agent.fromJson(Map<String, dynamic> data) {
    return Agent(
      email: data["email"],
      isApproved: data["isApproved"],
      referenceCode: data["referenceCode"],
      docId: data["docId"],
      firstName: data["firstName"],
      lastName: data["lastName"],
      phoneNumber: data["phoneNumber"],
      addressLine1: data["addressLine1"],
      addressLine2: data["addressLine2"],
      city: data["city"],
      state: data["state"],
      country: data["country"],
      pincode: data["pincode"],
      accountHolderName: data["accountHolderName"],
      accountNumber: data["accountNumber"],
      bankName: data["bankName"],
      branch: data["branch"],
      ifscCode: data["ifscCode"],
      panCardNumber: data["panCardNumber"],
      agentReference: data["agentReference"],
      approvedStaff: data["approvedStaff"],
      commissionAmount: data["commissionAmount"] ?? 0,
      superAgent: data["superAgent"],
      approvedStaffReference: data["approvedStaffReference"],
      reference: data["reference"],
    );
  }

  Future<List<Agent>> getReferrals() async {
    DocumentReference? agentReference = reference;
    return FirebaseFirestore.instance.collection('agents').where('agentReference', isEqualTo: agentReference).get().then((value) {
      return value.docs.map((e) => Agent.fromSnapshot(e)).toList();
    });
  }

  Future<void> disable() {
    return FirebaseFirestore.instance.collection('agents').doc(docId).update({"isApproved": false});
  }

  Future<void> enable() {
    return FirebaseFirestore.instance.collection('agents').doc(docId).update({
      "isApproved": true,
    });
  }
}
