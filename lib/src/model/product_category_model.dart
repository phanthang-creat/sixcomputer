
class ProductCategoryModel {
  String categoryName;
  dynamic categoryId;
  String? categoryImage;

  ProductCategoryModel({
    required this.categoryName, this.categoryId, this.categoryImage
  });

  static ProductCategoryModel fromMap(Map<String, dynamic> data) {
    return ProductCategoryModel(
      categoryName: data['categoryName'],
      categoryId: data['categoryId'],
      categoryImage: data['categoryImage']
    );
  }

  Object? toJson() {
    return {
      'categoryName': categoryName,
      'categoryId': categoryId,
      'categoryImage': categoryImage
    };
  }

  static ProductCategoryModel fromJson(Map<dynamic, dynamic> json) {
    return ProductCategoryModel(
      categoryName: json['categoryName'],
      categoryId: json['categoryId'],
      categoryImage: json['categoryImage']
    );
  }
}