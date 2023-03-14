import 'package:sqflite/sqflite.dart';
import 'package:stall/models/orders.dart';

class OrderDatabase {
  static final OrderDatabase instance = OrderDatabase._init();

  static Database? _database;

  OrderDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final realType = 'REAL NOT NULL';

    await db.execute('''
    CREATE TABLE $orderTable (
      ${OrderField.id} $idType,
      ${OrderField.name} $textType,
      ${OrderField.amount} $realType,
      ${OrderField.dish} $textType,
      ${OrderField.iscompleted} $boolType
    )
    ''');
  }

  Future<Order> create(Order order) async {
    final db = await instance.database;

    final id = await db.insert(orderTable, order.toJson());
    return order.copy(id: id);
  }

  Future readAll() async {
    final db = await instance.database;

    final result = await db.query(orderTable);
    return result.map((json) => Order.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      orderTable,
      where: '${OrderField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Order order) async {
    final db = await instance.database;

    return await db.update(
      orderTable,
      order.toJson(),
      where: '${OrderField.id} = ?',
      whereArgs: [order.id],
    );
  }

  Future Checkif() async {
    final db = await instance.database;

    final result =
        await db.rawQuery('SELECT * FROM $orderTable Where iscompleted = 1');
    return result.map((json) => Order.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
