<script setup>
import PageHero from '@/components/PageHero.vue'
import BusinessForm from '@/components/BusinessForm.vue'
import SectionHeading from '@/components/SectionHeading.vue'
import Reveal from '@/components/Reveal.vue'
import CountUp from '@/components/CountUp.vue'

const STATS = [
  { to: 1200, suffix: '+', label: '家线下门店' },
  { to: 700, suffix: '+', label: '座覆盖城市' },
  { to: 38, suffix: '', label: '年品牌传承' },
  { to: 92, suffix: '%', label: '加盟续约率' },
]

const SUPPORTS = [
  { n: '壹', t: '选址评估', d: '商圈客流与竞争测算，总部一城一策出具选址报告。' },
  { n: '贰', t: '装修设计', d: 'SI 标准空间设计，装修补贴与统一物料配送。' },
  { n: '叁', t: '培训体系', d: '产品、陈列、销售 21 天驻店实训，考核上岗。' },
  { n: '肆', t: '开业带教', d: '督导驻店 30 天，从开业活动到会员沉淀全程带教。' },
  { n: '伍', t: '营销支持', d: '全年四大营销节点方案与物料，总部直播导流。' },
  { n: '陆', t: '数字系统', d: '会员、库存、洗护档案一体化系统，总部云端赋能。' },
]

const REQUIREMENTS = [
  '认同「织云」品牌理念与东方美学的经营方向',
  '临街或商场铺位 80㎡ 以上，具备消防安全条件',
  '具备充足的启动资金与流动资金',
  '有零售、家居或服装行业经验者优先',
]

const STEPS = ['咨询洽谈', '资质评估', '签约授权', '选址装修', '培训开业']
</script>

<template>
  <div class="pt-[72px]">
    <PageHero
      img="/images/scenes/scene-5.svg"
      eyebrow="Franchise"
      title="招商加盟"
      sub="与织云同行，把「睡个好觉」的生意带到你的城市。一城一策，共创长期价值。"
    />

    <!-- 数字 -->
    <section class="wrap grid grid-cols-2 gap-y-10 py-16 text-center md:grid-cols-4 md:py-20">
      <Reveal v-for="(s, i) in STATS" :key="s.label" :delay="i * 80">
        <p class="font-display text-4xl text-gold-deep md:text-5xl">
          <CountUp :to="s.to" :suffix="s.suffix" />
        </p>
        <p class="mt-3 text-[11px] tracking-[0.3em] text-ink/50">
          {{ s.label }}
        </p>
      </Reveal>
    </section>

    <!-- 六大支持 -->
    <section class="bg-ivory py-20 md:py-24">
      <div class="wrap">
        <SectionHeading
          eyebrow="Support"
          title="六大总部支持"
          desc="从选址到开业，总部团队全程陪跑——你负责经营，织云负责后盾。"
        />
        <div class="mt-14 grid gap-px bg-ink/10 sm:grid-cols-2 lg:grid-cols-3">
          <Reveal v-for="(s, i) in SUPPORTS" :key="s.t" :delay="(i % 3) * 90" class="h-full">
            <div class="flex h-full flex-col bg-linen p-8">
              <p class="font-display text-2xl text-gold-deep">{{ s.n }}</p>
              <h3 class="mt-4 font-display text-xl tracking-[0.15em] text-ink">
                {{ s.t }}
              </h3>
              <p class="mt-3 flex-1 text-sm leading-loose text-ink/60">
                {{ s.d }}
              </p>
            </div>
          </Reveal>
        </div>
      </div>
    </section>

    <!-- 条件与流程 -->
    <section class="wrap grid gap-14 py-20 md:grid-cols-2 md:py-24">
      <Reveal>
        <p class="eyebrow">Requirements</p>
        <h2 class="mt-4 font-display text-3xl tracking-[0.12em] text-ink">
          加盟条件
        </h2>
        <ul class="mt-8 space-y-5">
          <li
            v-for="r in REQUIREMENTS"
            :key="r"
            class="flex items-start gap-4 text-sm leading-loose text-ink/70"
          >
            <span class="mt-1.5 h-2 w-2 shrink-0 rotate-45 bg-gold-deep" />
            {{ r }}
          </li>
        </ul>
      </Reveal>
      <Reveal :delay="120">
        <p class="eyebrow">Process</p>
        <h2 class="mt-4 font-display text-3xl tracking-[0.12em] text-ink">
          加盟流程
        </h2>
        <ol class="mt-8">
          <li
            v-for="(s, i) in STEPS"
            :key="s"
            class="flex items-center gap-5 border-b border-ink/10 py-4 last:border-0"
          >
            <span class="font-display text-lg text-gold-deep">
              0{{ i + 1 }}
            </span>
            <span class="text-sm tracking-[0.2em] text-ink/75">{{ s }}</span>
          </li>
        </ol>
      </Reveal>
    </section>

    <!-- 意向申请 -->
    <section class="wrap pb-24">
      <div class="grid gap-12 lg:grid-cols-2">
        <Reveal>
          <div class="flex h-full flex-col justify-center bg-ink p-10 text-ivory">
            <p class="text-[11px] uppercase tracking-[0.35em] text-gold">
              Contact
            </p>
            <h2 class="mt-5 font-display text-3xl leading-snug tracking-[0.1em]">
              与招商顾问
              <br />
              直接对话。
            </h2>
            <p class="mt-6 text-sm leading-loose text-ivory/60">
              提交意向后，你将获得：《织云招商手册》电子版、所在城市的商圈评估与投资测算模型。
            </p>
            <div class="mt-8 space-y-2 text-sm tracking-[0.15em] text-ivory/80">
              <p>加盟热线 400-860-1988（9:00 - 21:00）</p>
              <p>franchise@zhiyun.cn</p>
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
    </section>
  </div>
</template>
