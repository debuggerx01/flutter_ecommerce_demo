# Online demo
[E-commerce demo](https://www.debuggerx.com/flutter_ecommerce_demo/)

# 功能操作提示

## 登录注册

- demo的登录注册是模拟状态，输入任意合法的邮箱即可，无需密码。
- 第一此使用的邮箱会自动创建账号。
- 取邮箱的用户名部分作为昵称在demo中显示

## 购物车和收藏夹

- 点击商品详情页的爱心按钮和加入购物车按钮即可实现相关功能
- 由于是利用CloudFlare的Workers搭建的后端服务器，国内网络环境下操作可能存在延迟
- 在收藏夹和购物车列表页面，单击进入商品详情，长按可以删除
- 收藏商品成功会点亮爱心图标，加入购物车成功会更新按钮角标的数字

## 下单和充值

- 下单后会自动清除购物车内的同一商品
- 登录后可在个人页面点击模拟充值，输入任意金额即可
- 下单后商品详情页的销量会更新

## 页面自适应

- 兼容了各种尺寸的屏幕，可以通过更改浏览器窗口尺寸观察效果

# 后端api一览

- [登录注册 /user/login?mail=test@test.com](https://ecommerce-api.debuggerx.com/user/login?mail=test@test.com)
- [用户信息 /user/info?uid=1](https://ecommerce-api.debuggerx.com/user/info?uid=1)
- [模拟充值 /user/add_balance?uid=1&amount=1000](https://ecommerce-api.debuggerx.com/user/add_balance?uid=1&amount=1000)

- [首页数据 /home/index](https://ecommerce-api.debuggerx.com/home/index)
- [商品分类列表 /item/index?category_id=1&last_id=1001](https://ecommerce-api.debuggerx.com/item/index?category_id=1&last_id=1001)
- [商品详情 /item/detail?item_id=1001](https://ecommerce-api.debuggerx.com/item/detail?item_id=1001)

- [购物车列表 /cart/index?uid=1](https://ecommerce-api.debuggerx.com/cart/index?uid=1)
- [修改购物车 /cart/update?uid=1&item_id=1001&quantity=2](https://ecommerce-api.debuggerx.com/cart/update?uid=1&item_id=1001&quantity=2)

- [收藏夹列表 /collection/index?uid=1](https://ecommerce-api.debuggerx.com/collection/index?uid=1)
- [更新收藏夹 /collection/update?uid=1&item_id=1001](https://ecommerce-api.debuggerx.com/collection/update?uid=1&item_id=1001)

- [订单列表 /order/index?uid=1](https://ecommerce-api.debuggerx.com/order/index?uid=1)
- [下单 /order/add?uid=1&item_id=1001&quantity=2](https://ecommerce-api.debuggerx.com/order/add?uid=1&item_id=1001&quantity=2)




