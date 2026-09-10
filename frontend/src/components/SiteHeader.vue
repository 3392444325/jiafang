<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useCartStore } from '@/stores/cart'
import { productApi } from '@/api'

const HEADER_H = 72

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const cart = useCartStore()

const scrolled = ref(false)
const open = ref(false)
const searchOpen = ref(false)
const kw = ref('')
const mKw = ref('')
const categories = ref([])

const pathname = computed(() => route.path)

const overlay = computed(() => {
  const p = pathname.value
  return p === '/' || p === '/story' || p.startsWith('/shop')
})
const solid = computed(
  () => scrolled.value || !overlay.value || open.value || searchOpen.value
)
const isShop = computed(() => {
  const p = pathname.value
  return (
    p.startsWith('/shop') ||
    p.startsWith('/products') ||
    p === '/cart' ||
    p.startsWith('/checkout') ||
    p.startsWith('/orders')
  )
})

const tone = computed(() => (solid.value ? 'text-ink' : 'text-white'))
const chrome = computed(() =>
  solid.value
    ? 'bg-linen/85 backdrop-blur-md border-b border-ink/10'
    : 'bg-transparent border-b border-white/10'
)
const navCls = (to) => {
  const base = `link-underline text-[13px] tracking-[0.2em] transition-colors ${
    solid.value ? 'hover:text-gold-deep' : 'hover:!text-gold'
  }`
  // 当前页对应的导航项：文字变金色 + 下划线常显，突出选中态
  return isActive(to)
    ? `${base} ${solid.value ? 'text-gold-deep' : '!text-gold'} after:w-full`
    : base
}
// 胶囊按钮（品牌官网 / 官方商城）的选中高亮
const pillCls = (to) =>
  `border px-4 py-1.5 text-[12px] tracking-[0.25em] transition-colors ${
    isActive(to) ? 'border-gold text-gold' : 'border-current hover:border-gold hover:text-gold'
  }`

const userName = computed(() => auth.user?.name ?? auth.user?.email ?? '')

// 导航高亮：判断目标路由是否为当前页面（首页精确匹配，其余按前缀匹配）
function isActive(to) {
  if (to === '/') return route.path === '/'
  return route.path === to || route.path.startsWith(to + '/')
}

// 路由切换时收起移动端菜单与搜索面板（对应原 prevPath 逻辑）
watch(pathname, () => {
  open.value = false
  searchOpen.value = false
})

function goSearch(v) {
  const t = v.trim()
  if (!t) return
  searchOpen.value = false
  open.value = false
  router.push(`/products?q=${encodeURIComponent(t)}`)
}

async function logout() {
  await auth.logout()
  router.push('/')
}

let onScroll
let onKey
onMounted(() => {
  // 拉取当前用户、购物车数量、商品分类
  auth.fetchCurrentUser()
  cart.fetchCount()
  productApi
    .shop()
    .then((res) => {
      categories.value = (res.categories || []).map((c) => ({
        slug: c.slug,
        name: c.name,
        nameEn: c.nameEn,
      }))
    })
    .catch(() => {})

  onScroll = () => {
    scrolled.value = window.scrollY > 30
  }
  onScroll()
  window.addEventListener('scroll', onScroll, { passive: true })

  onKey = (e) => {
    if (e.key === 'Escape') searchOpen.value = false
  }
  window.addEventListener('keydown', onKey)
})

onBeforeUnmount(() => {
  if (onScroll) window.removeEventListener('scroll', onScroll)
  if (onKey) window.removeEventListener('keydown', onKey)
})

// 桌面搜索面板输入框自动聚焦指令
const vFocus = { mounted: (el) => el.focus() }
</script>

