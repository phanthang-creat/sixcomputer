class OrderItemModel {
  int? count;
  String? description;
  String? orderId;
  String? orderItemId;
  int? price;
  int? productId;
  String? productName;
  String? urlImage;

  OrderItemModel({
    this.count,
    this.description,
    this.orderId,
    this.orderItemId,
    this.price,
    this.productId,
    this.productName,
    this.urlImage,
  });

  OrderItemModel.fromJson(Map<dynamic, dynamic> json) {
    count = json['count'];
    description = json['description'];
    orderId = json['id'];
    orderItemId = json['orderItemId'];
    price = json['price'];
    productId = json['productId'];
    productName = json['productName'];
    urlImage = json['urlImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['description'] = description;
    data['id'] = orderId;
    data['orderItemId'] = orderItemId;
    data['price'] = price;
    data['productId'] = productId;
    data['productName'] = productName;
    data['urlImage'] = urlImage;
    return data;
  }

  @override
  String toString() {
    return 'OrderItemModel{count: $count, description: $description, orderId: $orderId, orderItemId: $orderItemId, price: $price, productId: $productId, productName: $productName, urlImage: $urlImage}';
  }
  
}