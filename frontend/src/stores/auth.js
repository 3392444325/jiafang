import { defineStore } from 'pinia'
import { authApi } from '@/api'
import { useCartStore } from '@/stores/cart'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null, // { id, email, name, role }
    loading: false,
    booted: false, // 是否已做过会话恢复（/auth/me）
  }),
  getters: {
    isLoggedIn: (s) => !!s.user,
    isAdmin: (s) => s.user?.role === 'ADMIN',
    displayName: (s) => s.user?.name || s.user?.email || '',
  },
  actions: {
    /** 路由守卫等处使用：确保启动时恢复过一次登录态，之后直接返回 */
    async ensureLoaded() {
      if (this.booted) return
      this.booted = true
      await this.fetchCurrentUser()
    },
    async fetchCurrentUser() {
      try {
        const res = await authApi.me()
        this.user = res.user && res.user.id ? res.user : null
      } catch {
        this.user = null
      } finally {
        this.booted = true
      }
    },
    async login(email, password) {
      const res = await authApi.login({ email, password })
      await this.fetchCurrentUser()
      // 登录会合并游客购物车，徽标需按合并结果刷新
      useCartStore().reset()
      await useCartStore().fetchCount()
      return res
    },
    async register(email, password, name) {
      const res = await authApi.register({ email, password, name })
      await this.fetchCurrentUser()
      useCartStore().reset()
      await useCartStore().fetchCount()
      return res
    },
    async logout() {
      await authApi.logout()
      this.user = null
      // 清空本地购物车状态（服务端 Cookie 已清除，游客购物车为空）
      useCartStore().reset()
    },
  },
})
