<script setup>
import { ref, computed, onMounted } from 'vue'
import { productApi } from '@/api'
import { pickDefaults, mergeContent } from '@/utils/siteContent'
import ProductCard from '@/components/ProductCard.vue'
import SectionHeading from '@/components/SectionHeading.vue'
import Reveal from '@/components/Reveal.vue'

const featured = ref([])
const hotSales = ref([])
const categories = ref([])

// 内容键：页面设计后台（/designer）可配置，未配置时使用全站默认值
const KEYS = ['shop.hero']
const content = ref(pickDefaults(KEYS))
const hero = computed(() => content.value['shop.hero'])

const services = [
  { t: '顺丰包邮', d: '48 小时内发出' },
  { t: '30 天退换', d: '无忧购物保障' },
  { t: '七星洗护', d: '会员终身照护' },
  { t: '正品承诺', d: '官方直营发货' },
]

onMounted(async () => {
  try {
    const res = await productApi.shop()
    featured.value = res.featured || []
    hotSales.value = res.hotSales || []
    categories.value = res.categories || []
    content.value = mergeContent(pickDefaults(KEYS), res.content || {})
  } catch (e) {
    // 静默：数据为空时各分区自然隐藏
  }
})
</script>

<template>
  <div>
    <!-- 商城促销横幅 -->
    <section class="relative -mt-[72px] flex h-[62vh] min-h-[440px] items-center overflow-hidden bg-ink">
      <img
        :src="hero.img"
        alt="ST.KELLY官方商城"
        class="absolute inset-0 h-full w-full object-cover"
      />
      <div class="absolute inset-0 bg-gradient-to-r from-ink/70 via-ink/30 to-transparent" />
      <div class="wrap relative z-10 animate-fade-up text-white">
        <p class="text-[14px] uppercase tracking-[0.4em] text-gold">
          {{ hero.eyebrow }}
        </p>
        <h1 class="mt-5 font-display text-4xl leading-snug tracking-[0.1em] md:text-5xl">
          {{ hero.title }}
        </h1>
        <p class="mt-4 max-w-xl whitespace-pre-line text-[15px] leading-loose text-white/75 md:text-base">
          {{ hero.sub }}
        </p>
        <div class="mt-8 flex flex-wrap gap-4">
          <router-link to="/products" class="btn-primary">
            逛产品展示
          </router-link>
          <router-link
            to="/products?cat=gifts"
            class="btn-ghost-light border-transparent hover:bg-transparent hover:text-white/80"
          >
            婚嫁礼盒 →
          </router-link>
        </div>
      </div>
    </section>

    <!-- 分类 -->
    <section v-if="categories.length" class="wrap py-16 md:py-20">
      <SectionHeading
        eyebrow="Categories"
        title="分类甄选"
        align="left"
      />
      <div class="mt-10 grid gap-px bg-ink/10 sm:grid-cols-2 lg:grid-cols-5">
        <Reveal
          v-for="(c, i) in categories"
          :key="c.slug"
          :delay="i * 70"
          class="h-full"
        >
          <router-link
            :to="`/products?cat=${c.slug}`"
            class="group flex h-full flex-col bg-linen p-7 transition-colors duration-500 hover:bg-ivory"
          >
            <span class="text-[14px] tracking-[0.3em] text-gold-deep">
              0{{ i + 1 }}
            </span>
            <h3 class="mt-4 font-display text-xl tracking-[0.2em] text-ink">
              {{ c.name }}
            </h3>
            <p class="mt-1 text-[13px] uppercase tracking-[0.25em] text-ink/75">
              {{ c.nameEn }}
            </p>
            <p class="mt-4 flex-1 text-[14px] leading-relaxed text-ink/80">
              {{ c.tagline }}
            </p>
            <span class="mt-6 text-[14px] tracking-[0.3em] text-ink/75 transition-all duration-500 group-hover:translate-x-1 group-hover:text-gold-deep">
              进入系列 →
            </span>
          </router-link>
        </Reveal>
      </div>
    </section>

    <!-- 当季精选 -->
    <section v-if="featured.length" class="bg-ivory py-16 md:py-24">
      <div class="wrap">
        <SectionHeading
          eyebrow="Featured"
          title="当季精选"
          desc="本季最具代表性的六件作品——以织造致敬睡眠。"
          align="left"
        />
        <div class="mt-12 grid gap-x-7 gap-y-16 sm:grid-cols-2 lg:grid-cols-3">
          <ProductCard
            v-for="(p, i) in featured"
            :key="p.slug"
            :p="p"
            :delay="(i % 3) * 100"
          />
        </div>
        <Reveal class="mt-16 text-center">
          <router-link to="/products" class="btn-ghost">
            查看产品展示
          </router-link>
        </Reveal>
      </div>
    </section>

    <!-- 热销榜单 -->
    <section v-if="hotSales.length" class="wrap py-16 md:py-24">
      <SectionHeading
        eyebrow="Best Sellers"
        title="热销榜单"
        desc="被 12,000+ ST.KELLY会员验证过的一夜好眠。"
        align="left"
      />
      <div class="mt-12 grid gap-px bg-ink/10 sm:grid-cols-2 lg:grid-cols-4">
        <Reveal
          v-for="(p, i) in hotSales"
          :key="p.slug"
          :delay="i * 80"
          class="h-full"
        >
          <router-link
            :to="`/products/${p.slug}`"
            class="group flex h-full flex-col bg-linen p-7"
          >
            <div class="flex items-baseline justify-between">
              <span class="font-display text-3xl text-ink/75">
                0{{ i + 1 }}
              </span>
              <span class="text-[13px] uppercase tracking-[0.25em] text-ink/75">
                已售 {{ p.sales.toLocaleString('zh-CN') }}
              </span>
            </div>
            <h3 class="mt-6 flex-1 font-display text-lg leading-relaxed tracking-[0.08em] text-ink transition-colors group-hover:text-gold-deep">
              {{ p.name }}
            </h3>
            <div class="mt-6 flex items-baseline justify-between border-t border-ink/10 pt-4">
              <span class="text-gold-deep">
                ¥{{ (p.priceFen / 100).toLocaleString('zh-CN') }}
              </span>
              <span class="text-[14px] tracking-[0.25em] text-ink/75 transition-colors group-hover:text-gold-deep">
                立即查看 →
              </span>
            </div>
          </router-link>
        </Reveal>
      </div>
    </section>

    <!-- 品牌横幅 -->
    <section class="relative overflow-hidden bg-ink py-16 md:py-20">
      <div class="wrap flex flex-col items-start justify-between gap-8 md:flex-row md:items-center">
        <div>
          <p class="text-[14px] uppercase tracking-[0.35em] text-gold">
            Since 1988
          </p>
          <p class="mt-4 font-display text-2xl leading-relaxed tracking-[0.15em] text-ivory md:text-3xl">
            每一床被芯背后，
            <br class="md:hidden" />
            是三十八年的织造传承。
          </p>
        </div>
        <router-link to="/story" class="btn-ghost-light shrink-0">
          品牌官网
        </router-link>
      </div>
    </section>

    <!-- 服务保障 -->
    <section class="wrap py-14">
      <div class="grid grid-cols-2 gap-8 text-center md:grid-cols-4">
        <Reveal
          v-for="(s, i) in services"
          :key="s.t"
          :delay="i * 70"
        >
          <p class="font-display text-lg tracking-[0.2em] text-ink">
            {{ s.t }}
          </p>
          <p class="mt-2 text-[14px] tracking-[0.15em] text-ink/75">{{ s.d }}</p>
        </Reveal>
      </div>
    </section>
  </div>
</template>
