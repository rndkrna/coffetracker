import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import '../models/transaction.dart';
import '../models/coffee_shop.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('coffee_budget.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        coffeeName TEXT NOT NULL,
        price INTEGER NOT NULL,
        date TEXT NOT NULL,
        location TEXT,
        note TEXT,
        category TEXT DEFAULT 'Lainnya',
        createdAt TEXT NOT NULL,
        locationLat REAL,
        locationLng REAL,
        locationSource TEXT,
        coffeeshopId TEXT,
        source TEXT,
        transactionTime TEXT
      )
    ''');

    await _createCoffeeShopTables(db);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createCoffeeShopTables(db);
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE transactions ADD COLUMN locationLat REAL');
      await db.execute('ALTER TABLE transactions ADD COLUMN locationLng REAL');
      await db.execute('ALTER TABLE transactions ADD COLUMN locationSource TEXT');
      await db.execute('ALTER TABLE transactions ADD COLUMN coffeeshopId TEXT');
      await db.execute('ALTER TABLE transactions ADD COLUMN source TEXT');
      await db.execute('ALTER TABLE transactions ADD COLUMN transactionTime TEXT');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE menu_items ADD COLUMN category TEXT DEFAULT "Coffee"');
      await db.execute('ALTER TABLE menu_items ADD COLUMN description TEXT DEFAULT ""');
      await db.execute('ALTER TABLE menu_items ADD COLUMN temperature TEXT DEFAULT "Both"');
      await db.execute('ALTER TABLE menu_items ADD COLUMN strengthLevel INTEGER DEFAULT 3');
      await db.execute('ALTER TABLE menu_items ADD COLUMN sweetnessLevel INTEGER DEFAULT 3');
      await db.execute('ALTER TABLE menu_items ADD COLUMN milkTypes TEXT DEFAULT "[]"');
      await db.execute('ALTER TABLE menu_items ADD COLUMN flavorTags TEXT DEFAULT "[]"');
      await db.execute('ALTER TABLE menu_items ADD COLUMN caffeineLevel TEXT DEFAULT "Medium"');
      await db.execute('ALTER TABLE menu_items ADD COLUMN dietaryTags TEXT DEFAULT "[]"');
      await db.execute('ALTER TABLE menu_items ADD COLUMN imageUrl TEXT DEFAULT ""');
      await db.execute('ALTER TABLE menu_items ADD COLUMN isActive INTEGER DEFAULT 1');
      await db.execute('ALTER TABLE menu_items ADD COLUMN updatedAt TEXT DEFAULT ""');
    }
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE coffee_shops ADD COLUMN latitude REAL');
      await db.execute('ALTER TABLE coffee_shops ADD COLUMN longitude REAL');
    }
  }

  Future _createCoffeeShopTables(Database db) async {
    await db.execute('''
      CREATE TABLE coffee_shops (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        rating REAL NOT NULL,
        vibes TEXT NOT NULL,
        latitude REAL,
        longitude REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE menu_items (
        id TEXT PRIMARY KEY,
        shopId TEXT NOT NULL,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        category TEXT DEFAULT 'Coffee',
        description TEXT DEFAULT '',
        temperature TEXT DEFAULT 'Both',
        strengthLevel INTEGER DEFAULT 3,
        sweetnessLevel INTEGER DEFAULT 3,
        milkTypes TEXT DEFAULT '[]',
        flavorTags TEXT DEFAULT '[]',
        caffeineLevel TEXT DEFAULT 'Medium',
        dietaryTags TEXT DEFAULT '[]',
        imageUrl TEXT DEFAULT '',
        isActive INTEGER DEFAULT 1,
        updatedAt TEXT DEFAULT '',
        FOREIGN KEY (shopId) REFERENCES coffee_shops (id) ON DELETE CASCADE
      )
    ''');
  }

  // --- Transactions ---
  // (Existing methods)

  Future<int> insertTransaction(CoffeeTransaction t) async {
    final db = await database;
    return await db.insert('transactions', t.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateTransaction(CoffeeTransaction t) async {
    final db = await database;
    return await db.update('transactions', t.toMap(),
        where: 'id = ?', whereArgs: [t.id]);
  }

  Future<int> deleteTransaction(String id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<CoffeeTransaction>> getAllTransactions() async {
    final db = await database;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((map) => CoffeeTransaction.fromMap(map)).toList();
  }

  Future<List<CoffeeTransaction>> getTransactionsByDateRange(
      DateTime start, DateTime end) async {
    final db = await database;
    final result = await db.query('transactions',
        where: 'date >= ? AND date <= ?',
        whereArgs: [start.toIso8601String(), end.toIso8601String()],
        orderBy: 'date DESC');
    return result.map((map) => CoffeeTransaction.fromMap(map)).toList();
  }

  // --- Coffee Shops ---
  Future<void> insertCoffeeShop(CoffeeShop shop) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('coffee_shops', shop.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      
      // Delete existing menu items and re-insert
      await txn.delete('menu_items', where: 'shopId = ?', whereArgs: [shop.id]);
      
      for (var item in shop.menu) {
        await txn.insert('menu_items', item.toMap(parentShopId: shop.id));
      }
    });
  }

  Future<List<CoffeeShop>> getAllCoffeeShops() async {
    final db = await database;
    final shopsMap = await db.query('coffee_shops');
    
    List<CoffeeShop> shops = [];
    for (var shopMap in shopsMap) {
      final menuMap = await db.query('menu_items', where: 'shopId = ?', whereArgs: [shopMap['id']]);
      final menu = menuMap.map((m) => MenuItem.fromMap(m)).toList();
      shops.add(CoffeeShop.fromMap(shopMap, menu));
    }
    return shops;
  }

  Future<void> deleteCoffeeShop(String id) async {
    final db = await database;
    await db.delete('coffee_shops', where: 'id = ?', whereArgs: [id]);
    await db.delete('menu_items', where: 'shopId = ?', whereArgs: [id]);
  }
}
