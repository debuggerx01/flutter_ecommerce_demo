import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_demo/apis/models/item.dart';
import 'package:ecommerce_demo/pages/item_detail.dart';
import 'package:ecommerce_demo/riverpods/home_data.dart';
import 'package:ecommerce_demo/riverpods/item.dart';
import 'package:ecommerce_demo/utils/constants.dart';
import 'package:ecommerce_demo/utils/extensions.dart';
import 'package:ecommerce_demo/widgets/oops_widget.dart';
import 'package:ecommerce_demo/widgets/web_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            childAspectRatio: 1.13,
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
