import 'package:ecommerce_demo/riverpods/user.dart';
import 'package:ecommerce_demo/utils/constants.dart';
import 'package:ecommerce_demo/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 根据当前时间获取中文时间划分名称
String get cnTimeString => switch (DateTime.now().hour) {
      <= 3 => '深夜',
      <= 5 => '凌晨',
      <= 7 => '早上',
      <= 11 => '上午',
      <= 14 => '中午',
      <= 17 => '下午',
      <= 19 => '傍晚',
      _ => '晚上',
    };

showLoginDialog(WidgetRef ref) => SmartDialog.show(
      builder: (context) {
        final TextEditingController _ctl = TextEditingController();
        return SizedBox(
          width: 360,
          height: 360,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding * 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '请先登录',
                    style: context.t.textTheme.titleLarge,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: switch (context.t.brightness) {
                        Brightness.dark => context.t.colorScheme.onSurfaceVariant.withOpacity(0.1),
                        Brightness.light => context.t.colorScheme.secondaryContainer.withOpacity(0.5),
                      },
                    ),
                    child: TextField(
                      maxLines: 1,
                      controller: _ctl,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(defaultPadding),
                        hintText: '请输入邮箱',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var mail = _ctl.text.trim();
                      if (mail.indexOf('@') <= 0) {
                        SmartDialog.showToast('请输入合法的邮箱');
                        return;
                      }
                      ref.read(userIdProvider.notifier).login(mail).then((_) {
                        SmartDialog.dismiss();
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Text('登录'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
