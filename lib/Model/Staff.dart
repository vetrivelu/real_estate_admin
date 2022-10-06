import 'package:cloud_firestore/cloud_firestore.dart';

class Staff {
  final String firstName;
  final String? lastName;
  final String phoneNumber;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? accountHolderName;
  final String? panCardNumber;
  final String? bankName;
  final String? branch;
  final String? ifscCode;
  final String docId;
  final String email;

  Staff({
    required this.docId,
    required this.phoneNumber,
    required this.firstName,
    this.lastName,
    required this.email,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.accountHolderName,
    this.panCardNumber,
    this.bankName,
    this.branch,
    this.ifscCode,
  });

  Map<String, dynamic> toJson() => {
        "docId": docId,
        "phoneNumber": phoneNumber,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "accountHolderName": accountHolderName,
        "panCardNumber": panCardNumber,
        "bankName": bankName,
        "branch": branch,
        "ifscCode": ifscCode,
        "search": search
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

  static Staff fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Staff(
      docId: data["docId"],
      phoneNumber: data["phoneNumber"],
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
      addressLine1: data["addressLine1"],
      addressLine2: data["addressLine2"],
      city: data["city"],
      state: data["state"],
      country: data["country"],
      pincode: data["pincode"],
      accountHolderName: data["accountHolderName"],
      panCardNumber: data["panCardNumber"],
      bankName: data["bankName"],
      branch: data["branch"],
      ifscCode: data["ifscCode"],
    );
  }

  factory Staff.fromJson(data) {
    return Staff(
      docId: data["docId"],
      phoneNumber: data["phoneNumber"],
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
      addressLine1: data["addressLine1"],
      addressLine2: data["addressLine2"],
      city: data["city"],
      state: data["state"],
      country: data["country"],
      pincode: data["pincode"],
      accountHolderName: data["accountHolderName"],
      panCardNumber: data["panCardNumber"],
      bankName: data["bankName"],
      branch: data["branch"],
      ifscCode: data["ifscCode"],
    );
  }
}
