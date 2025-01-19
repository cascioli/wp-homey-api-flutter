class WPHelpEmailResponse {
  bool? success;
  int? statusCode;
  String? code;
  String? message;

  WPHelpEmailResponse({
    this.success,
    this.statusCode,
    this.code,
    this.message,
  });

  WPHelpEmailResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 'error';
    statusCode = json['statusCode'] ?? -1;
    message = json['message'] ?? 'Error retrieving message';
    success = json['success'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    return data;
  }
}
