class SaveDataClass {
  String Message;
  bool IsSuccess;
  String Data;
  bool IsRecord;

  SaveDataClass({this.Message, this.IsSuccess, this.Data, this.IsRecord});

  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data'] as String,
        IsRecord: json['IsRecord'] as bool);
  }
}

class WingClassData {
  String Message;
  bool IsSuccess;
  List<WingClass> Data;

  WingClassData({
    this.Message,
    this.IsSuccess,
    this.Data,
  });

  factory WingClassData.fromJson(Map<String, dynamic> json) {
    return WingClassData(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data']
            .map<WingClass>((json) => WingClass.fromJson(json))
            .toList());
  }
}

class WingClass {
  String WingId;
  String WingName;

  WingClass({this.WingId, this.WingName});

  factory WingClass.fromJson(Map<String, dynamic> json) {
    return WingClass(
        WingId: json['Id'].toString() as String,
        WingName: json['WingName'].toString() as String);
  }
}

class staffClassData {
  String Message;
  bool IsSuccess;
  List<staffClass> Data;

  staffClassData({
    this.Message,
    this.IsSuccess,
    this.Data,
  });

  factory staffClassData.fromJson(Map<String, dynamic> json) {
    return staffClassData(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data']
            .map<staffClass>((json) => staffClass.fromJson(json))
            .toList());
  }
}

class staffClass {
  String id;
  String name;

  staffClass({this.id, this.name});

  factory staffClass.fromJson(Map<String, dynamic> json) {
    return staffClass(
        id: json['Id'].toString() as String,
        name: json['StaffType1'].toString() as String);
  }
}


