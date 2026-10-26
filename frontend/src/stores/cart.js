import { defineStore } from 'pinia'
import { cartApi } from '@/api'

export const useCartStore = defineStore('cart', {
  state: () => ({
    count: 0,
    items: [],
    gen: 0, // 状态版本号：reset 时递增，用于丢弃登出前发起的在途响应
  }),
  getters: {
    totalFen: (s) => s.items.reduce((sum, it) => sum + it.priceFen * it.qty, 0),
    totalCount: (s) => s.items.reduce((sum, it) => sum + it.qty, 0),
  },
  actions: {
    async fetchCount() {
      const gen = this.gen
      try {
        const res = await cartApi.count()
        if (gen !== this.gen) return // 期间已登出/切换用户，丢弃过期响应
        this.count = res.count || 0
      } catch {
        if (gen === this.gen) this.count = 0
      }
    },
    async fetchItems() {
      const gen = this.gen
      try {
        const res = await cartApi.items()
        if (gen !== this.gen) return
        this.items = res.items || []
      } catch {
        if (gen === this.gen) this.items = []
      }
    },
    async add(productId, qty = 1) {
      const gen = this.gen
      const res = await cartApi.add(productId, qty)
      if (gen !== this.gen) return res // 响应期间已切换用户，不写回旧徽标
      this.count = res.count || 0
      return res
    },
    async update(id, qty) {
      await cartApi.update(id, qty)
      await this.fetchItems()
      await this.fetchCount()
    },
    async remove(id) {
      await cartApi.remove(id)
      await this.fetchItems()
      await this.fetchCount()
    },
    /** 登出/切换用户时清空本地购物车状态（徽标等），并使在途响应失效 */
    reset() {
      this.gen++
      this.count = 0
      this.items = []
    },
  },
})
