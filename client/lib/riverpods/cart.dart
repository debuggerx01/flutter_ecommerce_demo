import 'package:ecommerce_demo/apis/models/cart.dart' as cart_model;
import 'package:ecommerce_demo/riverpods/apis.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  FutureOr<List<cart_model.Cart>> build() async {
    return ref.read(apiProvider).cartList();
  }

  Future<void> updateCart({
    required int itemId,
    required int quantity,
  }) async {
    var resp = await ref.read(apiProvider).updateCart(
          itemId: itemId,
          quantity: quantity,
        );
    print(resp);
    ref.invalidateSelf();
  }
}
