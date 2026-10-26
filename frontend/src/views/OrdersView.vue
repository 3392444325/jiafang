<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { orderApi } from '@/api'
import { ORDER_STATUS, formatDateTime, yuan } from '@/utils/format'

const router = useRouter()
const auth = useAuthStore()

const orders = ref([])
const loaded = ref(false)
const cancelBusy = ref(false)

function statusFor(status) {
  return ORDER_STATUS[status] || ORDER_STATUS.PENDING_PAYMENT
}

const doCancel = async (o) => {
  if (!window.confirm(`确定要取消订单 ${o.orderNo} 吗？`)) return
  cancelBusy.value = true
  try {
    await orderApi.cancel(o.id)
    orders.value = (await orderApi.list()).orders || []
  } catch (e) {
    window.alert(e.message || '取消失败')
  } finally {
    cancelBusy.value = false
  }
}

const doRequestCancel = async (o) => {
  if (!window.confirm(`已付款订单取消需商家核实后退款，确定对订单 ${o.orderNo} 提交撤销申请吗？`)) return
  cancelBusy.value = true
  try {
    await orderApi.requestCancel(o.id)
    orders.value = (await orderApi.list()).orders || []
  } catch (e) {
    window.alert(e.message || '提交失败')
  } finally {
    cancelBusy.value = false
  }
}

onMounted(async () => {
  if (!auth.isLoggedIn) await auth.fetchCurrentUser()
  if (!auth.isLoggedIn) {
    router.replace('/login?redirect=/orders')
    return
  }
  try {
    const res = await orderApi.list()
    orders.value = res.orders || []
  } catch (e) {
    orders.value = []
  } finally {
    loaded.value = true
  }
})
</script>

<template>
  <div class="pt-[72px]">
    <div class="wrap py-16">
      <p class="eyebrow">My Orders</p>
      <h1 class="mt-4 font-display text-4xl tracking-[0.15em] text-ink">
        我的订单
        <span class="ml-4 align-middle text-[14px] tracking-[0.2em] text-ink/75">
          {{ auth.displayName }}
        </span>
        <router-link
          to="/account/addresses"
          class="ml-6 align-middle text-[14px] tracking-[0.2em] text-gold-deep transition-colors hover:text-ink"
        >
          地址簿 →
        </router-link>
      </h1>

      <div v-if="orders.length === 0" class="py-24 text-center">
        <p class="font-display text-2xl tracking-[0.2em] text-ink/75">
          还没有订单
        </p>
        <p class="mt-4 text-[15px] tracking-[0.2em] text-ink/75">
          第一床好梦，从这里开始。
        </p>
        <router-link to="/products" class="btn-primary mt-10">
          去逛逛
        </router-link>
      </div>
      <div v-else class="mt-12 space-y-6">
        <div
          v-for="o in orders"
          :key="o.id"
          class="border border-ink/10 bg-ivory"
        >
          <div class="flex flex-wrap items-center justify-between gap-3 border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.15em]">
            <span class="text-ink/80">{{ o.orderNo }}</span>
            <span class="text-ink/75">{{ formatDateTime(o.createdAt) }}</span>
            <span :class="`border px-3 py-1 text-[14px] ${statusFor(o.status).cls}`">
              {{ statusFor(o.status).label }}
            </span>
            <button
              v-if="o.status === 'PENDING_PAYMENT' || (o.status === 'PAID' && !o.cancelRequested)"
              class="cursor-pointer text-[14px] text-red-700/70 transition-colors hover:text-red-700 disabled:opacity-40"
              :disabled="cancelBusy"
              @click="o.status === 'PENDING_PAYMENT' ? doCancel(o) : doRequestCancel(o)"
            >
              {{ o.status === 'PENDING_PAYMENT' ? '取消订单' : '申请取消' }}
            </button>
            <span
              v-else-if="o.cancelRequested && o.status === 'PAID'"
              class="border border-gold/40 bg-gold/10 px-2 py-0.5 text-[14px] text-gold-deep"
            >
              撤销申请待商家处理
            </span>
          </div>
          <div class="flex flex-wrap items-center gap-5 px-6 py-5">
            <div class="flex gap-3">
              <img
                v-for="it in o.items.slice(0, 3)"
                :key="it.id"
                :src="it.imageSnap || '/images/products/p01.jpg'"
                :alt="it.nameSnap"
                class="h-16 w-14 object-cover"
              />
            </div>
            <div class="flex-1 text-[14px] leading-relaxed text-ink/80">
              <p v-for="it in o.items" :key="it.id">
                {{ it.nameSnap }} × {{ it.qty }}
              </p>
            </div>
            <div class="text-right">
              <p class="font-display text-xl text-gold-deep">
                {{ yuan(o.totalFen) }}
              </p>
              <router-link
                :to="`/orders/${o.id}`"
                class="link-underline mt-2 inline-block text-[14px] uppercase tracking-[0.25em] text-ink/75 hover:text-gold-deep"
              >
                订单详情
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
