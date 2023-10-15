class SettingsModel {
  Setting? setting;

  SettingsModel({this.setting});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    setting =
    json['setting'] != null ? new Setting.fromJson(json['setting']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.setting != null) {
      data['setting'] = this.setting!.toJson();
    }
    return data;
  }
}

class Setting {
  String? pushNotification;

  Setting({this.pushNotification});

  Setting.fromJson(Map<String, dynamic> json) {
    pushNotification = json['push_notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['push_notification'] = this.pushNotification;
    return data;
  }
}
