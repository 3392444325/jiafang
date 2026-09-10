<script setup>
import SectionHeading from '@/components/SectionHeading.vue'
import Reveal from '@/components/Reveal.vue'
import CountUp from '@/components/CountUp.vue'

const timeline = [
  { year: '1988', text: '织云前身「云记织坊」创立于杭州，以一匹手织真丝起家。' },
  { year: '2004', text: '首个鹅绒被系列问世，确立「只做睡得起的奢侈品」之定位。' },
  { year: '2012', text: '启动全球原材臻选计划，深入西伯利亚绒带与江南蚕区。' },
  { year: '2018', text: '「深睡」系列荣获德国红点设计奖，中国床品首获此殊荣。' },
  { year: '2024', text: '与前GUCCI印花设计总监达成联名，艺术家纺进入大众视野。' },
  { year: '2026', text: '品牌全面升级为 ZHIYUN LIVING，以东方织造致一世安眠。' },
]

const crafts = [
  {
    img: '/images/scenes/scene-1.svg',
    n: '壹',
    t: '原材 · 万里挑一',
    d: '95白鹅绒只取绒朵最饱满的一束，桑蚕丝只用一级长丝，长绒棉非 60 支以上不用。原材入仓前，历经 27 项检测。',
  },
  {
    img: '/images/scenes/scene-5.svg',
    n: '贰',
    t: '织造 · 古法今艺',
    d: '立衬分区、手工定位、贡缎素织——老师傅的手艺与现代化数字织机同工，一道被芯要经过 43 道工序方能出厂。',
  },
  {
    img: '/images/scenes/scene-3.svg',
    n: '叁',
    t: '检控 · 吹毛求疵',
    d: '每一床织物出厂前经过防钻绒、色牢度、pH 值等 9 重检控，不合格者现场销毁——38 年，从未破例。',
  },
]

const materials = [
  {
    img: '/images/products/p01.svg',
    name: '95 白鹅绒',
    en: 'White Goose Down',
    origin: '西伯利亚绒带',
    desc: '只取绒朵最饱满的一束，蓬松度 800+，锁住整夜恒温。',
  },
  {
    img: '/images/products/p02.svg',
    name: '桑蚕丝长丝',
    en: 'Mulberry Silk',
    origin: '江南蚕区',
    desc: '一级长丝手工定位，丝胎如云，贴合每一寸翻身。',
  },
  {
    img: '/images/products/p05.svg',
    name: '新疆长绒棉',
    en: 'Long-staple Cotton',
    origin: '新疆棉区',
    desc: '非 60 支以上不用，织出贡缎的月光光泽。',
  },
  {
    img: '/images/products/p07.svg',
    name: '兰精天丝',
    en: 'TENCEL™ Lyocell',
    origin: '奥地利',
    desc: '木源纤维，接触瞬凉，湿气管理与生俱来。',
  },
  {
    img: '/images/products/p10.svg',
    name: '美利奴羊毛',
    en: 'Merino Wool',
    origin: '澳洲',
    desc: '恒温锁暖，冬被的恰好处方。',
  },
  {
    img: '/images/products/p11.svg',
    name: '雨露亚麻',
    en: 'Natural Linen',
    origin: '法国诺曼底',
    desc: '天然肌理，越洗越柔软的时光感。',
  },
]

const stores = [
  { city: '杭州', name: '万象城旗舰店', addr: '江干区富春路 701 号 L2-08' },
  { city: '上海', name: '恒隆广场精品店', addr: '静安区南京西路 1266 号 3F' },
  { city: '北京', name: 'SKP 专柜', addr: '朝阳区大望桥 SKP 4F' },
  { city: '成都', name: 'IFS 精品店', addr: '锦江区红星路三段 1 号 L5' },
]

const stats = [
  { to: 43, suffix: '', label: '道出厂工序' },
  { to: 27, suffix: '', label: '项原材检测' },
  { to: 9, suffix: '', label: '重出厂检控' },
  { to: 1600, suffix: '+', label: '位织造匠人' },
]

const service = [
  { t: '深度洗护', d: '每年 2 次免费专业洗护与除螨' },
  { t: '翻新收纳', d: '换季免费真空收纳与翻新塑形' },
  { t: '以旧换新', d: '旧被抵扣，循环再生计划承接' },
  { t: '睡眠档案', d: '专属顾问定期回访调优睡眠组合' },
]
</script>

