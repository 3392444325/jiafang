<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import { useRouter } from 'vue-router'

const props = defineProps({
  slides: { type: Array, required: true },
})

const router = useRouter()
const i = ref(0)

const current = computed(() => props.slides[i.value])

const next = () => {
  i.value = (i.value + 1) % props.slides.length
}
const prev = () => {
  i.value = (i.value - 1 + props.slides.length) % props.slides.length
}
const setSlide = (idx) => {
  i.value = idx
}

const pad = (n) => String(n).padStart(2, '0')

let timer
onMounted(() => {
  timer = setInterval(next, 6500)
})
// 轮播切换后重置计时（对应原 useEffect 依赖 [next, i]）
watch(i, () => {
  clearInterval(timer)
  timer = setInterval(next, 6500)
})
onBeforeUnmount(() => {
  clearInterval(timer)
})

function go(href) {
  router.push(href)
}
</script>

<template>
  <section class="relative -mt-[72px] h-vh-screen min-h-[560px] overflow-hidden bg-ink">
    <!-- 轮播图层 -->
    <div
      v-for="(sl, idx) in slides"
      :key="sl.src"
      class="absolute inset-0 transition-opacity duration-[1600ms] ease-out"
      :class="idx === i ? 'opacity-100' : 'opacity-0'"
    >
      <img
        :src="sl.src"
        :alt="sl.title.replace(/\n/g, '')"
        class="h-full w-full object-cover"
        :class="idx === i ? 'animate-kenburns' : ''"
      />
      <!-- 双层暗色蒙层，保证白色标题压在任何亮图上都清晰 -->
      <div class="absolute inset-0 bg-gradient-to-t from-ink/85 via-ink/40 to-ink/50" />
      <div class="absolute inset-0 bg-gradient-to-r from-ink/80 via-ink/45 to-transparent" />
    </div>

    <!-- 文案 -->
    <div class="wrap relative z-10 flex h-full flex-col justify-end pb-28 text-white md:justify-center md:pb-0">
      <div :key="i" class="max-w-2xl animate-fade-up">
        <p class="text-[15px] uppercase tracking-[0.45em] text-gold text-shadow-soft">{{ current.eyebrow }}</p>
        <h1 class="mt-5 font-display text-4xl leading-[1.2] tracking-[0.05em] text-shadow-hero md:text-7xl">
          <span v-for="(line, li) in current.title.split('\n')" :key="li">
            <br v-if="li > 0" />{{ line }}
          </span>
        </h1>
        <p class="mt-5 max-w-xl text-base leading-loose text-white/90 text-shadow-soft md:text-lg">{{ current.sub }}</p>
        <div class="mt-9 flex flex-wrap gap-4">
          <router-link :to="current.href" class="btn-ghost-light">{{ current.cta }}</router-link>
          <router-link
            to="/shop"
            class="btn-ghost-light border-transparent hover:bg-transparent hover:text-white/80"
          >
            官方商城 →
          </router-link>
        </div>
      </div>
    </div>

    <!-- 指示器 -->
    <div
      class="absolute bottom-10 left-1/2 z-10 flex -translate-x-1/2 items-center gap-2.5 md:left-auto md:right-10 md:translate-x-0"
    >
      <button
        v-for="(sl, idx) in slides"
        :key="idx"
        @click="setSlide(idx)"
        :aria-label="`第 ${idx + 1} 张`"
        class="h-px transition-all duration-500"
        :class="idx === i ? 'w-10 bg-gold' : 'w-5 bg-white/40 hover:bg-white/70'"
      />
    </div>
    <div class="absolute bottom-9 right-10 z-10 hidden items-center gap-5 text-white/80 md:flex">
      <span class="text-[14px] tracking-[0.3em]">{{ pad(i + 1) }} — {{ pad(slides.length) }}</span>
      <button
        @click="prev"
        aria-label="上一张"
        class="cursor-pointer text-xl leading-none transition-colors hover:text-gold"
      >
        ←
      </button>
      <button
        @click="next"
        aria-label="下一张"
        class="cursor-pointer text-xl leading-none transition-colors hover:text-gold"
      >
        →
      </button>
    </div>

    <!-- 侧边竖排点缀 -->
    <p class="v-text absolute right-8 top-1/2 z-10 hidden -translate-y-1/2 text-[13px] text-white/75 lg:block">
      东方织造 · 一世安眠
    </p>
  </section>
</template>