<template>
  <!-- 顶部公告栏 -->
  <div class="bg-ink text-ivory">
    <div class="wrap flex items-center justify-center gap-4 py-2.5 text-[11px] tracking-[0.18em]">
      <span class="hidden text-gold md:inline">ZHIYUN LIVING</span>
      <span class="opacity-80">秋季焕新 · 全场满 ¥1,299 减 ¥150 · 新会员注册即赠 ¥100 礼遇</span>
    </div>
  </div>

  <header :class="['sticky top-0 z-50 transition-all duration-500', chrome]">
    <div
      :class="['wrap relative flex items-center justify-between', tone, 'transition-colors duration-500']"
      :style="{ minHeight: HEADER_H + 'px' }"
    >
      <!-- 左侧：桌面导航 -->
      <nav class="hidden items-center gap-6 lg:flex">
        <template v-if="isShop">
          <router-link to="/shop" :class="navCls('/shop')">商城首页</router-link>
          <div class="group relative">
            <span class="cursor-default text-[13px] tracking-[0.2em]">分类甄选</span>
            <div
              class="invisible absolute left-1/2 top-full -translate-x-1/2 pt-5 opacity-0 transition-all duration-300 group-hover:visible group-hover:opacity-100"
            >
              <div class="min-w-[240px] border border-ink/10 bg-ivory py-3 text-ink shadow-2xl">
                <router-link
                  v-for="c in categories"
                  :key="c.slug"
                  :to="`/products?cat=${c.slug}`"
                  class="flex items-baseline justify-between px-6 py-2.5 text-[13px] tracking-[0.15em] transition-colors hover:bg-sand hover:text-gold-deep"
                >
                  <span>{{ c.name }}</span>
                  <span class="text-[9px] uppercase tracking-[0.2em] text-ink/40">{{ c.nameEn }}</span>
                </router-link>
              </div>
            </div>
          </div>
          <router-link to="/products" :class="navCls('/products')">产品展示</router-link>
          <router-link to="/orders" :class="navCls('/orders')">我的订单</router-link>
          <router-link to="/account/addresses" :class="navCls('/account/addresses')">地址簿</router-link>
          <router-link to="/" :class="pillCls('/')">
            品牌官网
          </router-link>
        </template>
        <template v-else>
          <router-link to="/" :class="navCls('/')">首页</router-link>
          <router-link to="/story" :class="navCls('/story')">品牌</router-link>
          <router-link to="/news" :class="navCls('/news')">动态</router-link>
          <router-link to="/franchise" :class="navCls('/franchise')">招商</router-link>
          <router-link to="/group-buy" :class="navCls('/group-buy')">团购</router-link>
          <router-link to="/cooperation" :class="navCls('/cooperation')">合作</router-link>
          <router-link to="/careers" :class="navCls('/careers')">人才</router-link>
          <router-link to="/shop" :class="pillCls('/shop')">
            官方商城
          </router-link>
        </template>
      </nav>

      <!-- 中部：品牌字标 -->
      <router-link to="/" class="absolute left-1/2 -translate-x-1/2 text-center">
        <span class="block font-display text-[26px] leading-none tracking-[0.35em]">织云</span>
        <span class="mt-1.5 block text-[8px] uppercase tracking-[0.5em] opacity-70">Zhiyun Living</span>
      </router-link>

      <!-- 右侧：账户 / 购物车 / 移动端菜单 -->
      <div class="flex items-center gap-5 lg:gap-6">
        <router-link
          v-if="auth.isAdmin"
          to="/admin"
          :class="['hidden lg:block', navCls('/admin')]"
        >
          管理后台
        </router-link>
        <div v-if="auth.isLoggedIn" class="hidden items-center gap-5 lg:flex">
          <router-link to="/orders" :class="navCls('/orders')">{{ userName }}</router-link>
          <button
            class="cursor-pointer text-[11px] tracking-[0.2em] opacity-60 transition-opacity hover:opacity-100"
            @click="logout"
          >
            退出
          </button>
        </div>
        <router-link
          v-else
          to="/login"
          :class="['hidden lg:block', navCls('/login')]"
        >
          登录 / 注册
        </router-link>
        <button
          aria-label="搜索"
          :class="[
            'hidden cursor-pointer transition-colors lg:block',
            solid ? 'hover:text-gold-deep' : 'hover:text-gold',
          ]"
          @click="searchOpen = !searchOpen"
        >
          <svg
            width="19"
            height="19"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="1.5"
          >
            <circle cx="11" cy="11" r="7" />
            <path d="m20 20-3.5-3.5" />
          </svg>
        </button>
        <router-link
          to="/cart"
          class="relative transition-colors hover:text-gold-deep"
          aria-label="购物车"
        >
          <svg
            width="20"
            height="20"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="1.5"
          >
            <path d="M6 7h12l1 13H5L6 7z" />
            <path d="M9 10V6a3 3 0 0 1 6 0v4" />
          </svg>
          <span
            v-if="cart.count > 0"
            class="absolute -right-2 -top-2 flex h-4 min-w-4 items-center justify-center rounded-full bg-gold-deep px-1 text-[10px] leading-none text-white"
          >
            {{ cart.count }}
          </span>
        </router-link>
        <button
          class="flex cursor-pointer flex-col gap-1.5 lg:hidden"
          aria-label="菜单"
          @click="open = !open"
        >
          <span
            :class="['h-px w-6 bg-current transition-transform', open ? 'translate-y-[3.5px] rotate-45' : '']"
          />
          <span
            :class="['h-px w-6 bg-current transition-transform', open ? '-translate-y-[3.5px] -rotate-45' : '']"
          />
        </button>
      </div>
    </div>

    <!-- 桌面搜索面板 -->
    <div
      v-if="searchOpen"
      class="absolute inset-x-0 top-full hidden border-b border-ink/10 bg-linen/95 text-ink backdrop-blur-md lg:block"
    >
      <form class="wrap flex items-center gap-5 py-6" @submit.prevent="goSearch(kw)">
        <svg
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="1.5"
          class="text-ink/40"
        >
          <circle cx="11" cy="11" r="7" />
          <path d="m20 20-3.5-3.5" />
        </svg>
        <input
          v-focus
          v-model="kw"
          placeholder="搜索：鹅绒被 · 蚕丝被 · 贡缎 · 婚嫁礼盒…"
          class="flex-1 bg-transparent text-sm tracking-[0.15em] outline-none placeholder:text-ink/30"
        />
        <button type="submit" class="btn-primary px-6 py-2.5">搜索</button>
      </form>
      <div class="wrap flex flex-wrap items-center gap-x-6 gap-y-2 pb-6 text-[11px] tracking-[0.2em] text-ink/45">
        <span class="uppercase tracking-[0.3em] text-ink/30">热门</span>
        <button
          v-for="t in ['鹅绒被', '蚕丝被', '四件套', '婚嫁礼盒']"
          :key="t"
          class="cursor-pointer transition-colors hover:text-gold-deep"
          @click="goSearch(t)"
        >
          {{ t }}
        </button>
      </div>
    </div>
  </header>

  <!-- 移动端全屏菜单 -->
  <div v-if="open" class="fixed inset-0 z-40 flex animate-fade-in flex-col bg-linen lg:hidden">
    <div :style="{ height: HEADER_H + 'px' }" />
    <nav class="flex flex-col gap-2 overflow-y-auto px-8 py-10">
      <form
        class="mb-4 flex items-center gap-2 border border-ink/15 bg-ivory px-4 py-3"
        @submit.prevent="goSearch(mKw)"
      >
        <svg
          width="16"
          height="16"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="1.5"
          class="text-ink/40"
        >
          <circle cx="11" cy="11" r="7" />
          <path d="m20 20-3.5-3.5" />
        </svg>
        <input
          v-model="mKw"
          placeholder="搜索商品：鹅绒被 · 蚕丝被 · 礼盒…"
          class="w-full bg-transparent text-sm tracking-[0.15em] outline-none placeholder:text-ink/30"
        />
        <button type="submit" class="cursor-pointer text-[11px] uppercase tracking-[0.3em] text-gold-deep">
          搜索
        </button>
      </form>
      <p class="eyebrow pb-1">品牌</p>
      <router-link to="/" class="py-3 font-display text-2xl tracking-[0.3em]">首页</router-link>
      <router-link to="/story" class="py-3 font-display text-2xl tracking-[0.3em]">品牌</router-link>
      <router-link to="/news" class="py-3 font-display text-2xl tracking-[0.3em]">动态</router-link>
      <p class="eyebrow mt-6 pb-1">走进织云</p>
      <router-link to="/franchise" class="py-3 font-display text-2xl tracking-[0.3em]">招商加盟</router-link>
      <router-link to="/group-buy" class="py-3 font-display text-2xl tracking-[0.3em]">团购定制</router-link>
      <router-link to="/cooperation" class="py-3 font-display text-2xl tracking-[0.3em]">商务合作</router-link>
      <router-link to="/careers" class="py-3 font-display text-2xl tracking-[0.3em]">人才招聘</router-link>
      <p class="eyebrow mt-6 pb-1">官方商城</p>
      <router-link to="/shop" class="py-3 font-display text-2xl tracking-[0.3em]">商城首页</router-link>
      <router-link to="/products" class="py-3 font-display text-2xl tracking-[0.3em]">产品展示</router-link>
      <router-link
        v-for="c in categories"
        :key="c.slug"
        :to="`/products?cat=${c.slug}`"
        class="py-2.5 pl-2 text-sm tracking-[0.25em] text-ink-soft"
      >
        {{ c.name }}
        <span class="ml-3 text-[9px] uppercase tracking-[0.2em] text-ink/40">{{ c.nameEn }}</span>
      </router-link>
      <div class="hairline-t mt-6 flex flex-col gap-3 pt-6 text-sm tracking-[0.25em]">
        <template v-if="auth.isLoggedIn">
          <router-link to="/orders">我的订单</router-link>
          <router-link v-if="auth.isAdmin" to="/admin">管理后台</router-link>
          <button class="cursor-pointer text-left text-ink/50" @click="logout">退出登录</button>
        </template>
        <router-link v-else to="/login">登录 / 注册</router-link>
        <router-link to="/cart">购物车 ({{ cart.count }})</router-link>
      </div>
    </nav>
  </div>
</template>
