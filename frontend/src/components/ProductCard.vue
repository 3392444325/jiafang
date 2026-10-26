<script setup>
import { yuan } from '@/utils/format'

defineProps({
  p: { type: Object, required: true },
  delay: { type: Number, default: 0 },
})
</script>

<template>
  <router-link
    :to="`/products/${p.slug}`"
    class="group block animate-fade-up"
    :style="{ animationDelay: delay + 'ms' }"
  >
    <div class="relative overflow-hidden bg-sand">
      <img
        :src="p.image"
        :alt="p.name"
        class="aspect-[4/5] w-full object-cover transition-transform duration-[1400ms] ease-out group-hover:scale-[1.06]"
      />
      <span
        v-if="p.tag"
        class="absolute left-4 top-4 bg-ink/85 px-3 py-1.5 text-[13px] tracking-[0.25em] text-ivory"
      >
        {{ p.tag }}
      </span>
      <div class="absolute inset-x-0 bottom-0 translate-y-full bg-ivory/95 py-4 text-center text-[14px] uppercase tracking-[0.3em] text-ink transition-transform duration-500 ease-out group-hover:translate-y-0">
        查看详情
      </div>
    </div>
    <div class="pt-5 text-center">
      <h3 class="font-display text-lg tracking-[0.08em] text-ink">
        {{ p.name }}
      </h3>
      <p v-if="p.subtitle" class="mt-1.5 text-[14px] tracking-[0.15em] text-ink/75">
        {{ p.subtitle }}
      </p>
      <div class="mt-3 flex items-baseline justify-center gap-3">
        <span class="text-[15px] tracking-wider text-gold-deep">
          {{ yuan(p.priceFen) }}
        </span>
        <span v-if="p.compareAtFen" class="text-[14px] text-ink/70 line-through">
          {{ yuan(p.compareAtFen) }}
        </span>
      </div>
    </div>
  </router-link>
</template>
