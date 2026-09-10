<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'

const props = defineProps({
  to: { type: Number, required: true },
  suffix: { type: String, default: '' },
  duration: { type: Number, default: 1600 },
})

const val = ref(0)
const el = ref(null)
let started = false
let io

onMounted(() => {
  if (!el.value) return
  io = new IntersectionObserver(
    ([e]) => {
      if (e.isIntersecting && !started) {
        started = true
        const t0 = performance.now()
        const tick = (t) => {
          const p = Math.min((t - t0) / props.duration, 1)
          const eased = 1 - Math.pow(1 - p, 3)
          val.value = Math.round(props.to * eased)
          if (p < 1) requestAnimationFrame(tick)
        }
        requestAnimationFrame(tick)
        io.disconnect()
      }
    },
    { threshold: 0.4 }
  )
  io.observe(el.value)
})

onBeforeUnmount(() => {
  if (io) io.disconnect()
})
</script>

<template>
  <span ref="el">{{ val.toLocaleString('zh-CN') }}{{ suffix }}</span>
</template>
