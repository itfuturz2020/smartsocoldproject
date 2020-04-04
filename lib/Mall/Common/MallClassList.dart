class MallAPIClass {
  String message;
  String success;
  List data = [];

  MallAPIClass({this.message, this.success, this.data});

  factory MallAPIClass.fromJson(Map<String, dynamic> json) {
    return MallAPIClass(
        message: json['Message'] as String,
        success: json['IsSuccess'] as String,
        data: json['Data'] as List);
  }
}

class AddToCartClass {
  int productId;
  String productName;
  AddToCartClass(this.productId, this.productName);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'productId': productId,
      'productName': productName,
    };
    return map;
  }

  AddToCartClass.fromMap(Map<String, dynamic> map) {
    productId = map['productId'];
    productName = map['productName'];
  }
}
