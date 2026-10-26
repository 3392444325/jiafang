<script setup>
import { computed } from 'vue'
import Reveal from './Reveal.vue'

const props = defineProps({
  eyebrow: { type: String, required: true },
  title: { type: String, required: true },
  desc: { type: String, default: '' },
  align: { type: String, default: 'center' },
  light: { type: Boolean, default: false },
})

const alignCls = computed(() =>
  props.align === 'center' ? 'text-center mx-auto' : 'text-left'
)
</script>

<template>
  <Reveal :class="`max-w-2xl ${alignCls}`">
    <p class="eyebrow" :class="{ 'text-gold!': light }">{{ eyebrow }}</p>
    <h2
      class="mt-4 font-display text-3xl leading-snug tracking-wide md:text-4xl"
      :class="light ? 'text-ivory' : 'text-ink'"
    >
      {{ title }}
    </h2>
    <div
      class="mt-5 h-px w-14"
      :class="[align === 'center' ? 'mx-auto' : '', light ? 'bg-gold' : 'bg-gold-deep/60']"
    />
    <p
      v-if="desc"
      class="mt-5 text-[15px] leading-loose"
      :class="light ? 'text-ivory/85' : 'text-ink-soft'"
    >
      {{ desc }}
    </p>
  </Reveal>
</template>
