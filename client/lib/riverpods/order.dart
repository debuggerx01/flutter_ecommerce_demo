import 'package:ecommerce_demo/riverpods/apis.dart';
import 'package:ecommerce_demo/riverpods/cart.dart';
import 'package:ecommerce_demo/riverpods/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ecommerce_demo/apis/models/order.dart' as order_model;

part 'order.g.dart';

@riverpod
class Order extends _$Order {
  @override
  FutureOr<List<order_model.Order>> build() async {
    return ref.read(apiProvider).orderList();
  }

  Future<void> addOrder({
    required int itemId,
    required int quantity,
  }) async {
    var balanceLeft = await ref.read(apiProvider).addOrder(
          itemId: itemId,
          quantity: quantity,
        );
    ref.invalidateSelf();
    ref.invalidate(cartProvider);
    ref.read(userInfoProvider.notifier).updateBalance(balanceLeft);
  }
}
