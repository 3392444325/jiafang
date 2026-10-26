import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  // ============== 品牌官网 ==============
  { path: '/', name: 'home', component: () => import('@/views/HomeView.vue') },
  { path: '/story', name: 'story', component: () => import('@/views/StoryView.vue') },
  { path: '/news', name: 'news', component: () => import('@/views/NewsView.vue') },
  { path: '/news/:id', name: 'news-detail', component: () => import('@/views/NewsDetailView.vue') },
  { path: '/franchise', name: 'franchise', component: () => import('@/views/FranchiseView.vue') },
  { path: '/group-buy', name: 'group-buy', component: () => import('@/views/GroupBuyView.vue') },

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

  // ============== 页面设计后台（独立入口） ==============
  { path: '/designer', redirect: { name: 'designer-home' } },
  { path: '/designer/home', name: 'designer-home', component: () => import('@/views/designer/DesignerHome.vue'), meta: { requiresDesigner: true } },
  { path: '/designer/products', name: 'designer-products', component: () => import('@/views/designer/DesignerProducts.vue'), meta: { requiresDesigner: true } },
  { path: '/designer/story', name: 'designer-story', component: () => import('@/views/designer/DesignerStory.vue'), meta: { requiresDesigner: true } },
  { path: '/designer/franchise', name: 'designer-franchise', component: () => import('@/views/designer/DesignerFranchise.vue'), meta: { requiresDesigner: true } },
  { path: '/designer/groupbuy', name: 'designer-groupbuy', component: () => import('@/views/designer/DesignerGroupbuy.vue'), meta: { requiresDesigner: true } },
  { path: '/designer/news', name: 'designer-news', component: () => import('@/views/designer/DesignerNews.vue'), meta: { requiresDesigner: true } },
  { path: '/designer/global', name: 'designer-global', component: () => import('@/views/designer/DesignerGlobal.vue'), meta: { requiresDesigner: true } },

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

// 全局前置守卫：先恢复会话，再做鉴权 + 角色校验
// （否则刷新页面时 user 尚未从 /auth/me 恢复，会被误踢出受保护页面）
import { useAuthStore } from '@/stores/auth'
router.beforeEach(async (to) => {
  const auth = useAuthStore()
  await auth.ensureLoaded()
  if (to.meta.requiresAuth && !auth.isLoggedIn) {
    return { name: 'login', query: { redirect: to.fullPath } }
  }
  if (to.meta.requiresAdmin && !auth.isAdmin) {
    // 未登录先引导登录（登录后跳回），已登录但非管理员回首页
    if (!auth.isLoggedIn) {
      return { name: 'login', query: { redirect: to.fullPath } }
    }
    return { name: 'home' }
  }
  if (to.meta.requiresDesigner && !auth.isAdmin) {
    if (!auth.isLoggedIn) {
      return { name: 'login', query: { redirect: to.fullPath } }
    }
    return { name: 'home' }
  }
})

export default router
