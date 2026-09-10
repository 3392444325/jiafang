<script setup>
import { ref } from 'vue'

defineProps({
  images: { type: Array, required: true },
  name: { type: String, required: true },
})

const i = ref(0)
</script>

<template>
  <div>
    <div class="relative overflow-hidden bg-sand">
      <img
        :key="images[i]"
        :src="images[i]"
        :alt="name"
        class="aspect-[4/5] w-full animate-fade-in object-cover"
      />
    </div>
    <div v-if="images.length > 1" class="mt-4 grid grid-cols-4 gap-3">
      <button
        v-for="(src, idx) in images"
        :key="src"
        @click="i = idx"
        :aria-label="`查看第 ${idx + 1} 张`"
        :class="[
          'overflow-hidden border transition-all duration-300',
          idx === i ? 'border-gold-deep' : 'border-transparent opacity-60 hover:opacity-100',
        ]"
      >
        <img :src="src" alt="" class="aspect-square w-full object-cover" />
      </button>
    </div>
  </div>
</template>
