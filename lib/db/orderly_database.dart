import 'package:flutter/material.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class OrderlyDatabase {
  final String tableCart='cartTable';
  final String tableProduct='productTable';
  final String tableProducer='producerTable';
  //for home producer
  final String columnProducerId='producer_id';
  final String columnProducerName='producer_name';
  final String columnProducerImage='producer_image_url';
  final String columnProducerIcon='producer_icon_url';


  //for home-prod data
  final String columnProducerHomeId='producerid';
  final String columnTruckName='truck_name';
  final String columnTruckNum='truck_number';
  final String columnStatus='display_status';
  final String columnProdImage='product_image';
  final String columnProdqty='product_qty';

  //for shopping cart
  final String columnCartId='cart_id';
  final String columnUserId='user_id';
  final String columnProductId='product_id';
  final String columnRate='rate_per_hour';
  final String columnQty='qty';
  final String columnProdName='product_name';
  final String columnProdDesc='product_desc';
  final String columnImage='img_paths';

  static Database _db;
  static final OrderlyDatabase database = OrderlyDatabase._();

  OrderlyDatabase._();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    print("db_location:"+documentDirectory.path);
    String path = join(documentDirectory.path, 'orderly.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    //for producer list
    await db
        .execute('CREATE TABLE $tableProducer ($columnProducerId INTEGER PRIMARY KEY, $columnProducerName TEXT, $columnProducerImage TEXT,'
        '$columnProducerIcon TEXT)');

    // for product list
    await db
        .execute('CREATE TABLE $tableProduct ($columnProductId INTEGER PRIMARY KEY, $columnProducerHomeId INTEGER,$columnProdqty INTEGER,'
        '$columnTruckName INTEGER,$columnTruckNum Text,$columnRate TEXT,$columnStatus INTEGER,$columnProdName TEXT,$columnProdDesc TEXT,'
        '$columnProdImage TEXT)');

    // for cartList
    await db
        .execute('CREATE TABLE $tableCart ($columnCartId INTEGER PRIMARY KEY, $columnUserId TEXT,'
        '$columnProducerId INTEGER, $columnProductId INTEGER,'
        '$columnRate INTEGER, $columnQty INTEGER, $columnProdName TEXT, $columnProdDesc TEXT,$columnImage TEXT)');
  }

  //for home page
  Future<Product> addProduct(Product prod) async{
    try{
      await deleteAllProductList();
      var dbClient=await db;
      print("Product:-"+prod.toJson().toString());

      prod.productId= await dbClient.insert(tableProduct, prod.toJson());
      return prod;

    }catch(e){
      print(e);
    }


  }

  // Delete all productLists
  Future<int> deleteAllProductList() async {
    final dbClient = await db;
    final res = await dbClient.rawDelete('DELETE FROM $tableProduct');

    return res;
  }

  Future<List<Product>> getProdList() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableProduct, columns: ['$columnProductId','$columnProducerHomeId','$columnProdqty', '$columnRate',
      '$columnProdName','$columnProdDesc','$columnProdImage','$columnTruckName','$columnTruckNum','$columnStatus']);
    List<Product> prodList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        prodList.add(Product.fromJson(maps[i]));
      }
    }
    return prodList;
  }

  // Future<int> getProductPerId(Product product) async {
  //   var dbClient = await db;
  //   return await dbClient.insert(
  //
  //   );
  // }

  //for producer
  Future<Producer> addProducer(Producer producer) async{
    try{
      await deleteAllProducerList();
      var dbClient=await db;
      print("Producer:-"+producer.toJson().toString());
      producer.producerId= await dbClient.insert(tableProducer, producer.toJson());
      return producer;

    }catch(e){
      print(e);
    }


  }

  Future<int> deleteAllProducerList() async {
    final dbClient = await db;
    final res = await dbClient.rawDelete('DELETE FROM $tableProducer');

    return res;
  }

  Future<List<Producer>> getProducerList() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableProducer, columns: ['$columnProducerId','$columnProducerName','$columnProducerImage',
      '$columnProducerIcon']);
    List<Producer> producerList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        producerList.add(Producer.fromJson(maps[i]));
      }
    }
    return producerList;
  }

  //for cart
  Future<Cart> add(Cart cart) async {
    var dbClient = await db;
    cart.id = await dbClient.insert(tableCart, Cart.toJson(cart));
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableCart, columns: ['$columnCartId','$columnUserId','$columnProducerId', '$columnProductId','$columnRate','$columnQty',
      '$columnProdName','$columnProdDesc','$columnProdImage']);
    List<Cart> cartList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        cartList.add(Cart.fromJson(maps[i]));
      }
    }
    return cartList;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      tableCart,
      where: '$columnCartId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Cart cart) async {
    var dbClient = await db;
    return await dbClient.update(
      tableCart,
      Cart.toJson(cart),
      where: '$columnCartId = ?',
      whereArgs: [cart.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
