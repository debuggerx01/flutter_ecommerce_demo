import 'package:ecommerce_demo/riverpods/cart.dart';
import 'package:ecommerce_demo/riverpods/user.dart';
import 'package:ecommerce_demo/utils/constants.dart';
import 'package:ecommerce_demo/utils/extensions.dart';
import 'package:ecommerce_demo/utils/utils.dart';
import 'package:ecommerce_demo/widgets/item_list.dart';
import 'package:ecommerce_demo/widgets/oops_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            '购物车',
            style: context.t.textTheme.titleLarge,
          ),
        ),
        Flexible(
          child: ref.watch(userIdProvider) == null
              ? Center(
                  child: FilledButton(
                    onPressed: () {
                      showLoginDialog(ref);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Text(
                        '请先登录',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                )
              : Builder(builder: (context) {
                  var asyncValue = ref.watch(cartProvider);
                  return switch (asyncValue) {
                    AsyncData(:final value) => ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) => ItemTile(
                          data: ItemTileData.fromCart(value[index]),
                          onRemoveItem: (itemId) => ref.read(cartProvider.notifier).updateCart(
                                itemId: itemId,
                                quantity: 0,
                              ),
                        ),
                      ),
                    AsyncError() => oopsWidget,
                    _ => const Center(
                        child: CircularProgressIndicator(),
                      ),
                  };
                }),
        ),
      ],
    );
  }
}
