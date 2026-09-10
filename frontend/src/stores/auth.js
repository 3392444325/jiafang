import { defineStore } from 'pinia'
import { authApi } from '@/api'

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
      return res
    },
    async register(email, password, name) {
      const res = await authApi.register({ email, password, name })
      await this.fetchCurrentUser()
      return res
    },
    async logout() {
      await authApi.logout()
      this.user = null
    },
  },
})
