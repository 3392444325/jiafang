<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { productApi } from '@/api'
import ProductCard from '@/components/ProductCard.vue'
import Reveal from '@/components/Reveal.vue'

const route = useRoute()

const SORTS = [
  { key: 'default', label: '最新上架' },
  { key: 'price-asc', label: '价格从低到高' },
  { key: 'price-desc', label: '价格从高到低' },
  { key: 'sales', label: '热销优先' },
]

const cat = computed(() => route.query.cat || 'all')
const sort = computed(() => route.query.sort || 'default')
const kw = computed(() => (route.query.q || '').trim())

const eyebrow = ref('')
const title = ref('')
const desc = ref('')
const cards = ref([])
const categories = ref([])
const grouped = ref(false)
const groups = ref([])
const loaded = ref(false)

function buildQuery(patch = {}) {
  const params = new URLSearchParams({ cat: cat.value, sort: sort.value, ...patch })
  return `/products?${params.toString()}`
}

async function load() {
  loaded.value = false
  try {
    const res = await productApi.products({
      cat: route.query.cat || '',
      sort: sort.value,
      q: kw.value,
    })
    eyebrow.value = res.eyebrow
    title.value = res.title
    desc.value = res.desc
    cards.value = res.cards || []
    categories.value = res.categories || []
    grouped.value = !!res.grouped
    groups.value = []

    // 默认浏览模式：按分类分区呈现（需要逐分类拉取卡片）
    if (grouped.value && categories.value.length) {
      const results = await Promise.all(
        categories.value.map((c) =>
          productApi
            .products({ cat: c.slug, sort: 'default' })
            .then((r) => ({ category: c, cards: r.cards || [] }))
            .catch(() => ({ category: c, cards: [] }))
        )
      )
      groups.value = results.filter((g) => g.cards.length > 0)
    }
  } catch (e) {
    // 错误时保持空列表
    cards.value = []
    groups.value = []
  } finally {
    loaded.value = true
  }
}

onMounted(load)
watch(() => route.query, load)
</script>

<template>
  <div class="pt-[72px]">
    <!-- 页头横幅 -->
    <Reveal>
      <img
        src="/images/heroes/hero-1.jpg"
        alt="ST.KELLY产品"
        class="h-64 w-full object-cover md:h-80"
      />
    </Reveal>

    <!-- 页头 -->
    <div class="wrap pb-12 pt-16 text-center">
      <Reveal v-if="loaded">
        <p class="eyebrow">{{ eyebrow }}</p>
        <h1 class="mt-4 font-display text-4xl tracking-[0.15em] text-ink">
          {{ title }}
        </h1>
        <p class="mt-4 text-[15px] tracking-[0.2em] text-ink/80">
          {{ desc }}
        </p>
        <router-link
          v-if="kw"
          :to="sort === 'default' ? '/products' : `/products?sort=${sort}`"
          class="mt-5 inline-block text-[14px] uppercase tracking-[0.25em] text-gold-deep transition-colors hover:text-ink"
        >
          ✕ 清除搜索
        </router-link>
      </Reveal>
    </div>

    <!-- 筛选栏 -->
    <div class="hairline-t border-b border-ink/10">
      <div class="wrap flex flex-wrap items-center justify-between gap-4 py-4">
        <div class="flex flex-wrap items-center gap-x-7 gap-y-2 text-[15px] tracking-[0.15em]">
          <router-link
            :to="buildQuery({ cat: 'all' })"
            :class="cat === 'all' ? 'text-gold-deep' : 'text-ink/80 transition-colors hover:text-ink'"
          >
            全部
          </router-link>
          <router-link
            v-for="c in categories"
            :key="c.slug"
            :to="buildQuery({ cat: c.slug })"
            :class="cat === c.slug ? 'text-gold-deep' : 'text-ink/80 transition-colors hover:text-ink'"
          >
            {{ c.name }}
          </router-link>
        </div>
        <div class="flex flex-wrap items-center gap-x-5 gap-y-1 text-[14px] tracking-[0.15em] text-ink/75">
          <span class="uppercase tracking-[0.3em] text-ink/70">Sort</span>
          <router-link
            v-for="s in SORTS"
            :key="s.key"
            :to="buildQuery({ sort: s.key })"
            :class="sort === s.key ? 'text-gold-deep' : 'transition-colors hover:text-ink'"
          >
            {{ s.label }}
          </router-link>
        </div>
      </div>
    </div>

    <!-- 商品展示 -->
    <div class="wrap py-16">
      <div v-if="cards.length === 0" class="py-24 text-center">
        <p class="font-display text-2xl tracking-[0.15em] text-ink/75">
          {{ kw ? `未找到与「${kw}」相关的商品` : '该系列正在筹备中，敬请期待。' }}
        </p>
        <router-link to="/products" class="btn-primary mt-10">
          浏览产品展示
        </router-link>
      </div>
      <template v-else-if="grouped && groups.length > 0">
        <section
          v-for="g in groups"
          :key="g.category.slug"
          :id="`cat-${g.category.slug}`"
          class="border-t border-ink/10 first:border-t-0"
        >
          <div class="flex flex-wrap items-end justify-between gap-4 py-8 md:px-0">
            <div>
              <p class="text-[13px] uppercase tracking-[0.3em] text-gold-deep">
                0{{ String(g.category.sort).padStart(2, '0') }} · {{ g.category.nameEn }}
              </p>
              <h2 class="mt-2 font-display text-2xl tracking-[0.15em] text-ink">
                {{ g.category.name }}
              </h2>
              <p v-if="g.category.tagline" class="mt-1 text-[14px] tracking-[0.15em] text-ink/80">
                {{ g.category.tagline }}
              </p>
            </div>
            <router-link
              :to="`/products?cat=${g.category.slug}`"
              class="text-[14px] uppercase tracking-[0.25em] text-gold-deep transition-colors hover:text-ink"
            >
              查看整个系列 →
            </router-link>
          </div>
          <div class="grid gap-x-7 gap-y-16 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            <ProductCard
              v-for="(p, i) in g.cards"
              :key="p.slug"
              :p="p"
              :delay="(i % 4) * 90"
            />
          </div>
        </section>
      </template>
      <div v-else class="grid gap-x-7 gap-y-16 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        <ProductCard
          v-for="(p, i) in cards"
          :key="p.slug"
          :p="p"
          :delay="(i % 4) * 90"
        />
      </div>
    </div>
  </div>
</template>
