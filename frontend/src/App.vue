<script setup>
import { computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useCartStore } from '@/stores/cart'
import SiteHeader from '@/components/SiteHeader.vue'
import SiteFooter from '@/components/SiteFooter.vue'

const route = useRoute()
const auth = useAuthStore()
const cart = useCartStore()

// 路由视图不使用 transition：实测 out-in 过渡在离开部分页面时会卡住，导致新页面不渲染
// （<main> 只剩注释占位符或旧页面残留），故直接渲染 <component :is="Component" />
// 首页与招商页只保留大图内容，不显示页脚
const showFooter = computed(() => !['/', '/franchise'].includes(route.path))

onMounted(() => {
  // 启动时拉取当前登录用户与购物车数量
  auth.fetchCurrentUser()
  cart.fetchCount()
})
</script>

<template>
  <div class="flex min-h-vh-screen flex-col">
    <SiteHeader />
    <main class="flex-1">
      <router-view v-slot="{ Component }">
        <component :is="Component" />
      </router-view>
    </main>
    <SiteFooter v-if="showFooter" />
  </div>
</template>
