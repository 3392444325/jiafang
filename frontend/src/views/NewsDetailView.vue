<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { contentApi } from '@/api'
import { ymd } from '@/utils/format'

const route = useRoute()
const article = ref(null)
const error = ref('')

onMounted(async () => {
  try {
    article.value = await contentApi.newsDetail(route.params.id)
    document.title = article.value.title
  } catch (e) {
    error.value = e.message || '文章不存在或未发布'
  }
})
</script>

<template>
  <div class="pt-[72px]">
    <div class="wrap py-16 md:py-20">
      <!-- 加载失败 / 文章不存在 -->
      <div v-if="error" class="py-24 text-center">
        <p class="font-display text-2xl tracking-[0.1em] text-ink/80">
          {{ error }}
        </p>
        <router-link
          to="/news"
          class="mt-8 inline-block text-[14px] uppercase tracking-[0.3em] text-gold-deep transition-colors hover:text-ink"
        >
          ← 返回品牌动态
        </router-link>
      </div>

      <!-- 文章正文 -->
      <article v-else-if="article" class="mx-auto max-w-3xl">
        <div class="flex items-center gap-4 text-[14px] tracking-[0.25em] text-ink/75">
          <span class="bg-ink px-3 py-1 text-[13px] text-ivory">{{ article.category }}</span>
          <span>{{ ymd(article.publishedAt) }}</span>
        </div>
        <h1 class="mt-6 font-display text-3xl leading-snug tracking-[0.08em] text-ink">
          {{ article.title }}
        </h1>
        <p class="mt-5 text-[15px] leading-loose text-ink/75">
          {{ article.excerpt }}
        </p>
        <img
          :src="article.cover || '/images/heroes/hero-3.jpg'"
          :alt="article.title"
          class="mt-8 aspect-[16/9] w-full object-cover"
        />
        <div class="mt-8 space-y-6">
          <p
            v-for="(p, i) in (article.content || '').split('\n').filter((line) => line.trim())"
            :key="i"
            class="text-[15px] leading-loose text-ink/85"
          >
            {{ p }}
          </p>
        </div>
        <div class="mt-14 border-t border-ink/10 pt-8">
          <router-link
            to="/news"
            class="text-[14px] uppercase tracking-[0.3em] text-gold-deep transition-colors hover:text-ink"
          >
            ← 返回品牌动态
          </router-link>
        </div>
      </article>
    </div>
  </div>
</template>
