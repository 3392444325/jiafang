<script setup>
import { ref, onMounted } from 'vue'
import PageHero from '@/components/PageHero.vue'
import BusinessForm from '@/components/BusinessForm.vue'
import SectionHeading from '@/components/SectionHeading.vue'
import Reveal from '@/components/Reveal.vue'
import { contentApi } from '@/api'
import { pickDefaults, mergeContent } from '@/utils/siteContent'

// 内容键：页面设计后台（/designer）可配置，未配置时使用全站默认值
const KEYS = [
  'groupbuy.hero', 'groupbuy.scenes', 'groupbuy.steps',
  'groupbuy.promises', 'global.contact',
]

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
  <div class="pt-[72px]">
    <PageHero
      :img="content['groupbuy.hero'].img"
      :eyebrow="content['groupbuy.hero'].eyebrow"
      :title="content['groupbuy.hero'].title"
      :sub="content['groupbuy.hero'].sub"
    />

    <!-- 场景 -->
    <section class="wrap py-20 md:py-24">
      <SectionHeading
        eyebrow="Scenarios"
        title="三大定制场景"
        desc="从一床被子的心意，到一整栋楼的睡眠——ST.KELLY的定制不止于规格与绣字。"
      />
      <div class="mt-14 grid gap-10 md:grid-cols-3">
        <Reveal v-for="(s, i) in content['groupbuy.scenes']" :key="i" :delay="i * 100">
          <figure class="group overflow-hidden">
            <img
              :src="s.img"
              :alt="s.t"
              class="aspect-[4/3] w-full object-cover transition-transform duration-[1400ms] group-hover:scale-105"
            />
          </figure>
          <h3 class="mt-5 font-display text-xl tracking-[0.15em] text-ink">
            {{ s.t }}
          </h3>
          <p class="mt-3 text-[15px] leading-loose text-ink/75">{{ s.d }}</p>
        </Reveal>
      </div>
    </section>

    <!-- 流程 -->
    <section class="bg-ivory py-20 md:py-24">
      <div class="wrap">
        <SectionHeading
          eyebrow="Process"
          title="定制流程"
          desc="五步闭环，最快 15 天交付。"
        />
        <div class="mt-14 grid gap-px bg-ink/10 sm:grid-cols-3 lg:grid-cols-5">
          <Reveal v-for="(s, i) in content['groupbuy.steps']" :key="i" :delay="i * 80" class="h-full">
            <div class="flex h-full flex-col bg-linen p-7">
              <span class="font-display text-2xl text-gold-deep">
                0{{ i + 1 }}
              </span>
              <p class="mt-4 text-[15px] tracking-[0.2em] text-ink">{{ s }}</p>
            </div>
          </Reveal>
        </div>
        <Reveal class="mt-10 flex flex-wrap items-center justify-center gap-x-8 gap-y-3 text-[14px] tracking-[0.25em] text-ink/75">
          <span v-for="(p, i) in content['groupbuy.promises']" :key="i">{{ p }}</span>
        </Reveal>
      </div>
    </section>

    <!-- 表单 + 礼盒入口 -->
    <section class="wrap py-20 md:py-24">
      <div class="grid gap-12 lg:grid-cols-2">
        <Reveal>
          <div class="flex h-full flex-col justify-center bg-ink p-10 text-ivory">
            <p class="text-[14px] uppercase tracking-[0.35em] text-gold">
              Bulk Order
            </p>
            <h2 class="mt-5 font-display text-3xl leading-snug tracking-[0.1em]">
              批量定制，
              <br />
              从一份需求开始。
            </h2>
            <p class="mt-6 text-[15px] leading-loose text-ivory/85">
              50 件起订享批量价；300 件以上支持专属花型与包装定制，
              全程专属顾问跟进。
            </p>
            <div class="mt-8 space-y-2 text-[15px] tracking-[0.15em] text-ivory/80">
              <p>团购热线 {{ content['global.contact'].groupPhone }}</p>
              <p>{{ content['global.contact'].groupEmail }}</p>
            </div>
            <router-link
              :to="{ path: '/products', query: { cat: 'gifts' } }"
              class="btn-ghost-light mt-9 self-start"
            >
              逛礼盒系列 →
            </router-link>
          </div>
        </Reveal>
        <Reveal :delay="120">
          <BusinessForm
            type="GROUP_BUY"
            tag="团购"
            title="团购需求登记"
            desc="告诉我们你的场景与预算，顾问将回以整套方案与报价。"
          />
        </Reveal>
      </div>
    </section>
  </div>
</template>
