<script setup>
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()
const route = useRoute()

const nav = [
  { href: '/designer/home', label: '首页设计' },
  { href: '/designer/story', label: '品牌故事' },
  { href: '/designer/franchise', label: '招商加盟' },
  { href: '/designer/groupbuy', label: '团购定制' },
  { href: '/designer/news', label: '品牌动态' },
  { href: '/designer/global', label: '联系方式' },
  { href: '/designer/products', label: '新品发布' },
  { href: '/admin', label: '商家后台' },
  { href: '/', label: '返回官网 →' },
]

const isActive = (href) => {
  if (href === '/' || href === '/admin') return false
  return route.path.startsWith(href)
}
</script>

<template>
  <div class="pt-[72px]">
    <div class="wrap flex flex-col gap-10 py-12 lg:flex-row">
      <aside class="shrink-0 lg:w-56">
        <p class="eyebrow">Designer Console</p>
        <h1 class="mt-3 font-display text-2xl tracking-[0.15em] text-ink">
          页面设计后台
        </h1>
        <p class="mt-2 text-[14px] tracking-[0.15em] text-ink/75">
          {{ auth.displayName }} · 管理员
        </p>
        <nav class="mt-8 flex gap-x-6 gap-y-3 lg:flex-col">
          <router-link
            v-for="n in nav"
            :key="n.href"
            :to="n.href"
            class="text-[15px] tracking-[0.2em] transition-colors"
            :class="isActive(n.href) ? 'text-gold-deep' : 'text-ink/75 hover:text-gold-deep'"
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
