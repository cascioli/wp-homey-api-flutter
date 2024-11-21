class WPUserLoginResponse {
  Data? data;
  String? message;
  int? status;

  WPUserLoginResponse({this.data, this.message, this.status});

  WPUserLoginResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('data')) {
      data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    }

    if (json.containsKey('message')) {
      message = json['message'];
    }
    if (json.containsKey('status')) {
      status = json['status'];
    }

    if (!json.containsKey('data') &&
        !json.containsKey('message') &&
        !json.containsKey('status')) {
      data = new Data.fromJson(json);
      message = 'Login successful';
      status = 200;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? userToken;
  int? userId;
  String? userEmail;
  String? userNicename;
  String? userDisplayName;
  String? firstName;
  String? lastName;
  List<String>? roles;
  String? avatar;
  int? createdAt;

  Data({
    this.userToken,
    this.userId,
    this.userEmail,
    this.userNicename,
    this.userDisplayName,
    this.firstName,
    this.lastName,
    this.roles,
    this.avatar,
    this.createdAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('token')) {
      userToken = json['token'];
    }
    if (json.containsKey('user_email')) {
      userEmail = json['user_email'];
    }
    if (json.containsKey('user_nicename')) {
      userNicename = json['user_nicename'];
    }
    if (json.containsKey('user_display_name')) {
      userDisplayName = json['user_display_name'];
    }
    if (json.containsKey('id')) {
      userId = json['id'];
    }
    if (json.containsKey('email')) {
      userEmail = json['email'];
    }
    if (json.containsKey('slug')) {
      userNicename = json['slug'];
    }
    if (json.containsKey('name')) {
      userDisplayName = json['name'];
    }
    if (json.containsKey('first_name')) {
      firstName = json['first_name'];
    }
    if (json.containsKey('last_name')) {
      lastName = json['last_name'];
    }
    if (json.containsKey('roles')) {
      roles = List<String>.from(json['roles'] ?? []);
    }
    if (json.containsKey('avatar_urls')) {
      avatar = json['avatar_urls']?['96'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.userToken;
    data['id'] = this.userId;
    data['email'] = this.userEmail;
    data['slug'] = this.userNicename;
    data['name'] = this.userDisplayName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['roles'] = this.roles;
    data['avatar_urls'] = {'96': this.avatar};
    return data;
  }
}
