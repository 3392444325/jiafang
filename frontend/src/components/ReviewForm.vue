<script setup>
import { ref } from 'vue'
import { reviewApi } from '@/api'

const props = defineProps({
  productId: { type: String, required: true },
})

const emit = defineEmits(['submitted'])

const rating = ref(5)
const hover = ref(0)
const content = ref('')
const busy = ref(false)
const error = ref('')

async function submit() {
  busy.value = true
  error.value = ''
  try {
    await reviewApi.submit({
      productId: props.productId,
      rating: rating.value,
      content: content.value,
    })
    content.value = ''
    rating.value = 5
    emit('submitted')
  } catch (e) {
    error.value = e.message || '提交失败，请重试'
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <form
    @submit.prevent="submit"
    class="mt-8 border border-ink/10 bg-ivory p-6"
  >
    <p class="text-[14px] tracking-[0.25em] text-ink/80">写下你的评价</p>
    <div class="mt-4 flex items-center gap-2">
      <button
        v-for="n in 5"
        :key="n"
        type="button"
        @mouseenter="hover = n"
        @mouseleave="hover = 0"
        @click="rating = n"
        :aria-label="`${n} 星`"
        class="cursor-pointer text-2xl leading-none transition-transform hover:scale-110"
      >
        <span :class="(hover || rating) >= n ? 'text-gold' : 'text-ink/70'">
          ★
        </span>
      </button>
      <span class="ml-2 text-[14px] tracking-[0.15em] text-ink/75">
        {{ rating }} 星
      </span>
    </div>
    <textarea
      v-model="content"
      rows="3"
      maxlength="500"
      placeholder="分享你的使用感受（4-500 字）—— 面料触感、保暖度、洗护体验…"
      class="field mt-4"
      required
    />
    <p v-if="error" class="mt-3 text-[14px] tracking-[0.15em] text-red-700">{{ error }}</p>
    <button
      type="submit"
      :disabled="busy"
      class="btn-primary mt-4 disabled:opacity-50"
    >
      {{ busy ? '提交中…' : '发表评价' }}
    </button>
  </form>
</template>
