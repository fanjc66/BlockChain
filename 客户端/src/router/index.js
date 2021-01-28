import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
	{
		path: '/',
		name: '首页',
		component: () => import('@/views/login/login.vue')
	},
	{
		path: '/login',
		name: '登录',
		component: () => import('@/views/login/login.vue')
	},
	{
		path: '/core-enterprise',
		name: '核心企业',
		component: () => import('@/views/core-enterprise/core-enterprise.vue')
	},
	{
		path: '/downstream-enterprise',
		name: '下游企业',
		component: () => import('@/views/downstream/downstream-enterprise.vue')
	},
	{
		path: '/bank',
		name: '银行',
		component: () => import('@/views/bank/bank.vue')
	},
	{
		path: '/setting',
		name: '设置',
		component: () => import('@/views/setting/setting.vue')
	}
]

const router = new VueRouter({
	routes
})

export default router
