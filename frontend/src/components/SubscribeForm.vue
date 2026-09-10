<script setup>
import { ref } from 'vue'

const email = ref('')
const done = ref(false)

function submit() {
  if (email.value.includes('@')) done.value = true
}
</script>

<template>
  <form @submit.prevent="submit" class="mt-6">
    <p v-if="done" class="text-sm tracking-[0.15em] text-gold">
      订阅成功 — 愿每一夜，都有织云相伴。
    </p>
    <div
      v-else
      class="flex max-w-md border-b border-ivory/25 focus-within:border-gold"
    >
      <input
        v-model="email"
        type="email"
        required
        placeholder="输入邮箱，订阅织云生活美学志"
        class="w-full bg-transparent py-3 text-sm text-ivory outline-none placeholder:text-ivory/35"
      />
      <button
        type="submit"
        class="cursor-pointer px-2 text-[11px] uppercase tracking-[0.3em] text-gold transition-colors hover:text-ivory"
      >
        订阅
      </button>
    </div>
  </form>
</template>
