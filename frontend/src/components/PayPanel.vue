<script setup>
import { ref, watch, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import { orderApi } from '@/api'
import { yuan } from '@/utils/format'

const props = defineProps({
  orderId: { type: String, required: true },
  orderNo: { type: String, required: true },
  totalFen: { type: Number, required: true },
})

const router = useRouter()

const METHODS = [
  { key: 'WECHAT', label: '微信支付', hint: '推荐 · 扫码即付' },
  { key: 'ALIPAY', label: '支付宝', hint: '花呗可分期' },
  { key: 'CARD', label: '银行卡', hint: '储蓄卡 / 信用卡' },
]

const METHOD_LABEL = {
  WECHAT: '微信支付',
  ALIPAY: '支付宝',
  CARD: '银行卡',
}

const method = ref('WECHAT')
const phase = ref('select')
const error = ref('')
const countdown = ref(5)

let timer = null

// 支付成功后 5 秒自动跳转订单详情
watch(phase, (val) => {
  if (val !== 'success') return
  countdown.value = 5
  if (timer) clearInterval(timer)
  timer = setInterval(() => {
    countdown.value -= 1
    if (countdown.value <= 0) {
      clearInterval(timer)
      timer = null
      router.push(`/orders/${props.orderId}`)
    }
  }, 1000)
})

onBeforeUnmount(() => {
  if (timer) clearInterval(timer)
})

async function pay() {
  phase.value = 'processing'
  error.value = ''
  // 模拟网关等待
  await new Promise((r) => setTimeout(r, 1200))
  try {
    await orderApi.pay(props.orderId, method.value)
    phase.value = 'success'
  } catch (e) {
    error.value = e.message || '支付失败，请重试'
    phase.value = 'fail'
  }
}
</script>

<template>
  <div v-if="phase === 'success'" class="border border-gold/40 bg-gold/10 px-6 py-14 text-center">
    <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full border border-gold-deep text-3xl text-gold-deep">
      ✓
    </div>
    <p class="mt-6 font-display text-2xl tracking-[0.2em] text-gold-deep">
      支付成功
    </p>
    <p class="mt-3 text-[15px] tracking-[0.15em] text-ink/75">
      {{ METHOD_LABEL[method] }} · {{ yuan(totalFen) }} · 订单号 {{ orderNo }}
    </p>
    <p class="mt-2 text-[14px] tracking-[0.15em] text-ink/75">
      我们将以顺丰极速为你安排发货，ST.KELLY七星洗护已同步生效。
    </p>
    <div class="mt-8 flex items-center justify-center gap-6">
      <router-link :to="`/orders/${orderId}`" class="btn-primary">
        查看订单（{{ countdown }}s）
      </router-link>
      <router-link to="/products" class="btn-ghost">
        继续选购
      </router-link>
    </div>
  </div>

  <div v-else class="border border-ink/10 bg-ivory">
    <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
      选择支付方式
    </div>
    <div class="grid gap-3 p-6 sm:grid-cols-3">
      <button
        v-for="m in METHODS"
        :key="m.key"
        type="button"
        :disabled="phase === 'processing'"
        @click="method = m.key"
        :class="[
          'flex cursor-pointer flex-col items-center gap-2 border p-6 transition-colors disabled:cursor-default',
          method === m.key ? 'border-gold-deep bg-linen' : 'border-ink/15 hover:border-ink/40',
        ]"
      >
        <span :class="method === m.key ? 'text-gold-deep' : 'text-ink/80'">
          <svg
            v-if="m.key === 'WECHAT'"
            width="28"
            height="28"
            viewBox="0 0 24 24"
            fill="currentColor"
          >
            <path d="M8.5 4C4.9 4 2 6.5 2 9.6c0 1.8 1 3.3 2.5 4.4l-.6 2 2.2-1.1c.8.2 1.5.3 2.4.3h.4a5.5 5.5 0 0 1-.2-1.5c0-3 2.9-5.4 6.4-5.4h.6C14.9 5.8 12 4 8.5 4zm-2.3 3.3a.9.9 0 1 1 0 1.8.9.9 0 0 1 0-1.8zm4.6 0a.9.9 0 1 1 0 1.8.9.9 0 0 1 0-1.8zM15.3 9.7c-3.1 0-5.6 2-5.6 4.6 0 2.5 2.5 4.6 5.6 4.6.7 0 1.3-.1 2-.3l1.9 1-.5-1.8c1.4-.9 2.3-2.2 2.3-3.5 0-2.6-2.6-4.6-5.7-4.6zm-2 2.5a.8.8 0 1 1 0 1.6.8.8 0 0 1 0-1.6zm4 0a.8.8 0 1 1 0 1.6.8.8 0 0 1 0-1.6z" />
          </svg>
          <svg
            v-else-if="m.key === 'ALIPAY'"
            width="28"
            height="28"
            viewBox="0 0 24 24"
            fill="currentColor"
          >
            <path d="M17 3H7a4 4 0 0 0-4 4v10a4 4 0 0 0 4 4h10a4 4 0 0 0 4-4V7a4 4 0 0 0-4-4zm-4.9 11.6c-1.4 1-3.3 1.4-4.6.5-1.3-.9-1.2-2.5.2-3.3 1.2-.7 3-.8 4.3-.1-.4-1.3-1.6-2.2-3.2-2.4 2.5-.6 5.2.6 6.1 3 .8 2.1-.2 4.5-2.3 5.4-.8-1.4-.9-2.4-.5-3.1zM4.7 7.6h5.9v1.4H4.7V7.6zm0 3h3.6V12H4.7v-1.4z" />
          </svg>
          <svg
            v-else-if="m.key === 'CARD'"
            width="28"
            height="28"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="1.6"
          >
            <rect x="2.5" y="5" width="19" height="14" rx="2" />
            <path d="M2.5 9.5h19" />
          </svg>
        </span>
        <span class="text-[15px] tracking-[0.2em] text-ink">{{ m.label }}</span>
        <span class="text-[13px] tracking-[0.15em] text-ink/75">
          {{ m.hint }}
        </span>
      </button>
    </div>
    <div class="flex flex-col items-center gap-4 border-t border-ink/10 px-6 py-6">
      <p v-if="error" class="text-[14px] tracking-[0.15em] text-red-700">{{ error }}</p>
      <button
        @click="pay"
        :disabled="phase === 'processing'"
        class="btn-primary w-full disabled:opacity-50 sm:w-auto"
      >
        {{ phase === 'processing' ? '支付网关处理中…' : `确认支付 ${yuan(totalFen)}（模拟）` }}
      </button>
      <button
        v-if="phase === 'fail'"
        @click="phase = 'select'"
        class="cursor-pointer text-[14px] tracking-[0.2em] text-ink/80 hover:text-ink"
      >
        ← 重新选择支付方式
      </button>
    </div>
  </div>
</template>
