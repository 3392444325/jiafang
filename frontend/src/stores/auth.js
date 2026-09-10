import { defineStore } from 'pinia'
import { authApi } from '@/api'
import { useCartStore } from '@/stores/cart'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null, // { id, email, name, role }
    loading: false,
  }),
  getters: {
    isLoggedIn: (s) => !!s.user,
    isAdmin: (s) => s.user?.role === 'ADMIN',
    displayName: (s) => s.user?.name || s.user?.email || '',
  },
  actions: {
    async fetchCurrentUser() {
      try {
        const res = await authApi.me()
        this.user = res.user && res.user.id ? res.user : null
      } catch {
        this.user = null
      }
    },
    async login(email, password) {
      const res = await authApi.login({ email, password })
      await this.fetchCurrentUser()
      // 登录成功后后端已合并游客购物车，刷新购物车角标与列表
      const cart = useCartStore()
      await Promise.all([cart.fetchCount(), cart.fetchItems()])
      return res
    },
    async register(email, password, name) {
      const res = await authApi.register({ email, password, name })
      await this.fetchCurrentUser()
      const cart = useCartStore()
      await Promise.all([cart.fetchCount(), cart.fetchItems()])
      return res
    },
    async logout() {
      await authApi.logout()
      this.user = null
      // 退出后后端已删除会话并清 Cookie，重置购物车状态
      const cart = useCartStore()
      cart.$reset()
    },
  },
})
