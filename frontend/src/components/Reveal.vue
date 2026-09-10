<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'

defineProps({
  delay: { type: Number, default: 0 },
})

const el = ref(null)
let io

onMounted(() => {
  if (!el.value) return
  io = new IntersectionObserver(
    ([entry]) => {
      if (entry.isIntersecting) {
        el.value.classList.add('is-visible')
        io.disconnect()
      }
    },
    { threshold: 0.12, rootMargin: '0px 0px -40px 0px' }
  )
  io.observe(el.value)
})

onBeforeUnmount(() => {
  if (io) io.disconnect()
})
</script>

<template>
  <div ref="el" class="reveal" :style="{ transitionDelay: delay + 'ms' }">
    <slot />
  </div>
</template>
