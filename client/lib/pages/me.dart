import 'package:ecommerce_demo/pages/collections.dart';
import 'package:ecommerce_demo/pages/orders.dart';
import 'package:ecommerce_demo/riverpods/apis.dart';
import 'package:ecommerce_demo/riverpods/user.dart';
import 'package:ecommerce_demo/utils/constants.dart';
import 'package:ecommerce_demo/utils/extensions.dart';
import 'package:ecommerce_demo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userinfo = ref.watch(userInfoProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding * 2),
          child: Center(
            child: Column(
              children: [
                Text(
                  userinfo.value?.mail.nameFromMail ?? '',
                  style: context.t.textTheme.displayMedium,
                ),
                const SizedBox(height: defaultPadding),
                if (ref.read(userIdProvider) != null)
                  Text(
                    '余额：￥${(userinfo.value?.balance ?? 0) / 100}',
                    style: context.t.textTheme.titleLarge,
                  ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding * 2),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  if (ref.read(userIdProvider) == null) {
                    showLoginDialog(ref);
                    return;
                  }
                  showQuantityInputDialog('金额').then((value) {
                    if (value != null) {
                      ref.read(apiProvider).addBalance(value * 100).then((newBalance) {
                        ref.read(userInfoProvider.notifier).updateBalance(newBalance);
                        SmartDialog.showToast('充值成功！');
                      });
                    }
                  });
                },
                child: Card(
                  margin: const EdgeInsets.all(defaultPadding),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Text(
                        '模拟充值',
                        textAlign: TextAlign.center,
                        style: context.t.textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (ref.read(userIdProvider) == null) {
                    showLoginDialog(ref);
                    return;
                  }
                  context.go(
                    builder: (context) => const CollectionsPage(),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(defaultPadding),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Text(
                        '收藏夹',
                        textAlign: TextAlign.center,
                        style: context.t.textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (ref.read(userIdProvider) == null) {
                    showLoginDialog(ref);
                    return;
                  }
                  context.go(
                    builder: (context) => const OrdersPage(),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(defaultPadding),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Text(
                        '我的订单',
                        textAlign: TextAlign.center,
                        style: context.t.textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
              if (ref.read(userIdProvider) != null)
                InkWell(
                  onTap: () {
                    ref.read(userIdProvider.notifier).clear();
                  },
                  child: Card(
                    margin: const EdgeInsets.all(defaultPadding),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Text(
                          '退出登录',
                          textAlign: TextAlign.center,
                          style: context.t.textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                )
              else
                InkWell(
                  onTap: () {
                    showLoginDialog(ref);
                  },
                  child: Card(
                    margin: const EdgeInsets.all(defaultPadding),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Text(
                          '登录',
                          textAlign: TextAlign.center,
                          style: context.t.textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
