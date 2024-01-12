#!/usr/bin/env bash


# cli登陆到cf
pnpm dlx wrangler login

# 初始化本地测试数据库
pnpm dlx wrangler d1 execute demo-ecommerce --local --file=./schema.sql

# 执行sql测试本地测试数据库
pnpm dlx wrangler d1 execute demo-ecommerce --local --command="SELECT * FROM users"

# 运行本地开发服务器
pnpm dlx wrangler dev

# 初始化cf数据库
pnpm dlx wrangler d1 execute demo-ecommerce --file=./schema.sql

# 部署worker到cf
pnpm dlx wrangler deploy