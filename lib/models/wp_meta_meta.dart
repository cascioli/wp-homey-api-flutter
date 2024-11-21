import '/enums/wp_meta_data_action_type.dart';

class WpMetaData {
  String? key;
  dynamic value;
  WPMetaDataActionType action;
  int? unique;

  WpMetaData(
      {this.key,
      this.value,
      this.action = WPMetaDataActionType.Update,
      this.unique});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['action'] = _getActionFromType();
    if (this.unique != null) {
      data['unique'] = this.unique;
    }
    return data;
  }

  String _getActionFromType() {
    switch (this.action) {
      case WPMetaDataActionType.Create:
        {
          return "create";
        }
      case WPMetaDataActionType.Update:
        {
          return "update";
        }
      case WPMetaDataActionType.Delete:
        {
          return "delete";
        }
      default:
        {
          return "";
        }
    }
  }
}
