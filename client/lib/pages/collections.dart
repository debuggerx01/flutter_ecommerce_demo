import 'package:ecommerce_demo/riverpods/collection.dart';
import 'package:ecommerce_demo/widgets/item_list.dart';
import 'package:ecommerce_demo/widgets/oops_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionsPage extends ConsumerWidget {
  const CollectionsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncValue = ref.watch(collectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('收藏夹'),
      ),
      body: switch (asyncValue) {
        AsyncError() => oopsWidget,
        AsyncData(:final value) => SafeArea(
            child: ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) => ItemTile(
                data: ItemTileData.fromCollection(value[index]),
                onRemoveItem: null,
              ),
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
