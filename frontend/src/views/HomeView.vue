<script setup>
import { ref, computed, onMounted } from 'vue'
import HeroCarousel from '@/components/HeroCarousel.vue'
import { productApi } from '@/api'
import { pickDefaults, mergeContent, SITE_DEFAULTS } from '@/utils/siteContent'

// 内容键：页面设计后台（/designer）可配置，未配置时使用全站默认值
const KEYS = ['home.hero']
const content = ref(pickDefaults(KEYS))

const slides = computed(() => {
  const s = content.value['home.hero']?.slides
  return Array.isArray(s) && s.length ? s : SITE_DEFAULTS['home.hero'].slides
})

onMounted(async () => {
  try {
    const data = await productApi.home()
    content.value = mergeContent(pickDefaults(KEYS), data.content || {})
  } catch {
    // 静默失败，保留默认内容
  }
})
</script>

<template>
  <HeroCarousel :slides="slides" />
</template>
