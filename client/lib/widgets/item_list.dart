import 'package:ecommerce_demo/apis/models/cart.dart';
import 'package:ecommerce_demo/apis/models/collection.dart';
import 'package:ecommerce_demo/apis/models/item.dart';
import 'package:ecommerce_demo/apis/models/order.dart';
import 'package:ecommerce_demo/pages/item_detail.dart';
import 'package:ecommerce_demo/riverpods/home_data.dart';
import 'package:ecommerce_demo/riverpods/item.dart';
import 'package:ecommerce_demo/utils/constants.dart';
import 'package:ecommerce_demo/utils/extensions.dart';
import 'package:ecommerce_demo/utils/utils.dart';
import 'package:ecommerce_demo/widgets/oops_widget.dart';
import 'package:ecommerce_demo/widgets/web_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ItemList extends ConsumerWidget {
  final int categoryId;

  const ItemList(this.categoryId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue asyncValue;
    if (categoryId == 0) {
      asyncValue = ref.watch(homeDataProvider);
    } else {
      asyncValue = ref.watch(ItemsDataProvider(categoryId));
    }

    if (asyncValue.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (asyncValue.hasError) {
      return oopsWidget;
    }

    List<Item> items;
    bool hasMore;

    if (categoryId == 0) {
      (_, items, hasMore) = asyncValue.value;
    } else {
      (items, hasMore) = asyncValue.value;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 240,
            childAspectRatio: 1.1,
            mainAxisSpacing: defaultPadding,
            crossAxisSpacing: defaultPadding,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (index == items.length - 1 && hasMore) {
              Future.microtask(() {
                (categoryId == 0
                        ? ref.read(homeDataProvider.notifier).loadMore
                        : ref.read(ItemsDataProvider(categoryId).notifier).loadMore)
                    .call();
              });
            }
            return ItemCard(item: items[index]);
          },
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(
          builder: (context) => ItemDetailPage(
            itemId: item.id,
            title: item.title,
          ),
        );
      },
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultPadding),
            ),
            clipBehavior: Clip.antiAlias,
            child: WebImage(
              url: item.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: defaultPadding / 2,
              horizontal: defaultPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.t.textTheme.bodyLarge,
                  ),
                ),
                Text(
                  item.price.priceStrWithUnit,
                  style: context.t.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemTileData {
  final int id;
  final int uid;
  final int itemId;
  final String itemTitle;
  final int itemPrice;
  final String itemCover;
  final int time;
  final int? quantity;
  final int? amount;

  const ItemTileData({
    required this.id,
    required this.uid,
    required this.itemId,
    required this.itemTitle,
    required this.itemPrice,
    required this.itemCover,
    required this.time,
    this.quantity,
    this.amount,
  });

  factory ItemTileData.fromOrder(Order obj) => ItemTileData(
        id: obj.id,
        uid: obj.uid,
        itemId: obj.itemId,
        itemTitle: obj.itemTitle,
        itemPrice: obj.itemPrice,
        itemCover: obj.itemCover,
        time: obj.createdAt,
        quantity: obj.quantity,
        amount: obj.amount,
      );

  factory ItemTileData.fromCart(Cart obj) => ItemTileData(
        id: obj.id,
        uid: obj.uid,
        itemId: obj.itemId,
        itemTitle: obj.title,
        itemPrice: obj.price,
        itemCover: obj.cover,
        time: obj.updatedAt,
        quantity: obj.quantity,
      );

  factory ItemTileData.fromCollection(Collection obj) => ItemTileData(
        id: obj.id,
        uid: obj.uid,
        itemId: obj.itemId,
        itemTitle: obj.title,
        itemPrice: obj.price,
        itemCover: obj.cover,
        time: obj.updatedAt,
      );
}

typedef OnRemoveItem = void Function(int itemId);

class ItemTile extends StatelessWidget {
  final ItemTileData data;
  final OnRemoveItem? onRemoveItem;

  const ItemTile({
    super.key,
    required this.data,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(
          builder: (context) => ItemDetailPage(
            itemId: data.itemId,
            title: data.itemTitle,
          ),
        );
      },
      onLongPress: onRemoveItem == null
          ? null
          : () {
              showConfirmDialog('确认移除？').then(
                (value) {
                  if (value == true) onRemoveItem?.call(data.itemId);
                },
              );
            },
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(defaultPadding * 2),
              child: WebImage(
                url: data.itemCover,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(data.itemTitle),
                        ),
                        if (data.quantity != null) Text('x${data.quantity}'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding / 2),
                      child: Text(
                        data.itemPrice.priceStrWithUnit,
                      ),
                    ),
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Text(DateTime.fromMillisecondsSinceEpoch(data.time * 1000).cnString),
                        const SizedBox(width: defaultPadding),
                        if (data.amount != null) Text('总价：${data.amount?.priceStrWithUnit}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
