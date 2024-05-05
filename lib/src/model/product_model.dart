
// categoryName
// createdAt
// description
// isActive
// isSelling
// love
// price
// productId
// productName
// quantity
// sold
// urlImage


class ProductModel {
  String? categoryName;
  String? createdAt;
  String? description;
  String? detailDescription;
  int? isActive;
  int? isSelling;
  int? love;
  int? price;
  String? productName;
  int? quantity;
  int? sold;
  String? urlImage;
  String? id;

  ProductModel({
    this.categoryName,
    this.createdAt,
    this.description,
    this.detailDescription,
    this.isActive,
    this.isSelling,
    this.love,
    this.price,
    this.productName,
    this.quantity,
    this.sold,
    this.urlImage,
    this.id,
  });

  ProductModel.fromJson(Map<dynamic, dynamic> json) {
    categoryName = json['categoryName'] ?? '';
    createdAt = json['createdAt'] ?? '';
    description = json['description'] ?? '';
    detailDescription = json['detailDescription'] ?? '';
    isActive = json['isActive'] ?? 0;
    isSelling = json['isSelling'] ?? 0;
    love = json['love'] ?? 0;
    price = json['price'] ?? 0;
    productName = json['productName'] ?? '';
    quantity = json['quantity'] ?? 0;
    sold = json['sold'] ?? 0;
    urlImage = json['urlImage'] ?? '';
    id = json['productId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['createdAt'] = createdAt ?? DateTime.now().toString();
    data['description'] = description;
    data['isActive'] = isActive ?? 0;
    data['isSelling'] = isSelling ?? 0;
    data['love'] = love ?? 0;
    data['price'] = price;
    data['productName'] = productName;
    data['quantity'] = quantity;
    data['sold'] = sold ?? 0;
    data['urlImage'] = urlImage;
    data['productId'] = id;
    return data;
  }
}


// class ProductModel {

//   ProductModel({
//     this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.categoryId,
//     this.avatarUrl,
//     required this.quantity,
//     this.images,
//     required this.statusId,
//   });

//   String? id;
//   String name;
//   String description;
//   double price;
//   String categoryId;
//   String? avatarUrl;
//   int quantity;
//   List<String>? images;
//   int statusId;

//   set setAvatarUrl(String url) {
//     avatarUrl = url;
//   }

  

//   toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'price': price,
//       'categoryId': categoryId,
//       'avatarUrl': avatarUrl,
//       'quantity': quantity,
//       'images': images,
//       'statusId': statusId
//     };
//   }

//   static ProductModel fromMap(Map<String, dynamic> data, String id) {
//     return ProductModel(
//       id: id,
//       name: data['name'],
//       description: data['description'],
//       price: data['price'],
//       categoryId: data['categoryId'],
//       avatarUrl: data['avatarUrl'],
//       quantity: data['quantity'],
//       images: List<String>.from(data['images']),
//       statusId: data['statusId']
//     );
//   }
// }