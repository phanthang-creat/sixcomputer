class CouponModel {
  String? couponId;
  String? couponName;
  int? precentageNum;
  String? productId;

  CouponModel({
    this.couponId,
    this.couponName,
    this.precentageNum,
    this.productId,
  });

  CouponModel.fromJson(Map<dynamic, dynamic> json) {
    couponId = json['couponId'] ?? '';
    couponName = json['couponName'] ?? '';
    precentageNum = json['precentageNum'] ?? 0;
    productId = json['productId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['couponId'] = couponId;
    data['couponName'] = couponName;
    data['precentageNum'] = precentageNum ?? 0;
    data['productId'] = productId;
    return data;
  }

  @override
  String toString() {
    return 'CouponModel{couponId: $couponId, couponName: $couponName, precentageNum: $precentageNum, productId: $productId}';
  }
}