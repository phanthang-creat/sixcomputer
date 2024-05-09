import 'package:firebase_database/firebase_database.dart';
import 'package:sixcomputer/src/model/coupon_model.dart';

class CouponClient {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Coupon');

  Future<List<CouponModel>> getAllCoupons() async {
    final productRaw = await ref.once();
    final List<CouponModel> coupons = [];
    if (productRaw.snapshot.value != null) {
      final Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(productRaw.snapshot.value as Map<dynamic, dynamic>);
      data.forEach((key, value) {
        coupons.add(CouponModel.fromJson(value as Map<dynamic, dynamic>, key as String));
      });
    }
    return coupons;
  }

  Future<List<CouponModel>> fetchCoupons2() async {
    final couponsChild = await ref.once();

    print("Products: ${couponsChild.snapshot.value}");

    final List<CouponModel> coupons = [];

    if (couponsChild.snapshot.value != null) {
      final Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(couponsChild.snapshot.value as Map<dynamic, dynamic>);

      data.forEach((key, value) {
        coupons.add(CouponModel.fromJson(value as Map<dynamic, dynamic>, key as String));
      });
    }

    return coupons;
  }

  Future<void> addCoupon(CouponModel coupon) async {
    await FirebaseDatabase.instance.ref('Coupon/${coupon.couponId}').set(coupon.toJson());
  }

  Future<void> deleteCoupon(String key) async {
    await FirebaseDatabase.instance.ref('Coupon/$key').remove();
  }

  Future<void> updateCoupon(CouponModel coupon) async {
    await FirebaseDatabase.instance.ref('Coupon/${coupon.key}').update(coupon.toJson());
  }

  Future<CouponModel> getCouponById(String id) async {

    final coupon = await FirebaseDatabase.instance.ref().child('Coupon').child(id).once();

    return CouponModel.fromJson(coupon.snapshot.value as Map<dynamic, dynamic>, id);
  }
}