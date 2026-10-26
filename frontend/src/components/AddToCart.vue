<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useCartStore } from '@/stores/cart'

const props = defineProps({
  productId: { type: String, required: true },
  stock: { type: Number, required: true },
})

const router = useRouter()
const cart = useCartStore()

const qty = ref(1)
const busy = ref(false)
const added = ref(false)
const error = ref('')

async function add(buyNow = false) {
  busy.value = true
  error.value = ''
  try {
    await cart.add(props.productId, qty.value)
    added.value = true
    if (buyNow) {
      router.push('/cart')
    } else {
      setTimeout(() => (added.value = false), 2200)
    }
  } catch {
    error.value = '加入购物车失败，请重试'
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <div>
    <div class="flex items-center gap-6">
      <span class="text-[14px] tracking-[0.25em] text-ink/80">数量</span>
      <div class="flex items-center border border-ink/20">
        <button
          @click="qty = Math.max(1, qty - 1)"
          class="cursor-pointer px-4 py-2.5 text-ink/75 transition-colors hover:text-gold-deep"
          aria-label="减少数量"
        >
          −
        </button>
        <span class="min-w-12 text-center text-[15px]">{{ qty }}</span>
        <button
          @click="qty = Math.min(stock, qty + 1)"
          class="cursor-pointer px-4 py-2.5 text-ink/75 transition-colors hover:text-gold-deep"
          aria-label="增加数量"
        >
          +
        </button>
      </div>
      <span class="text-[14px] tracking-[0.15em] text-ink/75">
        库存 {{ stock }} 件
      </span>
    </div>

    <div class="mt-7 flex flex-col gap-3 sm:flex-row">
      <button
        @click="add(false)"
        :disabled="busy"
        class="btn-ghost flex-1 disabled:opacity-50"
      >
        {{ added ? '已加入 ✓' : busy ? '处理中…' : '加入购物车' }}
      </button>
      <button
        @click="add(true)"
        :disabled="busy"
        class="btn-primary flex-1 disabled:opacity-50"
      >
        立即购买
      </button>
    </div>
    <p v-if="error" class="mt-3 text-[14px] tracking-[0.15em] text-red-700">{{ error }}</p>
  </div>
</template>
