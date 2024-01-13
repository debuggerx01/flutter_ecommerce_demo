import 'package:ecommerce_demo/riverpods/user.dart';
import 'package:ecommerce_demo/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userinfo = ref.watch(userInfoProvider);
    return Column(
      children: [
        Text(userinfo.value?.mail.nameFromMail ?? ''),
      ],
    );
  }
}
