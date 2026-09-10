<script setup>
import PageHero from '@/components/PageHero.vue'
import SectionHeading from '@/components/SectionHeading.vue'
import Reveal from '@/components/Reveal.vue'

const PERKS = [
  { t: '员工内购', d: '全线产品内购价，年度四件套礼遇' },
  { t: '带薪年假', d: '入司即享 10 天起，随年资递增' },
  { t: '睡眠关怀', d: '每季一次深睡测评与睡眠组合调优' },
  { t: '成长通道', d: '双通道晋升：专家线与管理线并行' },
  { t: '节日礼盒', d: '传统节日的限定织物与伴手礼' },
  { t: '健康保障', d: '补充医疗体检与健身补贴' },
]

const JOBS = [
  {
    dept: '门店零售',
    items: [
      { name: '门店店长', city: '杭州', type: '全职', req: '3 年以上零售团队管理经验' },
      { name: '高级导购顾问', city: '上海', type: '全职', req: '懂织物、爱分享，服务意识强' },
    ],
  },
  {
    dept: '电子商务',
    items: [
      { name: '电商运营专员', city: '杭州', type: '全职', req: '天猫 / 京东平台运营经验' },
      { name: '直播运营', city: '杭州', type: '全职', req: '家纺或服饰类目直播经验' },
    ],
  },
  {
    dept: '产品与设计',
    items: [
      { name: '家纺产品设计师', city: '杭州', type: '全职', req: '花型 / 图案设计，东方审美' },
      { name: '面料开发工程师', city: '南通', type: '全职', req: '熟悉贡缎、天丝织造工艺' },
    ],
  },
  {
    dept: '供应链与职能',
    items: [
      { name: '原材采购经理', city: '杭州', type: '全职', req: '绒毛 / 蚕丝品类采购经验优先' },
      { name: 'HRBP', city: '杭州', type: '全职', req: '零售或制造行业背景优先' },
    ],
  },
]
</script>

<template>
  <div class="pt-[72px]">
    <PageHero
      img="/images/scenes/scene-3.svg"
      eyebrow="Careers"
      title="加入织云"
      sub="与三代织人同行，把值得传家的手艺，做给更多人。"
    />

    <!-- 理念 -->
    <section class="wrap grid gap-12 py-20 md:grid-cols-2 md:py-24">
      <Reveal>
        <p class="eyebrow">Philosophy</p>
        <h2 class="mt-4 font-display text-3xl leading-snug tracking-wide text-ink">
          慢工出细活，
          <br />
          也出人才。
        </h2>
      </Reveal>
      <Reveal :delay="120">
        <div class="space-y-5 text-[15px] leading-loose text-ink/70">
          <p>
            织云相信，好的织物与好的人才一样——需要时间。我们不追赶扩张的速度，
            只为愿意沉下来的人，准备一条足够长的跑道。
          </p>
          <p>
            从工坊到门店，从云端的系统到指尖的针脚，
            每一个岗位都是「睡个好觉」这件事的一部分。
          </p>
        </div>
      </Reveal>
    </section>

    <!-- 福利 -->
    <section class="bg-ivory py-20 md:py-24">
      <div class="wrap">
        <SectionHeading
          eyebrow="Benefits"
          title="在织云，你将拥有"
          desc="让照顾别人睡眠的人，先被好好照顾。"
        />
        <div class="mt-14 grid gap-px bg-ink/10 sm:grid-cols-2 lg:grid-cols-3">
          <Reveal v-for="(p, i) in PERKS" :key="p.t" :delay="(i % 3) * 90" class="h-full">
            <div class="h-full bg-linen p-8">
              <h3 class="font-display text-lg tracking-[0.2em] text-gold-deep">
                {{ p.t }}
              </h3>
              <p class="mt-3 text-sm leading-loose text-ink/60">
                {{ p.d }}
              </p>
            </div>
          </Reveal>
        </div>
      </div>
    </section>

    <!-- 职位 -->
    <section class="wrap py-20 md:py-24">
      <SectionHeading eyebrow="Open Positions" title="在招职位" align="left" />
      <div class="mt-12 space-y-12">
        <div v-for="g in JOBS" :key="g.dept">
          <Reveal>
            <h3 class="flex items-baseline gap-4 border-b border-ink/10 pb-4">
              <span class="font-display text-xl tracking-[0.15em] text-ink">
                {{ g.dept }}
              </span>
              <span class="text-[10px] uppercase tracking-[0.3em] text-ink/35">
                {{ g.items.length }} open
              </span>
            </h3>
          </Reveal>
          <div class="divide-y divide-ink/10">
            <Reveal v-for="j in g.items" :key="j.name">
              <div class="group flex flex-wrap items-center gap-x-8 gap-y-2 py-5">
                <p class="min-w-44 flex-1 font-display text-lg tracking-[0.08em] text-ink transition-colors group-hover:text-gold-deep">
                  {{ j.name }}
                </p>
                <span class="text-xs tracking-[0.2em] text-ink/45">
                  {{ j.city }}
                </span>
                <span class="text-xs tracking-[0.2em] text-ink/45">
                  {{ j.type }}
                </span>
                <span class="hidden flex-1 text-xs leading-relaxed text-ink/45 lg:block">
                  {{ j.req }}
                </span>
                <a
                  :href="'mailto:hr@zhiyun.cn?subject=' + encodeURIComponent('应聘-' + j.name)"
                  class="border border-ink/20 px-5 py-2 text-[11px] uppercase tracking-[0.25em] text-ink/70 transition-colors hover:border-gold-deep hover:text-gold-deep"
                >
                  申请
                </a>
              </div>
            </Reveal>
          </div>
        </div>
      </div>
      <Reveal class="mt-14 text-center">
        <p class="text-[11px] tracking-[0.25em] text-ink/40">
          未列出心仪的岗位？简历直投 hr@zhiyun.cn，人才库常年开放。
        </p>
      </Reveal>
    </section>
  </div>
</template>
