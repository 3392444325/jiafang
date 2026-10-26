<script setup>
import { ref, computed, onMounted } from 'vue'
import PageHero from '@/components/PageHero.vue'
import Reveal from '@/components/Reveal.vue'
import { contentApi } from '@/api'
import { pickDefaults, mergeContent } from '@/utils/siteContent'
import { ymd } from '@/utils/format'

// 内容键：页面设计后台（/designer）可配置，未配置时使用全站默认值
const KEYS = ['news.hero']
const content = ref(pickDefaults(KEYS))

const newsList = ref([])

// 接口失败 / 无已发布文章时的兜底展示数据（无 id，不跳详情页）
const FALLBACK_NEWS = [
  {
    date: '2026-08-28',
    cat: '新品发布',
    title: '「莫奈花园」第二季上市：把睡莲的黄昏，织进一套四件套',
    excerpt:
      '延续与前 GUCCI 印花设计总监的联名合作，第二季以《睡莲·黄昏》为灵感，新增四组暮金色号与十六色渐变直喷工艺，全球限量 3,000 套，每套附艺术家签名编号。',
  },
  {
    date: '2026-08-10',
    cat: '品牌新闻',
    title: 'ST.KELLY与前 GUCCI 印花设计总监完成三年续约',
    excerpt:
      '双方将在未来三年推出四季联名系列，并联合设立「东方织造印花实验室」。',
  },
  {
    date: '2026-07-20',
    cat: '媒体报道',
    title: '《时尚家居》年度榜单：ST.KELLY蝉联「年度鹅绒被」',
    excerpt:
      '评审团评价：「云绒」系列以 95 白鹅绒与 27 项原材检测，重新定义了国产高端被芯的标尺。',
  },
  {
    date: '2026-06-18',
    cat: '活动回顾',
    title: '世界睡眠日·深睡论坛在杭州西子湖畔举办',
    excerpt: 'ST.KELLY联合睡眠研究机构发布《城市深睡白皮书》，并预告「深睡 2.0」系列。',
  },
  {
    date: '2026-05-30',
    cat: '品牌新闻',
    title: '全国第 1,200 家门店落地成都 IFS',
    excerpt: '新店以「东方织造美术馆」为概念，陈列 38 年来 12 件典藏织品。',
  },
  {
    date: '2026-04-12',
    cat: '新品发布',
    title: '「青岚」天丝夏凉系列全新升级',
    excerpt: '全新兰精天丝 500 织法，接触瞬凉 1.8℃，凉而不冰。',
  },
  {
    date: '2026-03-08',
    cat: '媒体报道',
    title: '央视《大国匠心》专题记录：43 道工序的织造',
    excerpt: '镜头深入ST.KELLY工坊，记录一道被芯从绒朵到成品的完整旅程。',
  },
  {
    date: '2026-01-15',
    cat: '品牌新闻',
    title: 'ST.KELLY发布《2025 可持续发展报告》',
    excerpt: '原材可追溯率提升至 86%，循环再生计划全年回收旧被 4.2 万床。',
  },
]

const featuredArticle = computed(() => newsList.value.find((n) => n.featured) || newsList.value[0] || null)
const restNews = computed(() => newsList.value.filter((n) => n !== featuredArticle.value))

onMounted(async () => {
  try {
    const data = await contentApi.all()
    content.value = mergeContent(pickDefaults(KEYS), data.content)
    newsList.value = (data.news || []).map((n) => ({
      id: n.id,
      title: n.title,
      cat: n.category,
      date: ymd(n.publishedAt),
      excerpt: n.excerpt || '',
      cover: n.cover || '',
      featured: !!n.featured,
    }))
    if (!newsList.value.length) newsList.value = FALLBACK_NEWS
  } catch {
    // 静默失败，使用兜底数据
    newsList.value = FALLBACK_NEWS
  }
})
</script>

<template>
  <div class="pt-[72px]">
    <PageHero
      :img="content['news.hero'].img"
      :eyebrow="content['news.hero'].eyebrow"
      :title="content['news.hero'].title"
      :sub="content['news.hero'].sub"
    />

    <div class="wrap py-16 md:py-20">
      <!-- 头条 -->
      <Reveal>
        <component
          :is="featuredArticle.id ? 'router-link' : 'article'"
          v-if="featuredArticle"
          :to="featuredArticle.id ? '/news/' + featuredArticle.id : undefined"
          class="grid overflow-hidden border border-ink/10 bg-ivory md:grid-cols-2"
        >
          <img
            :src="featuredArticle.cover || '/images/heroes/hero-3.jpg'"
            :alt="featuredArticle.title"
            class="h-full max-h-[420px] w-full object-cover"
          />
          <div class="flex flex-col justify-center p-8 md:p-12">
            <div class="flex items-center gap-4 text-[14px] tracking-[0.25em] text-ink/75">
              <span class="bg-ink px-3 py-1 text-[13px] text-ivory">
                {{ featuredArticle.cat }}
              </span>
              <span>{{ featuredArticle.date }}</span>
            </div>
            <h2 class="mt-6 font-display text-2xl leading-snug tracking-[0.08em] text-ink md:text-3xl">
              {{ featuredArticle.title }}
            </h2>
            <p class="mt-5 text-[15px] leading-loose text-ink/75">
              {{ featuredArticle.excerpt }}
            </p>
            <p class="mt-8 text-[14px] uppercase tracking-[0.3em] text-gold-deep">
              阅读全文 →
            </p>
          </div>
        </component>
      </Reveal>

      <!-- 列表 -->
      <div class="mt-14 border-t border-ink/10">
        <Reveal v-for="(n, i) in restNews" :key="i" :delay="(i % 4) * 70">
          <component
            :is="n.id ? 'router-link' : 'article'"
            :to="n.id ? '/news/' + n.id : undefined"
            class="group flex flex-col gap-3 border-b border-ink/10 py-7 transition-colors sm:flex-row sm:items-center sm:gap-8"
          >
            <span class="w-24 shrink-0 text-[14px] tracking-[0.2em] text-ink/75">
              {{ n.date }}
            </span>
            <span class="w-20 shrink-0 border border-ink/15 px-2 py-1 text-center text-[13px] tracking-[0.2em] text-ink/80">
              {{ n.cat }}
            </span>
            <div class="min-w-0 flex-1">
              <h3 class="font-display text-lg leading-relaxed tracking-[0.05em] text-ink transition-colors group-hover:text-gold-deep">
                {{ n.title }}
              </h3>
              <p class="mt-1.5 text-[14px] leading-relaxed text-ink/80">
                {{ n.excerpt }}
              </p>
            </div>
            <span class="hidden shrink-0 text-[14px] uppercase tracking-[0.3em] text-ink/70 transition-colors group-hover:text-gold-deep sm:block">
              →
            </span>
          </component>
        </Reveal>
      </div>

      <Reveal class="mt-12 text-center">
        <p class="text-[14px] tracking-[0.25em] text-ink/75">
          媒体垂询：press@st-kelly.cn · 品牌资料包可致函获取
        </p>
      </Reveal>
    </div>
  </div>
</template>
