import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  // ============== 品牌官网 ==============
  { path: '/', name: 'home', component: () => import('@/views/HomeView.vue') },
  { path: '/story', name: 'story', component: () => import('@/views/StoryView.vue') },
  { path: '/news', name: 'news', component: () => import('@/views/NewsView.vue') },
  { path: '/franchise', name: 'franchise', component: () => import('@/views/FranchiseView.vue') },
  { path: '/group-buy', name: 'group-buy', component: () => import('@/views/GroupBuyView.vue') },
  { path: '/cooperation', name: 'cooperation', component: () => import('@/views/CooperationView.vue') },
  { path: '/careers', name: 'careers', component: () => import('@/views/CareersView.vue') },

  // ============== 商城 ==============
  { path: '/shop', name: 'shop', component: () => import('@/views/ShopView.vue') },
  { path: '/products', name: 'products', component: () => import('@/views/ProductsView.vue') },
  { path: '/products/:slug', name: 'product-detail', component: () => import('@/views/ProductDetailView.vue') },
  { path: '/cart', name: 'cart', component: () => import('@/views/CartView.vue') },
  { path: '/checkout', name: 'checkout', component: () => import('@/views/CheckoutView.vue') },
  { path: '/login', name: 'login', component: () => import('@/views/LoginView.vue') },
  { path: '/register', name: 'register', component: () => import('@/views/RegisterView.vue') },
  { path: '/orders', name: 'orders', component: () => import('@/views/OrdersView.vue'), meta: { requiresAuth: true } },
  { path: '/orders/:id', name: 'order-detail', component: () => import('@/views/OrderDetailView.vue'), meta: { requiresAuth: true } },
  { path: '/orders/:id/pay', name: 'order-pay', component: () => import('@/views/OrderPayView.vue'), meta: { requiresAuth: true } },
  { path: '/account/addresses', name: 'addresses', component: () => import('@/views/AddressesView.vue'), meta: { requiresAuth: true } },

  // ============== 后台管理 ==============
  { path: '/admin', name: 'admin-dashboard', component: () => import('@/views/admin/DashboardView.vue'), meta: { requiresAdmin: true } },
  { path: '/admin/products', name: 'admin-products', component: () => import('@/views/admin/ProductsView.vue'), meta: { requiresAdmin: true } },
  { path: '/admin/products/:id', name: 'admin-product-edit', component: () => import('@/views/admin/ProductEditView.vue'), meta: { requiresAdmin: true } },
  { path: '/admin/orders', name: 'admin-orders', component: () => import('@/views/admin/OrdersView.vue'), meta: { requiresAdmin: true } },
  { path: '/admin/reviews', name: 'admin-reviews', component: () => import('@/views/admin/ReviewsView.vue'), meta: { requiresAdmin: true } },
  { path: '/admin/customers', name: 'admin-customers', component: () => import('@/views/admin/CustomersView.vue'), meta: { requiresAdmin: true } },
  { path: '/admin/leads', name: 'admin-leads', component: () => import('@/views/admin/LeadsView.vue'), meta: { requiresAdmin: true } },

  // 404
  { path: '/:pathMatch(.*)*', name: 'not-found', component: () => import('@/views/NotFoundView.vue') },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) return savedPosition
    return { top: 0 }
  },
})

// 全局前置守卫：鉴权 + 角色校验
import { useAuthStore } from '@/stores/auth'

// 登录态由 App.vue onMounted 异步拉取 /auth/me 初始化。
// 硬刷新受保护页面时守卫先于 onMounted 执行，此时 user 还是 null，
// 因此首次导航必须先等登录态就绪，否则已登录用户会被误踢回登录页。
let authReady = false

router.beforeEach(async (to) => {
  const auth = useAuthStore()
  if (!authReady) {
    await auth.fetchCurrentUser()
    authReady = true
  }
  if (to.meta.requiresAuth && !auth.isLoggedIn) {
    return { name: 'login', query: { redirect: to.fullPath } }
  }
  if (to.meta.requiresAdmin && !auth.isAdmin) {
    return { name: 'home' }
  }
})

export default router
