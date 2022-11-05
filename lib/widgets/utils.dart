import 'package:get/get.dart';

String? requiredValidator(String? string) {
  if ((string ?? '').trim().isEmpty) {
    return 'This is a required field';
  }
  return null;
}

String? requiredEmail(String? string) {
  if ((string ?? '').trim().isEmpty) {
    return null;
  }
  if (!(string ?? '').trim().isEmail) {
    return 'Please enter a valid email';
  }
  return null;
}

String? requiredPhone(String? string) {
  if ((string ?? '').trim().isEmpty) {
    return 'This is a required field';
  }
  if (!(string ?? '').trim().isPhoneNumber) {
    return 'Please enter a valid phonenumber';
  }
  return null;
}

String? requiredPinCode(String? string) {
  if ((string ?? '').trim().isEmpty) {
    return 'This is a required field';
  }
  if (!(string ?? '').trim().isNumericOnly) {
    return 'Please enter a valid PIN code';
  }
  return null;
}
