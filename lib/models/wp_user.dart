import 'package:flutter/widgets.dart';
import 'package:nylo_support/helpers/model.dart';

class WpUser extends Model {
  int? id;
  String? token;
  String? refreshToken;
  String? email;
  String? nicename;
  String? displayName;
  String? firstName;
  String? lastName;

  WpUser({
    this.id,
    this.token,
    this.refreshToken,
    this.email,
    this.nicename,
    this.displayName,
    this.firstName,
    this.lastName,
  });

  /// Creates a [WpUser] from a JSON object
  WpUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    refreshToken = json['refreshToken'] ?? null;
    email = json['email'];
    nicename = json['nicename'];
    displayName = json['displayName'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  /// Creates a [WpUser] from a [WPUserRegisterResponse]
  /*WpUser.fromWPUserRegisterResponse(
      WPUserRegisterResponse wpUserRegisterResponse) {
    id = wpUserRegisterResponse.data?.userId;
    token = wpUserRegisterResponse.data?.userToken;
    refreshToken = wpUserRegisterResponse.data?.refreshToken;
    email = wpUserRegisterResponse.data?.email;
    nicename = wpUserRegisterResponse.data?.us;
    username = wpUserRegisterResponse.data?.username;
    firstName = wpUserRegisterResponse.data?.firstName;
    lastName = wpUserRegisterResponse.data?.lastName;
  }

  /// Creates a [WpUser] from a [WPUserLoginResponse]
  WpUser.fromWPUserLoginResponse(WPUserLoginResponse wpUserLoginResponse) {
    id = wpUserLoginResponse.data?.userId;
    token = wpUserLoginResponse.data?.userToken;
    refreshToken = wpUserLoginResponse.data?.refreshToken;
    email = wpUserLoginResponse.data?.userEmail;
    username = wpUserLoginResponse.data?.userDisplayName;
    firstName = wpUserLoginResponse.data?.firstName;
    lastName = wpUserLoginResponse.data?.lastName;
  }*/

  /// Converts the [WpUser] to a JSON object
  toJson() => {
        'id': id,
        'token': token,
        'refreshToken': refreshToken,
        'email': email,
        'nicename': nicename,
        'displayName': displayName,
        'first_name': firstName,
        'last_name': lastName,
      };

  WpUser copyWith({
    ValueGetter<int?>? id,
    ValueGetter<String?>? token,
    ValueGetter<String?>? refreshToken,
    ValueGetter<String?>? email,
    ValueGetter<String?>? nicename,
    ValueGetter<String?>? displayName,
    ValueGetter<String?>? firstName,
    ValueGetter<String?>? lastName,
  }) {
    return WpUser(
      id: id != null ? id() : this.id,
      token: token != null ? token() : this.token,
      refreshToken: refreshToken != null ? refreshToken() : this.refreshToken,
      email: email != null ? email() : this.email,
      nicename: nicename != null ? nicename() : this.nicename,
      displayName: displayName != null ? displayName() : this.displayName,
      firstName: firstName != null ? firstName() : this.firstName,
      lastName: lastName != null ? lastName() : this.lastName,
    );
  }

  @override
  String toString() {
    return 'WpUser(id: $id, token: $token, refreshToken: $refreshToken, email: $email, nicename: $nicename, displayName: $displayName, firstName: $firstName, lastName: $lastName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WpUser &&
        other.id == id &&
        other.token == token &&
        other.refreshToken == refreshToken &&
        other.email == email &&
        other.nicename == nicename &&
        other.displayName == displayName &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        token.hashCode ^
        refreshToken.hashCode ^
        email.hashCode ^
        nicename.hashCode ^
        displayName.hashCode ^
        firstName.hashCode ^
        lastName.hashCode;
  }
}
