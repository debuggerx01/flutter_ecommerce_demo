import 'package:ecommerce_demo/riverpods/user.dart';
import 'package:ecommerce_demo/utils/constants.dart';
import 'package:ecommerce_demo/utils/extensions.dart';
import 'package:ecommerce_demo/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';

class WelcomeBanner extends ConsumerWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncValue = ref.watch(userInfoProvider);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: switch (asyncValue) {
          AsyncData(:final value) => Text(
              '$cnTimeString好，${value.mail.nameFromMail}！',
              style: context.t.textTheme.titleLarge,
            ),
          AsyncError() => Text(
              '尊敬的游客，$cnTimeString好！',
              style: context.t.textTheme.titleLarge,
            ),
          _ => const SkeletonLine(),
        },
      ),
    );
  }
}
