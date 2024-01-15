import 'package:ecommerce_demo/apis/models/category.dart';
import 'package:ecommerce_demo/riverpods/home_data.dart';
import 'package:ecommerce_demo/widgets/item_list.dart';
import 'package:ecommerce_demo/widgets/oops_widget.dart';
import 'package:ecommerce_demo/widgets/welcome_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorePage extends ConsumerWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var homeData = ref.watch(homeDataProvider);
    return Column(
      children: [
        const WelcomeBanner(),
        Flexible(
          child: switch (homeData) {
            AsyncData(:final value) => DefaultTabController(
                length: value.$1!.length + 1,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [const Category(id: 0, title: '推荐'), ...?value.$1]
                          .map(
                            (c) => Tab(
                              text: c.title,
                            ),
                          )
                          .toList(),
                      isScrollable: true,
                    ),
                    Flexible(
                      child: TabBarView(
                        children: [
                          const ItemList(0),
                          ...?value.$1?.map((c) => ItemList(c.id)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            AsyncError() => oopsWidget,
            _ => const CircularProgressIndicator(),
          },
        ),
      ],
    );
  }
}
