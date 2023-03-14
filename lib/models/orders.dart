const String orderTable = "orders";

class OrderField {
  static const List<String> values = [id, name, amount, dish, iscompleted];

  static const String id = "_id";
  static const String name = "name";
  static const String amount = "Amount";
  static const String dish = "dish";
  static const String iscompleted = "iscompleted";
}

class Order {
  final int? id;
  final String name;
  final double amount;
  final String dish;
  int iscompleted;

  Order({
    this.id,
    required this.name,
    required this.amount,
    required this.dish,
    this.iscompleted = 0,
  });

  Map<String, Object?> toJson() => {
        OrderField.id: id,
        OrderField.name: name,
        OrderField.amount.toString(): amount,
        OrderField.dish: dish,
        OrderField.iscompleted: iscompleted,
      };

  static Order fromJson(Map<dynamic, Object?> json) => Order(
        id: json[OrderField.id] as int?,
        name: json[OrderField.name] as String,
        amount: json[OrderField.amount] as double,
        dish: json[OrderField.dish] as String,
        iscompleted: json[OrderField.iscompleted] as int,
      );

  Order copy({
    int? id,
    String? name,
    double? amount,
    String? dish,
    bool? iscompleted,
  }) =>
      Order(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        dish: dish ?? this.dish,
        iscompleted: iscompleted == 0 ? this.iscompleted : 2,
      );
}
