class CategoryTypeDTO {
  final String categoryName;

  CategoryTypeDTO({required this.categoryName});

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
    };
  }
}
