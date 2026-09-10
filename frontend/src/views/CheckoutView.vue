<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useCartStore } from '@/stores/cart'
import CheckoutForm from '@/components/CheckoutForm.vue'

const router = useRouter()
const auth = useAuthStore()
const cart = useCartStore()

const loading = ref(true)
const loadError = ref(false)

onMounted(async () => {
  if (!auth.isLoggedIn) {
    await auth.fetchCurrentUser()
  }
  if (!auth.isLoggedIn) {
    router.replace('/login?redirect=/checkout')
    return
  }
  try {
    await cart.fetchItems()
  } catch {
    loadError.value = true
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="pt-[72px]">
    <div class="wrap py-16">
      <p class="eyebrow">Checkout</p>
      <h1 class="mt-4 font-display text-4xl tracking-[0.15em] text-ink">
        确认订单
      </h1>

      <div v-if="loadError" class="py-24 text-center">
        <p class="font-display text-2xl tracking-[0.2em] text-ink/60">
          购物车加载失败，请稍后重试
        </p>
        <button class="btn-primary mt-10" @click="router.go(0)">重新加载</button>
      </div>

      <template v-if="!loading">
        <div v-if="cart.items.length === 0" class="py-24 text-center">
          <p class="font-display text-2xl tracking-[0.2em] text-ink/60">
            购物车是空的，无法结算
          </p>
          <router-link to="/products" class="btn-primary mt-10">
            去挑选心仪的织物
          </router-link>
        </div>
        <div v-else class="mt-12">
          <CheckoutForm />
        </div>
      </template>
    </div>
  </div>
</template>
