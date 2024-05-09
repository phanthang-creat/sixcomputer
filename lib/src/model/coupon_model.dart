class CouponModel {
  String? couponId;
  String? couponName;
  int? percentageNum;
  String? productId;
  String? id;
  CouponModel({
    this.couponId,
    this.couponName,
    this.percentageNum,
    this.productId,
    this.id,
  });

  CouponModel.fromJson(Map<dynamic, dynamic> json) {
    couponId = json['couponId'] ?? '';
    couponName = json['couponName'] ?? '';
    percentageNum = json['percentageNum'] ?? 0;
    productId = json['productId'] ?? '';
    id = json['id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['couponId'] = couponId;
    data['couponName'] = couponName;
    data['percentageNum'] = percentageNum;
    data['productId'] = productId;
    data['id'] = id;
    return data;
  }

  @override
  String toString() {
    return 'CouponModel{couponId: $couponId, couponName: $couponName, percentageNum: $percentageNum, productId: $productId}';
  }
}