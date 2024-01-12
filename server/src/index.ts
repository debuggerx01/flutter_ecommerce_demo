/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `npm run dev` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `npm run deploy` to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

import { faker } from '@faker-js/faker/locale/zh_CN';

import { items } from './items';
import { categories } from './categories';
import { now } from './utils';

export interface Env {
	DB: D1Database;
}

const pageSize = 30;

export default {
	async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
		const { pathname, searchParams } = new URL(request.url);
		switch (pathname) {
			// 用户登陆（或注册）
			case '/user/login':
				let uid = await env.DB.prepare(
					'SELECT id FROM users WHERE mail = ?'
				)
					.bind(searchParams.get('mail'))
					.first();

				if (uid != null) return Response.json({ uid });
				await env.DB.prepare(
					'INSERT INTO users (mail, balance) VALUES (?, ?)'
				).bind(searchParams.get('mail'), 0)
					.run();

				uid = await env.DB.prepare(
					'SELECT id FROM users WHERE mail = ?'
				)
					.bind(searchParams.get('mail'))
					.first();
				return Response.json({ uid });

			// 获取用户信息
			case '/user/info':
				const { results } = await env.DB.prepare(
					'SELECT * FROM users WHERE id = ?'
				)
					.bind(searchParams.get('uid'))
					.all();
				return Response.json(results);
			// 获取用户信息
			case '/user/add_balance':
				const balanceResult = await env.DB.prepare(
					'SELECT balance FROM users WHERE id = ?'
				)
					.bind(searchParams.get('uid'))
					.first();
				if (balanceResult == null) return Response.json({ error: 'user not found!' });
				const newBalance = (balanceResult.balance as number) + parseInt(searchParams.get('amount') as string);
				await env.DB.prepare(
					'UPDATE users SET balance = ? WHERE id = ?'
				).bind(newBalance, searchParams.get('uid'))
					.run();
				return Response.json({ newBalance });
			// 首页信息（类别列表及推荐分页）
			case '/home/index':
				const recommends = items.filter(value => value.price < 10000);
				let startRecommendIndex = 0;
				if (searchParams.get('last_id') != null) {
					startRecommendIndex = recommends.findIndex(item => item.id == parseInt(searchParams.get('last_id') as string)) + 1;
				}
				const pagedRecommends = recommends.slice(startRecommendIndex, startRecommendIndex + pageSize + 1);
				const hasMoreRecommends = pagedRecommends.length == pageSize + 1;
				if (hasMoreRecommends) pagedRecommends.pop();
				return Response.json({
					categories: searchParams.get('last_id') != null ? null : categories,
					hasMore: hasMoreRecommends,
					recommends: pagedRecommends
				});
			// 分类商品分页列表
			case '/item/index':
				const categoryItems = items.filter(value => value.cid == parseInt(searchParams.get('category_id') as string));
				let startIndex = 0;
				if (searchParams.get('last_id') != null) {
					startIndex = categoryItems.findIndex(item => item.id == parseInt(searchParams.get('last_id') as string)) + 1;
				}
				const pagedCategoryItems = categoryItems.slice(startIndex, startIndex + pageSize + 1);
				const hasMoreCategoryItems = pagedCategoryItems.length == pageSize + 1;
				if (hasMoreCategoryItems) pagedCategoryItems.pop();
				return Response.json({
					hasMore: hasMoreCategoryItems,
					items: pagedCategoryItems
				});

			// 商品详情
			case '/item/detail':
				const itemDetail = items.find(value => value.id == parseInt(searchParams.get('item_id') as string));
				if (!itemDetail) return Response.json({ error: 'item detail not found!' });
				const salesResult = await env.DB.prepare(
					'SELECT SUM(quantity) AS sales FROM orders where item_id = ?'
				).bind(searchParams.get('item_id'))
					.first();
				itemDetail.sales = (salesResult?.sales ?? 0) as number;
				faker.seed(itemDetail.id);
				itemDetail.content = [
					faker.commerce.productDescription(),
					faker.commerce.productDescription(),
					faker.commerce.productDescription(),
					faker.commerce.productDescription(),
					faker.commerce.productDescription()
				].join('\n');
				return Response.json(itemDetail);

			// 购物车列表
			case '/cart/index':
				return Response.json((await env.DB.prepare(
					'SELECT * FROM carts where uid = ? ORDER BY updated_at DESC'
				).bind(searchParams.get('uid'))
					.all()).results.map((result) => {
					const foundItem = items.find(item => item.id == result.item_id);
					return {
						...result,
						title: foundItem?.title,
						price: foundItem?.price
					};
				}));

			// 更新购物车
			case '/cart/update':
				const cartResult = await env.DB.prepare(
					'SELECT * FROM carts WHERE uid = ? AND item_id = ?'
				).bind(searchParams.get('uid'), searchParams.get('item_id'))
					.first();

				let cartResp = '';
				if (cartResult == null) {
					await env.DB.prepare(
						'INSERT INTO carts (uid, item_id, updated_at, quantity) VALUES (?, ?, ?, ?)'
					).bind(searchParams.get('uid'), searchParams.get('item_id'), now(), searchParams.get('quantity'))
						.run();
					cartResp = 'added';
				} else {
					if (searchParams.get('quantity') == '0') {
						await env.DB.prepare(
							'DELETE FROM carts WHERE uid = ? AND item_id = ?'
						).bind(searchParams.get('uid'), searchParams.get('item_id'))
							.run();
						cartResp = 'deleted';
					} else {
						await env.DB.prepare(
							'UPDATE carts SET quantity = ? WHERE uid = ? AND item_id = ?'
						).bind(searchParams.get('quantity'), searchParams.get('uid'), searchParams.get('item_id'))
							.run();
						cartResp = 'updated';
					}
				}

				return Response.json(cartResp);

			// 收藏夹列表
			case '/collection/index':
				return Response.json((await env.DB.prepare(
					'SELECT * FROM collections where uid = ? ORDER BY updated_at DESC'
				).bind(searchParams.get('uid'))
					.all()).results.map((result) => {
					const foundItem = items.find(item => item.id == result.item_id);
					return {
						...result,
						title: foundItem?.title,
						price: foundItem?.price
					};
				}));

			// 更新收藏夹
			case '/collection/update':
				const collectionResult = await env.DB.prepare(
					'SELECT * FROM collections WHERE uid = ? AND item_id = ?'
				).bind(searchParams.get('uid'), searchParams.get('item_id'))
					.first();

				let collectionResp = '';
				if (collectionResult == null) {
					await env.DB.prepare(
						'INSERT INTO collections (uid, item_id, updated_at) VALUES (?, ?, ?)'
					).bind(searchParams.get('uid'), searchParams.get('item_id'), now())
						.run();
					collectionResp = 'added';
				} else {
					await env.DB.prepare(
						'DELETE FROM collections WHERE uid = ? AND item_id = ?'
					).bind(searchParams.get('uid'), searchParams.get('item_id'))
						.run();
					collectionResp = 'deleted';
				}
				return Response.json(collectionResp);

			// 订单列表
			case '/order/index':
				return Response.json((await env.DB.prepare(
					'SELECT * FROM orders where uid = ? ORDER BY created_at DESC'
				).bind(searchParams.get('uid'))
					.all()).results.map((result) => {
					const foundItem = items.find(item => item.id == result.item_id);
					return {
						...result,
						title: foundItem?.title,
						price: foundItem?.price
					};
				}));

			// 下单
			case '/order/add':
				const orderItem = items.find(item => item.id == parseInt(searchParams.get('item_id') as string));
				if (orderItem == null) return Response.json({ error: 'item not found!' });
				const totalCost = orderItem.price * parseInt(searchParams.get('quantity') as string);
				const userBalanceResult = await env.DB.prepare(
					'SELECT balance FROM users WHERE id = ?'
				).bind(searchParams.get('uid'))
					.first();
				if (userBalanceResult == null) return Response.json({ error: 'user not found!' });
				const balanceLeft = (userBalanceResult.balance as number) - totalCost;
				if (balanceLeft < 0) return Response.json({ error: 'balance not enough!' });
				await env.DB.prepare(
					'INSERT INTO orders (uid, item_id, item_title, item_price, quantity, amount, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)'
				).bind(searchParams.get('uid'), orderItem.id, orderItem.title, orderItem.price, searchParams.get('quantity'), totalCost, now())
					.run();
				await env.DB.prepare(
					'DELETE FROM carts WHERE uid = ? AND item_id = ?'
				).bind(searchParams.get('uid'), orderItem.id)
					.run();
				await env.DB.prepare(
					'UPDATE users SET balance = ? WHERE id = ?'
				).bind(balanceLeft, searchParams.get('uid'))
					.run();
				return Response.json({ balanceLeft });
		}
		return new Response(`No route found for [${pathname}]!`);
	}
};
