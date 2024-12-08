// Copyright (c) 2024, WooSignal Ltd.
// All rights reserved.
//
// Redistribution and use in source and binary forms are permitted
// provided that the above copyright notice and this paragraph are
// duplicated in all such forms and that any documentation,
// advertising materials, and other materials related to such
// distribution and use acknowledge that the software was developed
// by the WooSignal. The name of the
// WooSignal may not be used to endorse or promote products derived
// from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

import 'package:wp_homey_api/models/wp_user.dart';

class WPUserInfoUpdatedResponse {
  bool? success;
  int? statusCode;
  String? code;
  String? message;
  WpUser? data;

  WPUserInfoUpdatedResponse({
    this.success,
    this.statusCode,
    this.code,
    this.message,
    this.data,
  });

  WPUserInfoUpdatedResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    statusCode = json['statusCode'] ?? -1;
    code = json['code'] ?? null;
    message = json['message'] ?? 'Error retrieving message';

    data = json['data'] != null && json['data'] != [] && json['data'] != {}
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
