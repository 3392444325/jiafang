<script setup>
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()
const route = useRoute()

const nav = [
  { href: '/admin', label: '数据看板' },
  { href: '/admin/products', label: '商品管理' },
  { href: '/admin/orders', label: '订单管理' },
  { href: '/admin/reviews', label: '评论管理' },
  { href: '/admin/customers', label: '客户管理' },
  { href: '/admin/leads', label: '商机线索' },
  { href: '/', label: '返回官网 →' },
]

const isActive = (href) => {
  if (href === '/') return false
  if (href === '/admin') return route.path === '/admin'
  return route.path.startsWith(href)
}
</script>

<template>
  <div class="pt-[72px]">
    <div class="wrap flex flex-col gap-10 py-12 lg:flex-row">
      <aside class="shrink-0 lg:w-56">
        <p class="eyebrow">Merchant Console</p>
        <h1 class="mt-3 font-display text-2xl tracking-[0.15em] text-ink">
          绮云商家后台
        </h1>
        <p class="mt-2 text-xs tracking-[0.15em] text-ink/45">
          {{ auth.displayName }} · 管理员
        </p>
        <nav class="mt-8 flex gap-x-6 gap-y-3 lg:flex-col">
          <router-link
            v-for="n in nav"
            :key="n.href"
            :to="n.href"
            class="text-sm tracking-[0.2em] transition-colors"
            :class="isActive(n.href) ? 'text-gold-deep' : 'text-ink/60 hover:text-gold-deep'"
          >
            {{ n.label }}
          </router-link>
        </nav>
      </aside>
      <div class="min-w-0 flex-1">
        <slot />
      </div>
    </div>
  </div>
</template>
