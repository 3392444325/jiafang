<script setup>
import { ref, onMounted } from 'vue'
import HeroCarousel from '@/components/HeroCarousel.vue'
import SectionHeading from '@/components/SectionHeading.vue'
import Reveal from '@/components/Reveal.vue'
import CountUp from '@/components/CountUp.vue'
import { productApi } from '@/api'

const slides = [
  {
    src: '/images/heroes/hero-1.svg',
    eyebrow: 'ZHIYUN LIVING · Since 1988',
    title: '以东方织造，\n致一世安眠',
    sub: '三十八年，三代织人，一件事：把「睡个好觉」，做成值得传家的东西。',
    href: '/story',
    cta: '走进品牌',
  },
  {
    src: '/images/heroes/hero-2.svg',
    eyebrow: 'Craftsmanship · 匠心',
    title: '不赶时间，只赶手艺',
    sub: '绒朵、长丝与贡缎——95% 的预算花在看不见的地方。27 项原材检测，43 道出厂工序。',
    href: '/story',
    cta: '了解匠心',
  },
  {
    src: '/images/heroes/hero-3.svg',
    eyebrow: 'Master Collaboration · 大师联名',
    title: '当莫奈的睡莲，\n开在枕畔',
    sub: '与前GUCCI印花设计总监联名，十六色渐变直喷——艺术家纺，自此有了模样。',
    href: '/shop',
    cta: '走进官方商城',
  },
]

const stats = [
  { to: 38, suffix: '', label: '年织造传承' },
  { to: 1200, suffix: '+', label: '线下门店覆盖' },
  { to: 60, suffix: '+', label: '项工艺专利' },
  { to: 98, suffix: '%', label: '会员好评率' },
]

const categories = ref([])
const reviews = ref([])
const collab = ref(null)

function yuan(fen) {
  if (fen == null) return ''
  return `¥${(fen / 100).toLocaleString('zh-CN', { maximumFractionDigits: 0 })}`
}
function maskName(name) {
  const n = (name || '').trim()
  if (!n) return '匿名用户'
  if (/^[\u4e00-\u9fa5]+$/.test(n)) {
    return n.length <= 1 ? `${n}**` : `${n[0]}${'*'.repeat(Math.min(n.length - 1, 2))}`
  }
  return `${n[0]}${'*'.repeat(Math.max(n.length - 1, 2))}`
}
function firstImg(raw) {
  if (!raw) return '/images/scenes/scene-1.svg'
  try {
    const arr = typeof raw === 'string' ? JSON.parse(raw) : raw
    return Array.isArray(arr) && arr.length ? arr[0] : '/images/scenes/scene-1.svg'
  } catch {
    return '/images/scenes/scene-1.svg'
  }
}
function catImg(c) {
  return c.image || '/images/scenes/scene-1.svg'
}

onMounted(async () => {
  try {
    const data = await productApi.home()
    categories.value = data.categories || []
    reviews.value = data.reviews || []
    collab.value = data.collab || null
  } catch {
    // 静默失败，保留空状态
  }
})
</script>

