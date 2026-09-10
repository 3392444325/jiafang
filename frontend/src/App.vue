<script setup>
import { onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useCartStore } from '@/stores/cart'
import SiteHeader from '@/components/SiteHeader.vue'
import SiteFooter from '@/components/SiteFooter.vue'

const auth = useAuthStore()
const cart = useCartStore()

onMounted(() => {
  // 启动时拉取当前登录用户与购物车数量
  auth.fetchCurrentUser()
  cart.fetchCount()
})
</script>

<template>
  <div class="flex min-h-screen flex-col">
    <SiteHeader />
    <main class="flex-1">
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>
    <SiteFooter />
  </div>
</template>

<style>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
