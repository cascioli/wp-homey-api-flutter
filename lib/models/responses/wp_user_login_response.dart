import 'package:wp_homey_api/models/wp_user.dart';

class WPUserLoginResponse {
  bool? success;
  int? statusCode;
  String? code;
  String? message;
  WpUser? data;

  WPUserLoginResponse({
    this.success,
    this.statusCode,
    this.code,
    this.message,
    this.data,
  });

  WPUserLoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    statusCode = json['statusCode'] ?? -1;
    code = json['code'] ?? null;
    message = json['message'] ?? 'Error retrieving message';

    data = json['data'] != null && json['data'] != []
        ? new WpUser.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['code'] = this.code;
    data['success'] = this.success;
    return data;
  }
}
