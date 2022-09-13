class CategoryModel {
  late String name;
  late String image;
  CategoryModel(this.name, this.image);
  factory CategoryModel.fromJson(json) {
    return CategoryModel(json['name'],json['image']);
  }
}
