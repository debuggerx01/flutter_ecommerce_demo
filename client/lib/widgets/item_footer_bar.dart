import 'package:ecommerce_demo/riverpods/cart.dart';
import 'package:ecommerce_demo/riverpods/collection.dart';
import 'package:ecommerce_demo/riverpods/order.dart';
import 'package:ecommerce_demo/riverpods/user.dart';
import 'package:ecommerce_demo/utils/constants.dart';
import 'package:ecommerce_demo/utils/extensions.dart';
import 'package:ecommerce_demo/utils/utils.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ItemFooterBar extends ConsumerWidget {
  final int itemId;
  final int itemPrice;

  const ItemFooterBar({
    super.key,
    required this.itemId,
    required this.itemPrice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var collection = ref.watch(collectionProvider);
    var collected = collection.hasValue && collection.value?.where((c) => c.itemId == itemId).isNotEmpty == true;

    var cart = ref.watch(cartProvider);
    var cartSize = cart.hasValue ? cart.value?.length ?? 0 : 0;

    var uid = ref.watch(userIdProvider);
    var loggedIn = uid != null && uid > 0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: context.containerBgColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: defaultPadding,
          horizontal: defaultPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                if (!loggedIn) {
                  showLoginDialog(ref);
                  return;
                }

                ref.read(collectionProvider.notifier).updateCollection(
                      itemId: itemId,
                    );
              },
              child: Column(
                children: [
                  Icon(
                    collected ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    color: Colors.red,
                  ),
                  const Text('收藏'),
                ],
              ),
            ),
            Badge(
              label: Text(cartSize.toString()),
              child: ElevatedButton(
                onPressed: () {
                  if (!loggedIn) {
                    showLoginDialog(ref);
                    return;
                  }
                  showQuantityInputDialog().then(
                    (quantity) {
                      if (quantity == null) return;
                      ref.read(cartProvider.notifier).updateCart(
                            itemId: itemId,
                            quantity: quantity,
                          );
                    },
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(defaultPadding / 2),
                  child: Row(
                    children: [
                      Icon(Icons.add_shopping_cart),
                      Text('加入购物车'),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (!loggedIn) {
                  showLoginDialog(ref);
                  return;
                }
                var userInfo = ref.read(userInfoProvider).value;
                showQuantityInputDialog().then(
                  (quantity) {
                    if (quantity == null) return;
                    if (quantity * itemPrice > (userInfo?.balance ?? 0)) {
                      SmartDialog.showToast('余额不足，请先充值！');
                    }
                    ref.read(orderProvider.notifier).addOrder(
                          itemId: itemId,
                          quantity: quantity,
                        );
                  },
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(defaultPadding / 2),
                child: Row(
                  children: [
                    Icon(Icons.event_busy),
                    Text('立即购买'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
