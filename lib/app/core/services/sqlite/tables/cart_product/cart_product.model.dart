import 'dart:convert';

CartProduct cartProductFromJson(String str) {
  final jsonData = json.decode(str);
  return CartProduct.fromMap(jsonData);
}

String cartProductToJson(CartProduct data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class CartProduct {
  int productId;
  int cartId;
  int quantity;
  double price;
  String data;

  CartProduct({
    this.productId,
    this.cartId,
    this.quantity,
    this.price,
    this.data,
  });

  factory CartProduct.fromMap(Map<String, dynamic> json) => new CartProduct(
      productId: json["product_id"],
      cartId: json["cart_id"],
      quantity: json['quantity'],
      price: json['price'],
      data: json['data']);

  Map<String, dynamic> toMap() => {
        "product_id": productId,
        "cart_id": cartId,
        "quantity": quantity,
        "price": price,
        "data": data,
      };
}
