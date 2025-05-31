

import '../utils/constant_file.dart';

class RegisterUserModel {
  final String? name;
  final String? email;
  final String? mobile;
  final String? password;
  final String? userId;

  const RegisterUserModel({this.name = '', this.email = '', this.mobile = '', this.password = '', this.userId = ''});



  factory RegisterUserModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserModel(
      name: json[ConstantsFile.paramName],
      email: json[ConstantsFile.paramEmail],
      mobile: json[ConstantsFile.paramMobile],
      password: json[ConstantsFile.paramPassword],
      userId: json[ConstantsFile.paramUserId],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ConstantsFile.paramName: name,
      ConstantsFile.paramEmail: email,
      ConstantsFile.paramMobile: mobile,
      ConstantsFile.paramPassword: password,
      ConstantsFile.paramUserId: userId,
    };
  }
}


