<script setup>
defineProps({
  img: { type: String, required: true },
  eyebrow: { type: String, required: true },
  title: { type: String, required: true },
  sub: { type: String, default: '' },
})
</script>

<template>
  <section class="relative -mt-[72px] flex h-[52vh] min-h-[380px] items-center overflow-hidden bg-ink">
    <img :src="img" :alt="title" class="absolute inset-0 h-full w-full object-cover" />
    <div class="absolute inset-0 bg-ink/55" />
    <div class="absolute inset-0 bg-gradient-to-r from-ink/75 via-ink/35 to-transparent" />
    <div class="wrap relative z-10 animate-fade-up text-ivory">
      <p class="text-[15px] uppercase tracking-[0.45em] text-gold text-shadow-soft">{{ eyebrow }}</p>
      <h1 class="mt-5 font-display text-4xl leading-snug tracking-[0.08em] text-shadow-hero md:text-6xl">{{ title }}</h1>
      <p v-if="sub" class="mt-4 max-w-xl text-base leading-loose text-ivory/90 text-shadow-soft">{{ sub }}</p>
    </div>
  </section>
</template>
