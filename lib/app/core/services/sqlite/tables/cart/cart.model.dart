import 'dart:convert';

Cart cartFromJson(String str) {
  final jsonData = json.decode(str);
  return Cart.fromMap(jsonData);
}

String cartToJson(Cart data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Cart {
  int id;
  String description;

  Cart({this.id, this.description});

  factory Cart.fromMap(Map<String, dynamic> json) => new Cart(
        id: json["id"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
      };
}
