import 'package:ecommerce_demo/riverpods/user.dart';
import 'package:ecommerce_demo/utils/constants.dart';
import 'package:ecommerce_demo/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
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
        final TextEditingController ctl = TextEditingController();
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
                      color: context.containerBgColor,
                    ),
                    child: TextField(
                      maxLines: 1,
                      controller: ctl,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(defaultPadding),
                        hintText: '请输入邮箱',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var mail = ctl.text.trim();
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

Future<int?> showQuantityInputDialog([unit = '数量']) => SmartDialog.show<int>(
      builder: (context) {
        final TextEditingController ctl = TextEditingController(text: '1');
        return SizedBox(
          width: 300,
          height: 280,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding * 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '请输入$unit',
                    style: context.t.textTheme.titleLarge,
                  ),
                  SizedBox(
                    width: 160,
                    child: Row(
                      children: [
                        InkWell(
                          child: const Icon(CupertinoIcons.minus_circle),
                          onTap: () {
                            var value = int.tryParse(ctl.text);
                            if (value != null && value > 1) {
                              ctl.text = (value - 1).toString();
                            }
                          },
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: context.containerBgColor,
                              ),
                              child: TextField(
                                maxLines: 1,
                                controller: ctl,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.end,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(defaultPadding),
                                  hintText: '请输入$unit',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            var value = int.tryParse(ctl.text);
                            if (value != null && value < 999) {
                              ctl.text = (value + 1).toString();
                            }
                          },
                          child: const Icon(CupertinoIcons.add_circled),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          SmartDialog.dismiss();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Text('取消'),
                        ),
                      ),
                      FilledButton(
                        onPressed: () {
                          var quantityStr = ctl.text.trim();
                          var quantity = int.tryParse(quantityStr);
                          if (quantity == null || quantity < 0) {
                            SmartDialog.showToast('请输入正确的$unit');
                            return;
                          }
                          SmartDialog.dismiss<int>(result: quantity);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Text('确定'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

Future<bool?> showConfirmDialog(String msg) => SmartDialog.show<bool>(
      builder: (context) {
        return SizedBox(
          width: 300,
          height: 180,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding * 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    msg,
                    style: context.t.textTheme.titleLarge,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          SmartDialog.dismiss();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Text('取消'),
                        ),
                      ),
                      FilledButton(
                        onPressed: () {
                          SmartDialog.dismiss<bool>(result: true);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Text('确定'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
