<script setup>
import { ref, onMounted } from 'vue'
import SectionHeading from '@/components/SectionHeading.vue'
import Reveal from '@/components/Reveal.vue'
import CountUp from '@/components/CountUp.vue'
import { contentApi } from '@/api'
import { pickDefaults, mergeContent } from '@/utils/siteContent'

// 内容键：页面设计后台（/designer）可配置，未配置时使用全站默认值
const KEYS = [
  'story.hero', 'story.timeline', 'story.crafts', 'story.materials',
  'story.stores', 'story.stats', 'story.service',
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
  <div>
    <!-- 品牌主视觉：负边距上提，使英雄图延伸到透明页头背后，避免顶部出现浅色横条 -->
    <section class="relative -mt-[72px] flex h-[72vh] min-h-[480px] items-center overflow-hidden bg-ink">
      <img
        :src="content['story.hero'].img"
        alt="ST.KELLY品牌"
        class="absolute inset-0 h-full w-full object-cover"
      />
      <div class="absolute inset-0 bg-ink/45" />
      <div class="wrap relative z-10 animate-fade-up text-center text-ivory">
        <p class="text-[14px] uppercase tracking-[0.45em] text-gold">
          {{ content['story.hero'].eyebrow }}
        </p>
        <h1 class="mt-6 font-display text-4xl leading-snug tracking-[0.1em] md:text-6xl">
          <span v-for="(line, li) in content['story.hero'].title.split('\n')" :key="li">
            <br v-if="li > 0" />{{ line }}
          </span>
        </h1>
        <p class="mx-auto mt-6 max-w-xl text-[15px] leading-loose text-ivory/85">
          {{ content['story.hero'].sub }}
        </p>
      </div>
    </section>

    <!-- 品牌哲学 -->
    <section class="wrap grid gap-14 py-20 md:grid-cols-2 md:py-28">
      <Reveal>
        <p class="eyebrow">Philosophy</p>
        <h2 class="mt-4 font-display text-3xl leading-snug tracking-wide text-ink">
          不赶时间，
          <br />
          只赶手艺。
        </h2>
      </Reveal>
      <Reveal :delay="120">
        <div class="space-y-5 text-[15px] leading-loose text-ink/80">
          <p>
            ST.KELLY相信，睡眠是最后的奢侈品——它无法被追赶，只能被照料。所以我们把
            95% 的预算花在看不见的地方：绒朵的蓬松度、缎纹的经纬密度、丝胎的定位针脚。
          </p>
          <p>
            我们也相信东方的克制之美：月白不必着色，暮金不必夺目。真正的高级，
            是让你在触到的一瞬间就安静下来。
          </p>
        </div>
      </Reveal>
    </section>

    <!-- 时间轴 -->
    <section class="bg-ivory py-20 md:py-28">
      <div class="wrap">
        <SectionHeading
          eyebrow="Milestones"
          title="ST.KELLY的三十八年"
          desc="从一匹手织真丝，到中国高端床品的代表名字。"
        />
        <div class="mx-auto mt-16 max-w-3xl">
          <Reveal v-for="(t, i) in content['story.timeline']" :key="i" :delay="i * 80">
            <div class="group flex gap-8 border-l border-ink/15 pb-10 pl-8 last:pb-0">
              <span class="relative -left-[41px] top-1 h-2.5 w-2.5 shrink-0 rounded-full border border-gold-deep bg-linen transition-colors duration-500 group-hover:bg-gold-deep" />
              <div>
                <p class="font-display text-2xl text-gold-deep">{{ t.year }}</p>
                <p class="mt-2 text-[15px] leading-loose text-ink/80">{{ t.text }}</p>
              </div>
            </div>
          </Reveal>
        </div>
        <Reveal class="mt-16 grid grid-cols-2 gap-y-10 text-center md:grid-cols-4">
          <div v-for="(s, i) in content['story.stats']" :key="i">
            <p class="font-display text-4xl text-gold-deep md:text-5xl">
              <CountUp :to="Number(s.to) || 0" :suffix="s.suffix" />
            </p>
            <p class="mt-2 text-[14px] tracking-[0.3em] text-ink/80">
              {{ s.label }}
            </p>
          </div>
        </Reveal>
      </div>
    </section>

    <!-- 用料甄选 -->
    <section class="bg-sand py-20 md:py-28">
      <div class="wrap">
        <SectionHeading
          eyebrow="Materials"
          title="用料甄选"
          desc="把 95% 的预算花在看不见的地方——六种原材，27 项入仓检测，从源头决定一夜好眠。"
        />
        <div class="mt-16 grid gap-x-7 gap-y-12 sm:grid-cols-2 lg:grid-cols-3">
          <Reveal v-for="(m, i) in content['story.materials']" :key="i" :delay="(i % 3) * 100">
            <div class="group">
              <div class="overflow-hidden bg-sand">
                <img
                  :src="m.img"
                  :alt="m.name"
                  class="aspect-[4/3] w-full object-cover transition-transform duration-[1400ms] ease-out group-hover:scale-[1.06]"
                />
              </div>
              <div class="mt-5 flex items-baseline justify-between">
                <h3 class="font-display text-xl tracking-[0.15em] text-ink">
                  {{ m.name }}
                </h3>
                <span class="text-[13px] uppercase tracking-[0.25em] text-gold-deep">
                  {{ m.origin }}
                </span>
              </div>
              <p class="mt-1 text-[13px] uppercase tracking-[0.3em] text-ink/75">
                {{ m.en }}
              </p>
              <p class="mt-3 text-[15px] leading-loose text-ink/75">
                {{ m.desc }}
              </p>
            </div>
          </Reveal>
        </div>
        <Reveal class="mt-14 flex flex-wrap items-center justify-center gap-x-8 gap-y-3 text-[14px] tracking-[0.25em] text-ink/75">
          <span>27 项原材入仓检测</span>
          <span class="text-gold-deep">·</span>
          <span>9 重出厂检控</span>
          <span class="text-gold-deep">·</span>
          <span>不合格原料现场销毁</span>
        </Reveal>
      </div>
    </section>

    <!-- 工艺 -->
    <section class="wrap py-20 md:py-28">
      <SectionHeading
        eyebrow="Craftsmanship"
        title="三重匠心"
        desc="原材、织造、检控——高级感从来不是设计出来的，是一道工序一道工序熬出来的。"
      />
      <div class="mt-16 grid gap-12 md:grid-cols-3">
        <Reveal v-for="(c, i) in content['story.crafts']" :key="i" :delay="i * 110">
          <figure class="group overflow-hidden">
            <img
              :src="c.img"
              :alt="c.t"
              class="aspect-[4/3] w-full object-cover transition-transform duration-[1400ms] group-hover:scale-105"
            />
          </figure>
          <p class="mt-6 font-display text-2xl text-gold-deep">{{ c.n }}</p>
          <h3 class="mt-2 font-display text-xl tracking-[0.15em] text-ink">
            {{ c.t }}
          </h3>
          <p class="mt-3 text-[15px] leading-loose text-ink/75">{{ c.d }}</p>
        </Reveal>
      </div>
    </section>

    <!-- 会员服务 -->
    <section id="service" class="bg-ink py-20 md:py-28">
      <div class="wrap">
        <SectionHeading
          light
          eyebrow="Service"
          title="七星洗护 · 一生的照护"
          desc="ST.KELLY会员的每一床被褥，都享有终身洗护档案。"
        />
        <div class="mt-14 grid gap-8 md:grid-cols-4">
          <Reveal v-for="(s, i) in content['story.service']" :key="i" :delay="i * 90">
            <div class="border border-ivory/15 p-7 transition-colors duration-500 hover:border-gold/60">
              <p class="font-display text-lg tracking-[0.2em] text-gold">
                {{ s.t }}
              </p>
              <p class="mt-3 text-[15px] leading-loose text-ivory/80">{{ s.d }}</p>
            </div>
          </Reveal>
        </div>
      </div>
    </section>

    <!-- 门店与渠道 -->
    <section id="stores" class="wrap py-20 md:py-28">
      <SectionHeading
        eyebrow="Boutiques"
        title="线下门店与购买渠道"
        desc="1000+ 门店覆盖全国 700 余城，欢迎到店体验真实的云。"
      />
      <div class="mt-14 grid gap-px bg-ink/10 sm:grid-cols-2 lg:grid-cols-4">
        <Reveal v-for="(s, i) in content['story.stores']" :key="i" :delay="i * 80" class="h-full">
          <div class="flex h-full flex-col bg-linen p-7">
            <p class="text-[13px] uppercase tracking-[0.3em] text-gold-deep">
              {{ s.city }}
            </p>
            <p class="mt-3 font-display text-lg tracking-[0.12em] text-ink">
              {{ s.name }}
            </p>
            <p class="mt-2 flex-1 text-[14px] leading-relaxed text-ink/80">
              {{ s.addr }}
            </p>
          </div>
        </Reveal>
      </div>
      <Reveal class="mt-12 text-center">
        <p class="text-[14px] tracking-[0.2em] text-ink/75">
          更多购买渠道：天猫旗舰店 · 京东旗舰店 · 微信小程序「ST.KELLY」 · 抖音直播间
        </p>
        <router-link to="/products" class="btn-primary mt-8">
          进入系列甄选
        </router-link>
      </Reveal>
    </section>
  </div>
</template>
