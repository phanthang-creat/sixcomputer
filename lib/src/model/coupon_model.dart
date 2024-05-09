class CouponModel {
  String? couponId;
  String? couponName;
  int? percentageNum;
  String? productId;
  String? productName;
  String? key;

  CouponModel({
    this.couponId,
    this.couponName,
    this.percentageNum,
    this.productId,
  });

  CouponModel.fromJson(Map<dynamic, dynamic> json, String key) {
    couponId = json['couponId'] ?? '';
    couponName = json['couponName'] ?? '';
    percentageNum = json['percentageNum'] ?? 0;
    productId = json['productId'] ?? '';
    this.key = key;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['couponId'] = couponId;
    data['couponName'] = couponName;
    data['percentageNum'] = percentageNum ?? 0;
    data['productId'] = productId;
    return data;
  }

  @override
  String toString() {
    return 'CouponModel{couponId: $couponId, couponName: $couponName, percentageNum: $percentageNum, productId: $productId}';
  }
}