<template>
  <div>
  <HeroCarousel :slides="slides" />

  <!-- 品牌宣言 -->
  <section class="relative overflow-hidden bg-ink py-24 md:py-32">
    <p class="v-text absolute left-8 top-1/2 hidden -translate-y-1/2 text-[10px] text-ivory/25 lg:block">
      以东方织造 · 致一世安眠
    </p>
    <div class="wrap">
      <SectionHeading
        light
        eyebrow="Philosophy"
        title="织云，织的是时间"
        desc="从一颗茧、一束绒到一寸缎，织云坚持最古老的方式：不赶时间，只赶手艺。我们把「睡个好觉」这件事，做成了值得传家的东西。"
      />
      <div class="mt-16 grid grid-cols-2 gap-y-12 md:grid-cols-4">
        <Reveal v-for="(s, i) in stats" :key="s.label" :delay="i * 100">
          <div class="text-center">
            <p class="font-display text-5xl text-gold md:text-6xl">
              <CountUp :to="s.to" :suffix="s.suffix" />
            </p>
            <p class="mt-3 text-[11px] tracking-[0.3em] text-ivory/50">
              {{ s.label }}
            </p>
          </div>
        </Reveal>
      </div>
    </div>
  </section>

  <!-- 系列甄选(品牌呈现,不含价格) -->
  <section class="wrap py-20 md:py-28">
    <SectionHeading
      eyebrow="Collections"
      title="五大系列"
      desc="为每一种睡眠而生——被芯、枕芯、床品套件、夏凉与礼盒，一贯之的东方织造。"
    />
    <div class="mt-16 grid gap-x-7 gap-y-14 sm:grid-cols-2 lg:grid-cols-5">
      <Reveal v-for="(c, i) in categories" :key="c.slug" :delay="i * 90">
        <router-link :to="{ path: '/products', query: { cat: c.slug } }" class="group block">
          <div class="overflow-hidden bg-sand">
            <img
              :src="catImg(c)"
              :alt="c.name"
              class="aspect-[4/5] w-full object-cover transition-transform duration-[1400ms] ease-out group-hover:scale-[1.06]"
            />
          </div>
          <p class="mt-5 text-center text-[10px] uppercase tracking-[0.3em] text-gold-deep">
            0{{ i + 1 }} · {{ c.nameEn }}
          </p>
          <h3 class="mt-2 text-center font-display text-xl tracking-[0.2em] text-ink">
            {{ c.name }}
          </h3>
          <p class="mt-2 text-center text-xs leading-relaxed text-ink/50">
            {{ c.tagline }}
          </p>
          <p class="mt-4 text-center text-[11px] tracking-[0.3em] text-ink/40 transition-colors duration-500 group-hover:text-gold-deep">
            了解系列 →
          </p>
        </router-link>
      </Reveal>
    </div>
  </section>

  <!-- 大师联名 · 编辑式聚焦(首页独家) -->
  <section v-if="collab && collab.status === 'ACTIVE'" class="relative overflow-hidden bg-ink py-20 md:py-28">
    <p class="v-text absolute right-8 top-1/2 hidden -translate-y-1/2 text-[10px] text-ivory/25 lg:block">
      艺术家纺 · 限量发售
    </p>
    <div class="wrap grid items-center gap-14 lg:grid-cols-2 lg:gap-20">
      <Reveal>
        <div class="relative">
          <img
            :src="firstImg(collab.images)"
            :alt="collab.name"
            class="aspect-[4/5] w-full object-cover"
          />
          <div class="absolute -bottom-7 -right-7 hidden w-2/5 border-[10px] border-ink md:block">
            <img
              src="/images/scenes/scene-4.svg"
              alt="联名细节"
              class="aspect-square w-full object-cover"
            />
          </div>
          <span class="absolute left-5 top-5 bg-ivory px-3.5 py-1.5 text-[10px] uppercase tracking-[0.3em] text-ink">
            Master Collab
          </span>
        </div>
      </Reveal>
      <Reveal :delay="140">
        <p class="eyebrow !text-gold">Master Collaboration</p>
        <h2 class="mt-4 font-display text-3xl leading-snug tracking-[0.1em] text-ivory md:text-4xl">
          当莫奈的睡莲，
          <br />
          开在枕畔。
        </h2>
        <div class="mt-5 h-px w-14 bg-gold" />
        <p class="mt-6 max-w-lg text-sm leading-loose text-ivory/60">
          与前 GUCCI 印花设计总监联手的艺术家纺系列——十六色渐变直喷工艺，
          将《睡莲》的光影移植到 100 支贡缎之上。
        </p>
        <ul class="mt-8 space-y-4 text-sm tracking-[0.1em] text-ivory/75">
          <li class="flex items-baseline gap-4">
            <span class="font-display text-lg text-gold">壹</span>
            十六色渐变直喷，色牢度 4 级以上
          </li>
          <li class="flex items-baseline gap-4">
            <span class="font-display text-lg text-gold">贰</span>
            100 支贡缎 · A 类母婴级安全标准
          </li>
          <li class="flex items-baseline gap-4">
            <span class="font-display text-lg text-gold">叁</span>
            全球限量 3,000 套 · 艺术家签名编号
          </li>
        </ul>
        <div class="mt-10 flex flex-wrap items-center gap-8">
          <router-link :to="`/products/${collab.slug}`" class="btn-ghost-light">
            鉴赏联名之作
          </router-link>
          <div>
            <p class="text-[10px] uppercase tracking-[0.3em] text-ivory/40">
              联名价
            </p>
            <p class="mt-1.5 font-display text-2xl text-gold">
              {{ yuan(collab.priceFen) }}
              <span v-if="collab.compareAtFen" class="ml-3 text-sm text-ivory/35 line-through">
                {{ yuan(collab.compareAtFen) }}
              </span>
            </p>
          </div>
        </div>
      </Reveal>
    </div>
  </section>

  <!-- 口碑墙 -->
  <section class="wrap py-20 md:py-28">
    <SectionHeading
      eyebrow="Voices"
      title="一夜好眠的证言"
      desc="来自织云会员的真实评价。"
    />
    <div class="mt-14 grid gap-px bg-ink/10 md:grid-cols-3">
      <Reveal v-for="(r, i) in reviews" :key="r.id" :delay="(i % 3) * 90" class="h-full">
        <div class="flex h-full flex-col bg-linen p-8">
          <p class="tracking-[0.3em] text-gold">
            {{ '★'.repeat(r.rating) }}<span class="text-ink/20">{{ '☆'.repeat(5 - r.rating) }}</span>
          </p>
          <p class="mt-5 flex-1 text-sm leading-loose text-ink/75">
            「{{ r.content }}」
          </p>
          <p class="mt-6 text-[11px] tracking-[0.2em] text-ink/40">
            {{ maskName(r.userName) }} · 最近购买了 {{ r.productName }}
          </p>
        </div>
      </Reveal>
    </div>
  </section>

  <!-- 官方商城导流 -->
  <section class="wrap py-20 md:py-28">
    <Reveal>
      <div class="relative overflow-hidden bg-clay/40 px-8 py-16 text-center md:py-20">
        <p class="eyebrow">Official Store</p>
        <h2 class="mt-5 font-display text-3xl leading-snug tracking-[0.15em] text-ink md:text-4xl">
          织云官方商城
        </h2>
        <p class="mx-auto mt-5 max-w-lg text-sm leading-loose text-ink/60">
          当季甄选新品，顺丰包邮、30 天无忧退换，会员尊享生日臻礼与七星洗护。
        </p>
        <div class="mt-9 flex flex-wrap justify-center gap-4">
          <router-link to="/shop" class="btn-primary">
            进入官方商城
          </router-link>
          <router-link to="/story" class="btn-ghost">
            了解品牌
          </router-link>
        </div>
      </div>
    </Reveal>
  </section>

  <!-- 线下体验入口(完整门店列表见品牌故事) -->
  <section class="hairline-t">
    <div class="wrap flex flex-col items-center justify-between gap-8 py-14 text-center md:flex-row md:text-left">
      <div>
        <p class="eyebrow">Boutiques</p>
        <p class="mt-3 font-display text-xl leading-relaxed tracking-[0.12em] text-ink md:text-2xl">
          全国 1,200+ 门店，欢迎到店体验「真实的云」
        </p>
        <p class="mt-2 text-[11px] tracking-[0.25em] text-ink/45">
          杭州 · 上海 · 北京 · 成都 —— 门店地址与购买渠道一览
        </p>
      </div>
      <router-link to="/story#stores" class="btn-ghost shrink-0">
        查看门店与渠道
      </router-link>
    </div>
  </section>
  </div>
</template>
