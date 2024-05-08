class Coupon {
  String? couponId;
  String? couponName;
  String? couponCode;
  String? couponDescription;
  int? couponDiscount;
  String? couponStartDate;
  String? couponEndDate;
  int? couponStatus;

  Coupon({
    this.couponId,
    this.couponName,
    this.couponCode,
    this.couponDescription,
    this.couponDiscount,
    this.couponStartDate,
    this.couponEndDate,
    this.couponStatus,
  });

  Coupon.fromJson(Map<dynamic, dynamic> json) {
    couponId = json['couponId'] ?? '';
    couponName = json['couponName'] ?? '';
    couponCode = json['couponCode'] ?? '';
    couponDescription = json['couponDescription'] ?? '';
    couponDiscount = json['couponDiscount'] ?? 0;
    couponStartDate = json['couponStartDate'] ?? '';
    couponEndDate = json['couponEndDate'] ?? '';
    couponStatus = json['couponStatus'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['couponId'] = couponId;
    data['couponName'] = couponName;
    data['couponCode'] = couponCode;
    data['couponDescription'] = couponDescription;
    data['couponDiscount'] = couponDiscount;
    data['couponStartDate'] = couponStartDate;
    data['couponEndDate'] = couponEndDate;
    data['couponStatus'] = couponStatus ?? 0;
    return data;
  }

}