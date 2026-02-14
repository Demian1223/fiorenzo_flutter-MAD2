import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mad2/features/products/models/product_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'products.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            price TEXT,
            stock INTEGER,
            image_url TEXT,
            gender TEXT,
            category_id INTEGER,
            category_name TEXT,
            brand_id INTEGER,
            brand_name TEXT,
            updated_at TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertOrReplaceProduct(ProductModel product) async {
    final db = await database;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertProducts(List<ProductModel> products) async {
    final db = await database;
    final batch = db.batch();
    for (var product in products) {
      batch.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<ProductModel>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  Future<List<ProductModel>> getProductsByGender(String gender) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'gender = ?',
      whereArgs: [gender],
    );
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  Future<void> clearProducts() async {
    final db = await database;
    await db.delete('products');
  }
}
