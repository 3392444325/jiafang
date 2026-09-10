import { defineStore } from 'pinia'
import { cartApi } from '@/api'

export const useCartStore = defineStore('cart', {
  state: () => ({
    count: 0,
    items: [],
  }),
  getters: {
    totalFen: (s) => s.items.reduce((sum, it) => sum + it.priceFen * it.qty, 0),
    totalCount: (s) => s.items.reduce((sum, it) => sum + it.qty, 0),
  },
  actions: {
    async fetchCount() {
      try {
        const res = await cartApi.count()
        this.count = res.count || 0
      } catch {
        this.count = 0
      }
    },
    async fetchItems() {
      const res = await cartApi.items()
      this.items = res.items || []
    },
    async add(productId, qty = 1) {
      const res = await cartApi.add(productId, qty)
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
  },
})