<template>
  <div class="pt-[72px]">
    <!-- 品牌主视觉 -->
    <section class="relative -mt-[72px] flex h-[72vh] min-h-[480px] items-center overflow-hidden bg-ink">
      <img
        src="/images/scenes/scene-6.svg"
        alt="织云品牌"
        class="absolute inset-0 h-full w-full object-cover"
      />
      <div class="absolute inset-0 bg-ink/45" />
      <div class="wrap relative z-10 animate-fade-up text-center text-ivory">
        <p class="text-[11px] uppercase tracking-[0.45em] text-gold">
          Our Story · Since 1988
        </p>
        <h1 class="mt-6 font-display text-4xl leading-snug tracking-[0.1em] md:text-6xl">
          以东方织造，
          <br class="md:hidden" />
          致一世安眠。
        </h1>
        <p class="mx-auto mt-6 max-w-xl text-sm leading-loose text-ivory/70">
          三十八年，三代织人，一件事：把「睡个好觉」做成传家的东西。
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
        <div class="space-y-5 text-[15px] leading-loose text-ink/70">
          <p>
            织云相信，睡眠是最后的奢侈品——它无法被追赶，只能被照料。所以我们把
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
          title="织云的三十八年"
          desc="从一匹手织真丝，到中国高端床品的代表名字。"
        />
        <div class="mx-auto mt-16 max-w-3xl">
          <Reveal v-for="(t, i) in timeline" :key="t.year" :delay="i * 80">
            <div class="group flex gap-8 border-l border-ink/15 pb-10 pl-8 last:pb-0">
              <span class="relative -left-[41px] top-1 h-2.5 w-2.5 shrink-0 rounded-full border border-gold-deep bg-linen transition-colors duration-500 group-hover:bg-gold-deep" />
              <div>
                <p class="font-display text-2xl text-gold-deep">{{ t.year }}</p>
                <p class="mt-2 text-sm leading-loose text-ink/70">{{ t.text }}</p>
              </div>
            </div>
          </Reveal>
        </div>
        <Reveal class="mt-16 grid grid-cols-2 gap-y-10 text-center md:grid-cols-4">
          <div v-for="s in stats" :key="s.label">
            <p class="font-display text-4xl text-gold-deep md:text-5xl">
              <CountUp :to="s.to" :suffix="s.suffix" />
            </p>
            <p class="mt-2 text-[11px] tracking-[0.3em] text-ink/50">
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
          <Reveal v-for="(m, i) in materials" :key="m.name" :delay="(i % 3) * 100">
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
                <span class="text-[10px] uppercase tracking-[0.25em] text-gold-deep">
                  {{ m.origin }}
                </span>
              </div>
              <p class="mt-1 text-[10px] uppercase tracking-[0.3em] text-ink/35">
                {{ m.en }}
              </p>
              <p class="mt-3 text-sm leading-loose text-ink/60">
                {{ m.desc }}
              </p>
            </div>
          </Reveal>
        </div>
        <Reveal class="mt-14 flex flex-wrap items-center justify-center gap-x-8 gap-y-3 text-[11px] tracking-[0.25em] text-ink/45">
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
        <Reveal v-for="(c, i) in crafts" :key="c.n" :delay="i * 110">
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
          <p class="mt-3 text-sm leading-loose text-ink/60">{{ c.d }}</p>
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
          desc="织云会员的每一床被褥，都享有终身洗护档案。"
        />
        <div class="mt-14 grid gap-8 md:grid-cols-4">
          <Reveal v-for="(s, i) in service" :key="s.t" :delay="i * 90">
            <div class="border border-ivory/15 p-7 transition-colors duration-500 hover:border-gold/60">
              <p class="font-display text-lg tracking-[0.2em] text-gold">
                {{ s.t }}
              </p>
              <p class="mt-3 text-sm leading-loose text-ivory/55">{{ s.d }}</p>
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
        <Reveal v-for="(s, i) in stores" :key="s.name" :delay="i * 80" class="h-full">
          <div class="flex h-full flex-col bg-linen p-7">
            <p class="text-[10px] uppercase tracking-[0.3em] text-gold-deep">
              {{ s.city }}
            </p>
            <p class="mt-3 font-display text-lg tracking-[0.12em] text-ink">
              {{ s.name }}
            </p>
            <p class="mt-2 flex-1 text-xs leading-relaxed text-ink/50">
              {{ s.addr }}
            </p>
          </div>
        </Reveal>
      </div>
      <Reveal class="mt-12 text-center">
        <p class="text-xs tracking-[0.2em] text-ink/45">
          更多购买渠道：天猫旗舰店 · 京东旗舰店 · 微信小程序「织云家纺」 · 抖音直播间
        </p>
        <router-link to="/products" class="btn-primary mt-8">
          进入系列甄选
        </router-link>
      </Reveal>
    </section>
  </div>
</template>
