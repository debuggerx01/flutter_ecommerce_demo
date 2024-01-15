import 'package:ecommerce_demo/pages/cart.dart';
import 'package:ecommerce_demo/pages/me.dart';
import 'package:ecommerce_demo/pages/store.dart';
import 'package:ecommerce_demo/riverpods/runtime.dart';
import 'package:ecommerce_demo/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final homePages = SafeArea(
      child: IndexedStack(
        index: selectedIndex,
        children: const [
          StorePage(),
          CartPage(),
          MePage(),
        ],
      ),
    );

    return AdaptiveScaffold(
      selectedIndex: selectedIndex,
      onSelectedIndexChange: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      useDrawer: false,
      body: (context) {
        Future.microtask(() {
          ref.read(currentScreenPatternProvider.notifier).update(ScreenPatterns.desktop);
        });
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: context.containerBgColor,
          ),
          margin: const EdgeInsets.all(10),
          child: homePages,
        );
      },
      smallBody: (context) {
        Future.microtask(() {
          ref.read(currentScreenPatternProvider.notifier).update(ScreenPatterns.mobile);
        });
        return homePages;
      },
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.store_mall_directory_outlined),
          selectedIcon: Icon(
            Icons.store_mall_directory_rounded,
            color: Colors.orange,
          ),
          label: 'Store',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(
            Icons.shopping_cart_rounded,
            color: Colors.orange,
          ),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_3_outlined),
          selectedIcon: Icon(
            Icons.person_3_rounded,
            color: Colors.orange,
          ),
          label: 'Me',
        ),
      ],
    );
  }
}
