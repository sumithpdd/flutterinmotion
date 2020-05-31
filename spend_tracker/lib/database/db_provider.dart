import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spend_tracker/models/account.dart';
import 'package:spend_tracker/models/balance.dart';
import 'package:spend_tracker/models/item.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  Database _database;
  Future<Database> get database async {
    if (_database == null) {
      _database = await _initialize();
    }
    return _database;
  }

  void dispose() {
    _database?.close();
    _database = null;
  }

  Future<Database> _initialize() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, 'spend_tracker.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onOpen: (db) {
        print('Database Open');
      },
      onCreate: _onCreate,
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Account ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "codePoint INTEGER,"
        "balance REAL"
        ")");
    await db.execute("CREATE TABLE ItemType ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "codePoint INTEGER"
        ")");
    await db.execute("CREATE TABLE Item ("
        "id INTEGER PRIMARY KEY,"
        "description TEXT,"
        "typeId INTEGER,"
        "amount  REAL,"
        "date TEXT,"
        "isDeposit INTEGER,"
        "accountId INTEGER,"
        "FOREIGN KEY(typeId) REFERENCES Type(id),"
        "FOREIGN KEY(accountId) REFERENCES account(id)"
        ")");

    await db.execute("INSERT INTO Account (id, name, codePoint, balance)"
        "values(1,'Checking', 59471, 0.00)");
    await db.execute("INSERT INTO Account (id, name, codePoint, balance)"
        "values(2,'Saving', 59471, 0.00)");

    await db.execute("INSERT INTO ItemType (id, name, codePoint)"
        "values(1,'Paycheck', 59471 )");
    await db.execute("INSERT INTO ItemType (id, name, codePoint)"
        "values(2,'ATM Withdraw', 59471)");
  }

  Future<int> createAccount(Account account) async {
    final db = await database;
    return await db.insert('Account', account.toMap());
  }

  Future<int> updateAccount(Account account) async {
    final db = await database;
    return await db.update('Account', account.toMap(),
        where: 'id = ?', whereArgs: [account.id]);
  }

  Future<List<Account>> getAllAccounts() async {
    final db = await database;
    var res = await db.query('Account');
    List<Account> list =
        res.isNotEmpty ? res.map((e) => Account.fromMap(e)).toList() : [];
    return list;
  }

  Future<int> createItemType(ItemType itemType) async {
    final db = await database;
    return await db.insert('itemType', itemType.toMap());
  }

  Future<int> updateItemType(ItemType itemType) async {
    final db = await database;
    return await db.update('itemType', itemType.toMap(),
        where: 'id = ?', whereArgs: [itemType.id]);
  }

  Future<List<ItemType>> getAllTypes() async {
    final db = await database;
    var res = await db.query('itemType');
    List<ItemType> list =
        res.isNotEmpty ? res.map((e) => ItemType.fromMap(e)).toList() : [];
    return list;
  }

  Future  createItem(Item item) async {
    final db = await database;
    var accounts =
        await db.query('Account', where: "id = ?", whereArgs: [item.accountId]);
    var account = Account.fromMap(accounts[0]);
    var balance = account.balance;
    if (item.isDeposit)
      balance += item.amount;
    else
      balance -= item.amount;
    await db.transaction((txn) async {
      await txn.rawUpdate('UPDATE Account SET balance =${balance.toString()} ' +
          'where id = ${account.id.toString()}');
      await txn.insert('Item', item.toMap());
    });
  }

  Future<List<Item>> getAllItems() async {
    final db = await database;
    var res = await db.query('Item');
    List<Item> list =
        res.isNotEmpty ? res.map((e) => Item.fromMap(e)).toList() : [];
    return list;
  }

  Future deleteItem(Item item) async {
    final db = await database;
    var accounts =
        await db.query('Account', where: "id = ?", whereArgs: [item.accountId]);
    var account = Account.fromMap(accounts[0]);
    var balance = account.balance;
    if (item.isDeposit)
      balance -= item.amount;
    else
      balance += item.amount;
    await db.transaction((txn) async {
      await txn.rawUpdate('UPDATE Account SET balance =${balance.toString()} ' +
          'where id = ${account.id.toString()}');
      await txn.delete('Item', where: "id = ?", whereArgs: [item.id]);
    });
  }

  Future<Balance> getBalance() async {
    final items = await getAllItems();
    double withdraw = 0;
    double deposit = 0;

    items.forEach((item) {
      if (item.isDeposit)
        deposit += item.amount;
      else
        withdraw += item.amount;
    });
    return Balance(
      deposit: deposit,
      withdraw: withdraw,
      total: deposit - withdraw,
    );
  }
}
