import 'package:sixcomputer/src/model/ordder_item_model.dart';

class OrderModel {
  String? address;
  String? bookingDate;
  String? country;
  String? email;
  String? fullname;
  String? id;
  String? note;
  String? paymentMethod;
  String? phone;  
  String? status;
  int? total;
  String? userId;
  String? key;
  List<OrderItemModel> orderItems = [];

  OrderModel({
    this.address,
    this.bookingDate,
    this.country,
    this.email,
    this.fullname,
    this.id,
    this.note,
    this.paymentMethod,
    this.phone,
    this.status,
    this.total,
    this.userId,
  });

  OrderModel.fromJson(Map<dynamic, dynamic> json, String this.key) {
    address = json['address'];
    bookingDate = json['bookingDate'];
    country = json['country'];
    email = json['email'];
    fullname = json['fullname'];
    id = json['id'];
    note = json['note'];
    paymentMethod = json['paymentMethod'];
    phone = json['phone'];
    status = json['status'];
    total = json['total'];
    userId = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['bookingDate'] = bookingDate;
    data['country'] = country;
    data['email'] = email;
    data['fullname'] = fullname;
    data['id'] = id;
    data['note'] = note;
    data['paymentMethod'] = paymentMethod;
    data['phone'] = phone;
    data['status'] = status;
    data['total'] = total;
    data['userId'] = userId;
    return data;
  }

  @override
  String toString() {
    return 'OrderModel{address: $address, bookingDate: $bookingDate, country: $country, email: $email, fullname: $fullname, id: $id, note: $note, paymentMethod: $paymentMethod, phone: $phone, status: $status, total: $total, userId: $userId}';
  }

}