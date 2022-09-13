class CartItemModel {
 late int id;
 late int quantity;
 late Product product;

  CartItemModel(this.id, this.quantity, this.product);

 factory CartItemModel.fromJson(Map<String, dynamic> json) {

  return CartItemModel(json['id'], json['quantity'],   Product.fromJson(json['product']) );
  }


}

class Product {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late int discount;
  late String image;
  late String name;
  late String description;
  late List<String> images;
  late bool inFavorites;
  late bool inCart;

  Product(this.id, this.price, this.oldPrice, this.discount, this.image,
      this.name, this.description, this.images, this.inFavorites, this.inCart);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        json['id'],
           json['price'],
        json['old_price'],
        json['discount'],
        json['image'],
        json['name'],
        json['description'],
        json['images'].cast<String>(),
        json['in_favorites'],
        json['in_cart']);
  }
}
