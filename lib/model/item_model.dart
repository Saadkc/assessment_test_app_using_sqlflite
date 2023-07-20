class Item {
  final int? id;
  final String itemName;
  final int itemPrice;
  final int createdAt = DateTime.now().millisecondsSinceEpoch;

  Item({this.id, required this.itemName, required this.itemPrice});

  factory Item.fromJson(Map<String, dynamic> json) =>
      Item(id: json['id'],itemName: json['itemName'], itemPrice: json['itemPrice']);

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "itemPrice": itemPrice,
        "created_at": createdAt,
      };
}
