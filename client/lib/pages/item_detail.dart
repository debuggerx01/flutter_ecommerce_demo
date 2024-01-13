import 'package:ecommerce_demo/riverpods/item.dart';
import 'package:ecommerce_demo/utils/constants.dart';
import 'package:ecommerce_demo/utils/extensions.dart';
import 'package:ecommerce_demo/widgets/item_footer_bar.dart';
import 'package:ecommerce_demo/widgets/oops_widget.dart';
import 'package:ecommerce_demo/widgets/web_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemDetailPage extends ConsumerWidget {
  final int itemId;
  final String title;

  const ItemDetailPage({
    super.key,
    required this.itemId,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncValue = ref.watch(ItemDetailProvider(itemId));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: switch (asyncValue) {
        AsyncError() => oopsWidget,
        AsyncData(:final value) => SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    Flexible(
                      child: ListView(
                        children: [
                          WebImage(url: value.cover),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: defaultPadding * 3),
                              child: Text(
                                '销量：${value.sales}',
                                style: context.t.textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(defaultPadding * 2),
                            child: Text(
                              value.content ?? '',
                              style: context.t.textTheme.bodyLarge?.copyWith(height: 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ItemFooterBar(itemId: value.id),
                  ],
                ),
              ),
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
