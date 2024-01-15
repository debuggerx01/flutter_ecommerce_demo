import 'dart:async';
import 'dart:convert';

import 'package:ecommerce_demo/apis/models/cart.dart';
import 'package:ecommerce_demo/apis/models/category.dart';
import 'package:ecommerce_demo/apis/models/collection.dart';
import 'package:ecommerce_demo/apis/models/item.dart';
import 'package:ecommerce_demo/apis/models/order.dart';
import 'package:ecommerce_demo/apis/models/user.dart';
import 'package:ecommerce_demo/riverpods/user.dart' show userIdProvider;
import 'package:http/http.dart' show get;

const baseUrl = 'ecommerce-api.debuggerx.com';

class Apis {
  final Function reader;

  Apis({required this.reader});

  Future<T> _get<T>(
    String path, {
    useUid = true,
    Map<String, String>? query,
  }) {
    int? uid;
    if (useUid) {
      uid = reader(userIdProvider);
    }
    var uri = Uri.https(
      baseUrl,
      path,
      {
        ...?query,
        if (uid != null) 'uid': uid.toString(),
      },
    );
    print(uri);
    return get(uri).then(
      (res) => json.decode(utf8.decode(res.bodyBytes)),
    );
  }

  Future<Map<String, dynamic>> _getJson(
    String path, {
    useUid = true,
    Map<String, String>? query,
  }) =>
      _get<Map<String, dynamic>>(path, useUid: useUid, query: query);

  Future<List<Map<String, dynamic>>> _getList(
    String path, {
    useUid = true,
    Map<String, String>? query,
  }) =>
      _get(path, useUid: useUid, query: query).then(
        (resp) => List<Map<String, dynamic>>.from(resp),
      );

  // 登录
  Future<int> login({required String mail}) => _getJson(
        'user/login',
        useUid: false,
        query: {
          'mail': mail,
        },
      ).then((resp) => resp['uid'] as int);

  // 用户信息
  Future<UserInfo> userInfo() => _getJson('user/info').catchError(
        (e) {
          reader(userIdProvider.notifier).clear();
        },
      ).then(UserInfo.fromJson);

  // 首页数据（分类信息和推荐列表）
  Future<(List<Category>?, List<Item>, bool)> homeData({int? lastItemId}) => _getJson(
        'home/index',
        useUid: false,
        query: {
          if (lastItemId != null) 'last_id': lastItemId.toString(),
        },
      ).then(
        (resp) => (
          (List<Map<String, dynamic>>.from(resp['categories'] ?? [])).map(Category.fromJson).toList(),
          (List<Map<String, dynamic>>.from(resp['recommends'])).map(Item.fromJson).toList(),
          resp['hasMore'] as bool,
        ),
      );

  /// 商品列表
  Future<(List<Item>, bool)> items({
    required int categoryId,
    int? lastItemId,
  }) =>
      _getJson(
        'item/index',
        useUid: false,
        query: {
          'category_id': categoryId.toString(),
          if (lastItemId != null) 'last_id': lastItemId.toString(),
        },
      ).then(
        (resp) => (
          (List<Map<String, dynamic>>.from(resp['items'])).map(Item.fromJson).toList(),
          resp['hasMore'] as bool,
        ),
      );

  /// 商品详情
  Future<Item> itemDetail({required int itemId}) => _getJson(
        'item/detail',
        useUid: false,
        query: {
          'item_id': itemId.toString(),
        },
      ).then(Item.fromJson);

  /// 购物车列表
  Future<List<Cart>> cartList() => _getList('cart/index').then((resp) => resp
      .map(
        (Cart.fromJson),
      )
      .toList());

  /// 更新购物车
  Future<String> updateCart({
    required int itemId,
    required int quantity,
  }) =>
      _get<String>('cart/update', query: {
        'item_id': itemId.toString(),
        'quantity': quantity.toString(),
      });

  /// 收藏夹列表
  Future<List<Collection>> collectionList() => _getList('collection/index').then((resp) => resp
      .map(
        Collection.fromJson,
      )
      .toList());

  /// 更新收藏夹
  Future<String> updateCollection({required int itemId}) => _get<String>('collection/update', query: {
        'item_id': itemId.toString(),
      });

  /// 订单列表
  Future<List<Order>> orderList() => _getList('order/index').then((resp) => resp
      .map(
        Order.fromJson,
      )
      .toList());

  /// 下单
  Future<int> addOrder({required int itemId, required int quantity}) => _getJson(
        'order/add',
        query: {
          'item_id': itemId.toString(),
          'quantity': quantity.toString(),
        },
      ).then((value) => value['balanceLeft'] as int);

  /// 充值
  Future<int> addBalance(int amount) =>
      _getJson('/user/add_balance', query: {'amount': amount.toString()}).then((value) {
        return value['newBalance'] as int;
      });
}
