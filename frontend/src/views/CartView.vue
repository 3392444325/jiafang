<script setup>
import { onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useCartStore } from '@/stores/cart'
import CartView from '@/components/CartView.vue'

const auth = useAuthStore()
const cart = useCartStore()

onMounted(() => {
  cart.fetchItems()
})
</script>

<template>
  <div class="pt-[72px]">
    <div class="wrap py-16">
      <p class="eyebrow">Shopping Bag</p>
      <h1 class="mt-4 font-display text-4xl tracking-[0.15em] text-ink">
        购物车
        <span
          v-if="auth.isLoggedIn"
          class="ml-4 align-middle text-xs tracking-[0.2em] text-ink/40"
        >
          {{ auth.displayName }}，欢迎回来
        </span>
      </h1>
      <CartView />
    </div>
  </div>
</template>
