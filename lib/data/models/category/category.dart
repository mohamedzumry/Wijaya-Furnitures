class CategoryType {
  final String id;
  final String categoryName;

  CategoryType({required this.id, required this.categoryName});

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
    };
  }

  factory CategoryType.fromJson(Map<String, dynamic> json) {
    return CategoryType(
      categoryName: json['categoryName'],
      id: json['id'],
    );
  }
}
