<script setup>
import PageHero from '@/components/PageHero.vue'
import BusinessForm from '@/components/BusinessForm.vue'
import SectionHeading from '@/components/SectionHeading.vue'
import Reveal from '@/components/Reveal.vue'

const CHANNELS = [
  {
    n: '01',
    t: '经销代理',
    d: '区域经销与专柜合作，共享品牌势能与供应链红利。',
    for: '区域零售商 / 百货渠道',
  },
  {
    n: '02',
    t: '酒店工程',
    d: '客房床品整体解决方案，按星级标准定制生产与洗护。',
    for: '酒店 / 民宿 / 地产精装',
  },
  {
    n: '03',
    t: '电商分销',
    d: '授权线上分销体系，专供货盘、内容素材与直播支持。',
    for: '电商平台 / MCN 机构',
  },
  {
    n: '04',
    t: '设计师联名',
    d: '花型共创与限量联名系列，共享艺术家纺的增量市场。',
    for: '设计师 / 艺术工作室',
  },
]

const PARTNERS = [
  '万象城',
  '恒隆广场',
  'SKP',
  '成都 IFS',
  '天猫',
  '京东',
  '微信小程序',
  '抖音电商',
]
</script>

<template>
  <div class="pt-[72px]">
    <PageHero
      img="/images/scenes/scene-1.svg"
      eyebrow="Partnership"
      title="商务合作"
      sub="渠道、工程与联名——织云期待与你的每一次相遇。"
    />

    <!-- 合作方式 -->
    <section class="wrap py-20 md:py-24">
      <SectionHeading
        eyebrow="Channels"
        title="四种合作方式"
        desc="无论你来自哪一条赛道，都能在织云找到合适的连接方式。"
      />
      <div class="mt-14 grid gap-px bg-ink/10 sm:grid-cols-2">
        <Reveal v-for="(c, i) in CHANNELS" :key="c.t" :delay="(i % 2) * 90" class="h-full">
          <div class="flex h-full flex-col bg-linen p-9">
            <span class="font-display text-2xl text-gold-deep">
              {{ c.n }}
            </span>
            <h3 class="mt-4 font-display text-xl tracking-[0.15em] text-ink">
              {{ c.t }}
            </h3>
            <p class="mt-3 flex-1 text-sm leading-loose text-ink/60">
              {{ c.d }}
            </p>
            <p class="mt-5 border-t border-ink/10 pt-4 text-[11px] tracking-[0.2em] text-ink/40">
              {{ c.for }}
            </p>
          </div>
        </Reveal>
      </div>
    </section>

    <!-- 伙伴 -->
    <section class="bg-ink py-16 md:py-20">
      <div class="wrap">
        <Reveal>
          <p class="text-center text-[11px] uppercase tracking-[0.35em] text-gold">
            Partners
          </p>
          <p class="mt-6 text-center font-display text-2xl tracking-[0.1em] text-ivory">
            他们，正与织云同行
          </p>
          <div class="mt-10 flex flex-wrap items-center justify-center gap-x-10 gap-y-4 text-sm tracking-[0.3em] text-ivory/55">
            <span v-for="p in PARTNERS" :key="p" class="transition-colors hover:text-gold">
              {{ p }}
            </span>
          </div>
        </Reveal>
      </div>
    </section>

    <!-- 表单 -->
    <section class="wrap py-20 md:py-24">
      <div class="grid gap-12 lg:grid-cols-2">
        <Reveal>
          <div class="flex h-full flex-col justify-center bg-ink p-10 text-ivory">
            <p class="text-[11px] uppercase tracking-[0.35em] text-gold">
              Contact
            </p>
            <h2 class="mt-5 font-display text-3xl leading-snug tracking-[0.1em]">
              一次交谈，
              <br />
              胜过十页方案。
            </h2>
            <p class="mt-6 text-sm leading-loose text-ivory/60">
              商务合作部将在 1 个工作日内响应，并为合适的伙伴安排线下深谈。
            </p>
            <div class="mt-8 space-y-2 text-sm tracking-[0.15em] text-ivory/80">
              <p>合作热线 400-860-1988 转 3</p>
              <p>partner@zhiyun.cn</p>
            </div>
          </div>
        </Reveal>
        <Reveal :delay="120">
          <BusinessForm
            type="COOPERATION"
            tag="合作"
            title="合作意向登记"
            desc="简述你的业务与合作方向即可。"
          />
        </Reveal>
      </div>
    </section>
  </div>
</template>
