<script setup>
import { ref } from 'vue'

const cols = [
  {
    title: '品牌',
    links: [
      { label: '品牌首页', href: '/' },
      { label: '品牌', href: '/story' },
      { label: '品牌动态', href: '/news' },
      { label: '线下门店', href: '/story#stores' },
    ],
  },
  {
    title: '走进织云',
    links: [
      { label: '招商加盟', href: '/franchise' },
      { label: '团购定制', href: '/group-buy' },
      { label: '商务合作', href: '/cooperation' },
      { label: '人才招聘', href: '/careers' },
    ],
  },
  {
    title: '购物帮助',
    links: [
      { label: '企业礼购', href: '/products?cat=gifts' },
      { label: '配送与安装', href: '/story#service' },
      { label: '退换货政策', href: '/story#service' },
      { label: '七星洗护', href: '/story#service' },
    ],
  },
]

// 订阅表单（原 SubscribeForm 组件内联）
const email = ref('')
const done = ref(false)
function onSubscribe() {
  if (email.value.includes('@')) done.value = true
}
</script>

<template>
  <footer class="bg-ink text-ivory">
    <!-- 品牌宣言 + 订阅 -->
    <div class="wrap grid gap-12 border-b border-ivory/10 py-16 md:grid-cols-2 md:py-20">
      <div>
        <p class="font-display text-2xl leading-relaxed tracking-[0.2em] text-ivory md:text-3xl">
          以东方织造，
          <br />
          致一世安眠。
        </p>
        <p class="mt-6 max-w-md text-sm leading-loose text-ivory/50">
          织云 ZHIYUN LIVING，38 年匠心织造。从绒源地到你的卧室，
          每一道工序都为了一夜好眠。
        </p>
        <router-link
          to="/shop"
          class="mt-8 inline-block border border-gold/60 px-6 py-3 text-[11px] uppercase tracking-[0.3em] text-gold transition-colors hover:bg-gold hover:text-ink"
        >
          进入官方商城 →
        </router-link>
      </div>
      <div class="md:justify-self-end">
        <p class="text-[11px] uppercase tracking-[0.35em] text-gold">Newsletter</p>
        <p class="mt-4 text-sm text-ivory/60">订阅织云生活美学志，第一时间获取新品与会员礼遇。</p>
        <form class="mt-6" @submit.prevent="onSubscribe">
          <p v-if="done" class="text-sm tracking-[0.15em] text-gold">订阅成功 — 愿每一夜，都有织云相伴。</p>
          <div v-else class="flex max-w-md border-b border-ivory/25 focus-within:border-gold">
            <input
              v-model="email"
              type="email"
              required
              placeholder="输入邮箱，订阅织云生活美学志"
              class="w-full bg-transparent py-3 text-sm text-ivory outline-none placeholder:text-ivory/35"
            />
            <button
              type="submit"
              class="cursor-pointer px-2 text-[11px] uppercase tracking-[0.3em] text-gold transition-colors hover:text-ivory"
            >
              订阅
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- 链接矩阵 -->
    <div class="wrap grid gap-10 py-14 sm:grid-cols-3 md:grid-cols-4">
      <div v-for="col in cols" :key="col.title">
        <p class="text-[11px] uppercase tracking-[0.35em] text-ivory/40">{{ col.title }}</p>
        <ul class="mt-5 space-y-3">
          <li v-for="l in col.links" :key="l.label">
            <router-link
              :to="l.href"
              class="text-sm tracking-[0.12em] text-ivory/70 transition-colors hover:text-gold"
            >
              {{ l.label }}
            </router-link>
          </li>
        </ul>
      </div>
      <div>
        <p class="text-[11px] uppercase tracking-[0.35em] text-ivory/40">关注我们</p>
        <ul class="mt-5 space-y-3 text-sm tracking-[0.12em] text-ivory/70">
          <li>微信公众号 · 织云家纺</li>
          <li>小红书 · @织云ZHIYUN</li>
          <li>微博 · @织云家纺</li>
          <li>抖音 · @织云家纺</li>
        </ul>
      </div>
    </div>

    <!-- 底栏 -->
    <div class="wrap flex flex-col items-center justify-between gap-4 border-t border-ivory/10 py-7 text-[11px] tracking-[0.2em] text-ivory/35 md:flex-row">
      <p>© 2026 织云家纺 ZHIYUN LIVING · 浙ICP备2026000000号-1</p>
      <div class="flex items-center gap-6">
        <span class="cursor-default transition-colors hover:text-ivory/70">天猫旗舰店</span>
        <span class="cursor-default transition-colors hover:text-ivory/70">京东旗舰店</span>
        <span class="cursor-default transition-colors hover:text-ivory/70">微信小程序</span>
      </div>
    </div>
  </footer>
</template>
