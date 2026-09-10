<script setup>
import PageHero from '@/components/PageHero.vue'
import BusinessForm from '@/components/BusinessForm.vue'
import SectionHeading from '@/components/SectionHeading.vue'
import Reveal from '@/components/Reveal.vue'

const SCENES = [
  {
    img: '/images/scenes/scene-2.svg',
    t: '企业福利',
    d: '员工生日礼、节日关怀与年度健康睡眠礼盒，批量价与专属包装。',
  },
  {
    img: '/images/scenes/scene-5.svg',
    t: '婚庆回礼',
    d: '十件套新婚礼盒与伴手礼定制，绣字、礼卡与贺词一站式。',
  },
  {
    img: '/images/scenes/scene-3.svg',
    t: '酒店工程',
    d: '民宿、酒店与地产精装项目，阻燃与白鹅绒等级按需定制。',
  },
]

const STEPS = ['需求沟通', '方案报价', '打样确认', '生产交付', '售后跟踪']

const PROMISES = ['专属顾问', '免费打样', '批量优惠', '顺丰物流', '支持开票']
</script>

<template>
  <div class="pt-[72px]">
    <PageHero
      img="/images/scenes/scene-4.svg"
      eyebrow="Corporate & Bulk"
      title="团购定制"
      sub="企业福利、婚庆回礼与工程定制——以批量价格，享品牌级品质与服务。"
    />

    <!-- 场景 -->
    <section class="wrap py-20 md:py-24">
      <SectionHeading
        eyebrow="Scenarios"
        title="三大定制场景"
        desc="从一床被子的心意，到一整栋楼的睡眠——织云的定制不止于规格与绣字。"
      />
      <div class="mt-14 grid gap-10 md:grid-cols-3">
        <Reveal v-for="(s, i) in SCENES" :key="s.t" :delay="i * 100">
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
          <p class="mt-3 text-sm leading-loose text-ink/60">{{ s.d }}</p>
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
          <Reveal v-for="(s, i) in STEPS" :key="s" :delay="i * 80" class="h-full">
            <div class="flex h-full flex-col bg-linen p-7">
              <span class="font-display text-2xl text-gold-deep">
                0{{ i + 1 }}
              </span>
              <p class="mt-4 text-sm tracking-[0.2em] text-ink">{{ s }}</p>
            </div>
          </Reveal>
        </div>
        <Reveal class="mt-10 flex flex-wrap items-center justify-center gap-x-8 gap-y-3 text-[11px] tracking-[0.25em] text-ink/45">
          <span v-for="p in PROMISES" :key="p">{{ p }}</span>
        </Reveal>
      </div>
    </section>

    <!-- 表单 + 礼盒入口 -->
    <section class="wrap py-20 md:py-24">
      <div class="grid gap-12 lg:grid-cols-2">
        <Reveal>
          <div class="flex h-full flex-col justify-center bg-ink p-10 text-ivory">
            <p class="text-[11px] uppercase tracking-[0.35em] text-gold">
              Bulk Order
            </p>
            <h2 class="mt-5 font-display text-3xl leading-snug tracking-[0.1em]">
              批量定制，
              <br />
              从一份需求开始。
            </h2>
            <p class="mt-6 text-sm leading-loose text-ivory/60">
              50 件起订享批量价；300 件以上支持专属花型与包装定制，
              全程专属顾问跟进。
            </p>
            <div class="mt-8 space-y-2 text-sm tracking-[0.15em] text-ivory/80">
              <p>团购热线 400-860-1988 转 2</p>
              <p>group@zhiyun.cn</p>
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
