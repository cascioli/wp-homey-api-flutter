import 'package:nylo_support/helpers/model.dart';
import '/models/responses/wp_user_login_response.dart';
import '/models/responses/wp_user_register_response.dart';

class WpUser extends Model {
  int? id;
  String? token;
  String? email;
  String? username;
  String? firstName;
  String? lastName;
  String? avatar;
  String? createdAt;

  WpUser(
      {this.id,
      this.token,
      this.email,
      this.username,
      this.firstName,
      this.lastName,
      this.avatar,
      this.createdAt});

  /// Creates a [WpUser] from a JSON object
  WpUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    email = json['email'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
    createdAt = json['created_at'];
  }

  /// Creates a [WpUser] from a [WPUserRegisterResponse]
  WpUser.fromWPUserRegisterResponse(
      WPUserRegisterResponse wpUserRegisterResponse) {
    id = wpUserRegisterResponse.data?.userId;
    token = wpUserRegisterResponse.data?.userToken;
    email = wpUserRegisterResponse.data?.email;
    username = wpUserRegisterResponse.data?.username;
    firstName = wpUserRegisterResponse.data?.firstName;
    lastName = wpUserRegisterResponse.data?.lastName;
    avatar = wpUserRegisterResponse.data?.avatar;
    createdAt = wpUserRegisterResponse.data?.createdAt;
  }

  /// Creates a [WpUser] from a [WPUserLoginResponse]
  WpUser.fromWPUserLoginResponse(WPUserLoginResponse wpUserLoginResponse) {
    id = wpUserLoginResponse.data?.userId;
    token = wpUserLoginResponse.data?.userToken;
    email = wpUserLoginResponse.data?.userEmail;
    username = wpUserLoginResponse.data?.userDisplayName;
    firstName = wpUserLoginResponse.data?.firstName;
    lastName = wpUserLoginResponse.data?.lastName;
    avatar = wpUserLoginResponse.data?.avatar;
  }

  /// Converts the [WpUser] to a JSON object
  toJson() => {
        'id': id,
        'token': token,
        'email': email,
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar,
        'created_at': createdAt
      };
}
