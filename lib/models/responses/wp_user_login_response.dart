import 'package:flutter/widgets.dart';

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

  WPUserLoginResponse copyWith({
    ValueGetter<bool?>? success,
    ValueGetter<int?>? statusCode,
    ValueGetter<String?>? code,
    ValueGetter<String?>? message,
    ValueGetter<WpUser?>? data,
  }) {
    return WPUserLoginResponse(
      success: success != null ? success() : this.success,
      statusCode: statusCode != null ? statusCode() : this.statusCode,
      code: code != null ? code() : this.code,
      message: message != null ? message() : this.message,
      data: data != null ? data() : this.data,
    );
  }

  @override
  String toString() {
    return 'WPUserLoginResponse(success: $success, statusCode: $statusCode, code: $code, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WPUserLoginResponse &&
        other.success == success &&
        other.statusCode == statusCode &&
        other.code == code &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        statusCode.hashCode ^
        code.hashCode ^
        message.hashCode ^
        data.hashCode;
  }
}
