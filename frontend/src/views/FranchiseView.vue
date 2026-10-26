<script setup>
import { ref, onMounted } from 'vue'
import BusinessForm from '@/components/BusinessForm.vue'
import Reveal from '@/components/Reveal.vue'
import { contentApi } from '@/api'
import { pickDefaults, mergeContent } from '@/utils/siteContent'

// 内容键：页面设计后台（/designer）可配置，未配置时使用全站默认值
const KEYS = ['franchise.hero', 'global.contact']

const content = ref(pickDefaults(KEYS))

onMounted(async () => {
  try {
    const data = await contentApi.all()
    content.value = mergeContent(pickDefaults(KEYS), data.content)
  } catch {
    // 静默失败，使用默认内容
  }
})
</script>

<template>
  <!-- 招商页：只保留英雄图，意向申请直接叠在图上，全页一屏 -->
  <section class="relative -mt-[72px] flex min-h-vh-screen items-center overflow-hidden bg-ink pb-16 pt-[104px]">
    <img
      :src="content['franchise.hero'].img"
      :alt="content['franchise.hero'].title"
      class="absolute inset-0 h-full w-full object-cover"
    />
    <div class="absolute inset-0 bg-ink/50" />
    <div class="wrap relative z-10 text-ivory">
      <p class="text-[14px] uppercase tracking-[0.45em] text-gold">{{ content['franchise.hero'].eyebrow }}</p>
      <h1 class="mt-5 font-display text-4xl leading-snug tracking-[0.1em] md:text-5xl">
        {{ content['franchise.hero'].title }}
      </h1>
      <p class="mt-4 max-w-xl text-[15px] leading-loose text-ivory/85">{{ content['franchise.hero'].sub }}</p>

      <div class="mt-10 grid gap-8 lg:grid-cols-2">
        <Reveal>
          <div class="flex h-full flex-col justify-center bg-ink/85 p-8 backdrop-blur-sm">
            <p class="text-[14px] uppercase tracking-[0.35em] text-gold">Contact</p>
            <h2 class="mt-4 font-display text-2xl leading-snug tracking-[0.1em]">
              与招商顾问
              <br />
              直接对话。
            </h2>
            <p class="mt-4 text-[15px] leading-loose text-ivory/85">
              提交意向后，你将获得：《ST.KELLY招商手册》电子版、所在城市的商圈评估与投资测算模型。
            </p>
            <div class="mt-6 space-y-2 text-[15px] tracking-[0.15em] text-ivory/80">
              <p>加盟热线 {{ content['global.contact'].hotline }}（{{ content['global.contact'].hours }}）</p>
              <p>{{ content['global.contact'].franchiseEmail }}</p>
            </div>
          </div>
        </Reveal>
        <Reveal :delay="120">
          <BusinessForm
            type="FRANCHISE"
            tag="加盟"
            title="加盟意向申请"
            desc="留下联系方式，招商顾问将在 1 个工作日内与你联系。"
          />
        </Reveal>
      </div>
    </div>
  </section>
</template>
