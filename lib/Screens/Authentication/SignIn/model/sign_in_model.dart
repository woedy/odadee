class SignInModel {
  String? token;
  String? message;
  String? error;
  UserData? userData;

  SignInModel({this.token, this.message, this.error, this.userData});

  SignInModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    message = json['message'];
    error = json['error'];
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['message'] = this.message;
    data['error'] = this.error;
    if (this.userData != null) {
      data['userData'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  String? firstName;
  String? middleName;
  String? lastName;
  String? nickName;
  String? yearGroup;
  String? email;
  String? createdTime;
  bool? isVerified;
  bool? hasImage;
  bool? hasBio;

  UserData(
      {this.firstName,
        this.middleName,
        this.lastName,
        this.nickName,
        this.yearGroup,
        this.email,
        this.createdTime,
        this.isVerified,
        this.hasImage,
        this.hasBio});

  UserData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    nickName = json['nickName'];
    yearGroup = json['yearGroup'];
    email = json['email'];
    createdTime = json['createdTime'];
    isVerified = json['is_verified'];
    hasImage = json['has_image'];
    hasBio = json['has_bio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['nickName'] = this.nickName;
    data['yearGroup'] = this.yearGroup;
    data['email'] = this.email;
    data['createdTime'] = this.createdTime;
    data['is_verified'] = this.isVerified;
    data['has_image'] = this.hasImage;
    data['has_bio'] = this.hasBio;
    return data;
  }
}
