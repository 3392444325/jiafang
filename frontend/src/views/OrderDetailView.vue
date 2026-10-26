<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { orderApi } from '@/api'
import { ORDER_STATUS, PAY_METHOD_LABEL, formatDateTime, yuan } from '@/utils/format'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const order = ref(null)
const loaded = ref(false)
const notFound = ref(false)

const addr = computed(() => {
  if (!order.value) return null
  try {
    return JSON.parse(order.value.addressJson)
  } catch (e) {
    return null
  }
})

const st = computed(() =>
  order.value ? ORDER_STATUS[order.value.status] || ORDER_STATUS.PENDING_PAYMENT : null
)

const justCreated = computed(
  () => route.query.created === '1' && order.value?.status === 'PENDING_PAYMENT'
)

const cancelLoading = ref(false)
const cancelError = ref('')

const canCancel = computed(() => order.value?.status === 'PENDING_PAYMENT')
const canRequestCancel = computed(
  () => order.value?.status === 'PAID' && !order.value?.cancelRequested
)

const doCancel = async () => {
  if (!window.confirm('确定要取消这个订单吗？')) return
  cancelLoading.value = true
  cancelError.value = ''
  try {
    await orderApi.cancel(order.value.id)
    order.value = await orderApi.detail(order.value.id)
  } catch (e) {
    cancelError.value = e.message || '取消失败'
  } finally {
    cancelLoading.value = false
  }
}

const doRequestCancel = async () => {
  if (!window.confirm('已付款订单取消需商家核实后退款，确定提交撤销申请吗？')) return
  cancelLoading.value = true
  cancelError.value = ''
  try {
    await orderApi.requestCancel(order.value.id)
    order.value = await orderApi.detail(order.value.id)
  } catch (e) {
    cancelError.value = e.message || '提交失败'
  } finally {
    cancelLoading.value = false
  }
}

onMounted(async () => {
  if (!auth.isLoggedIn) await auth.fetchCurrentUser()
  if (!auth.isLoggedIn) {
    router.replace('/login?redirect=/orders')
    return
  }
  try {
    order.value = await orderApi.detail(route.params.id)
  } catch (e) {
    notFound.value = true
  } finally {
    loaded.value = true
  }
})
</script>

<template>
  <div class="pt-[72px]">
    <div class="wrap max-w-4xl py-16">
      <template v-if="loaded && order && !notFound">
        <div v-if="justCreated" class="mb-10 border border-gold/40 bg-gold/10 px-6 py-5 text-center">
          <p class="font-display text-lg tracking-[0.2em] text-gold-deep">
            订单提交成功
          </p>
          <p class="mt-2 text-[14px] tracking-[0.15em] text-ink/80">
            绮云感谢你的信任 — 请完成支付，我们将以顺丰极速为你安排发货。
          </p>
        </div>

        <div class="flex flex-wrap items-center justify-between gap-4">
          <div>
            <p class="eyebrow">Order Detail</p>
            <h1 class="mt-4 font-display text-3xl tracking-[0.15em] text-ink">
              {{ order.orderNo }}
            </h1>
          </div>
          <span :class="`border px-4 py-1.5 text-[14px] tracking-[0.2em] ${st.cls}`">
            {{ st.label }}
          </span>
        </div>

        <div class="mt-10 grid gap-3 text-[15px] text-ink/75 sm:grid-cols-2">
          <p>下单时间：{{ formatDateTime(order.createdAt) }}</p>
          <p v-if="order.paidAt">
            支付时间：{{ formatDateTime(order.paidAt) }}<span v-if="order.payMethod"> · {{ PAY_METHOD_LABEL[order.payMethod] || order.payMethod }}</span>
          </p>
        </div>

        <div v-if="addr" class="mt-8 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            收货信息
          </div>
          <div class="px-6 py-5 text-[15px] leading-relaxed text-ink/85">
            {{ addr.name }} · {{ addr.phone }}
            <br />
            {{ addr.region }} {{ addr.detail }}
          </div>
        </div>

        <div class="mt-6 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            商品清单
          </div>
          <div class="divide-y divide-ink/10">
            <div
              v-for="it in order.items"
              :key="it.id"
              class="flex items-center gap-5 px-6 py-5"
            >
              <img
                :src="it.imageSnap || '/images/products/p01.jpg'"
                :alt="it.nameSnap"
                class="h-20 w-16 object-cover"
              />
              <div class="flex-1 text-[15px]">
                <p class="tracking-[0.1em] text-ink">{{ it.nameSnap }}</p>
                <p class="mt-1 text-[14px] text-ink/75">
                  {{ yuan(it.priceFen) }} × {{ it.qty }}
                </p>
              </div>
              <p class="font-display text-lg text-gold-deep">
                {{ yuan(it.priceFen * it.qty) }}
              </p>
            </div>
          </div>
          <div class="flex items-baseline justify-between border-t border-ink/10 px-6 py-5">
            <span class="text-[15px] tracking-[0.2em] text-ink">应付合计（顺丰包邮）</span>
            <span class="font-display text-3xl text-gold-deep">
              {{ yuan(order.totalFen) }}
            </span>
          </div>
        </div>

        <div class="mt-10 flex flex-col gap-4 sm:flex-row sm:items-center">
          <template v-if="order.status === 'PENDING_PAYMENT'">
            <router-link :to="`/orders/${order.id}/pay`" class="btn-primary">
              前往支付 · {{ yuan(order.totalFen) }}
            </router-link>
            <button
              class="btn-ghost cursor-pointer disabled:opacity-50"
              :disabled="cancelLoading"
              @click="doCancel"
            >
              取消订单
            </button>
            <router-link to="/products" class="btn-ghost">
              继续选购
            </router-link>
          </template>
          <template v-else-if="order.status === 'PAID'">
            <p class="text-[15px] tracking-[0.15em] text-emerald-800">
              ✓ 支付完成 —— 我们将尽快为你安排顺丰发货，ST.KELLY七星洗护已同步生效。
            </p>
            <button
              v-if="canRequestCancel"
              class="btn-ghost cursor-pointer self-start disabled:opacity-50"
              :disabled="cancelLoading"
              @click="doRequestCancel"
            >
              申请取消（商家核实后退款）
            </button>
            <p
              v-else-if="order.cancelRequested"
              class="border border-gold/40 bg-gold/10 px-4 py-2 text-[14px] tracking-[0.15em] text-gold-deep"
            >
              撤销申请已提交（{{ formatDateTime(order.cancelRequestedAt) }}），等待商家核实处理。
            </p>
          </template>
          <p v-else-if="order.status === 'SHIPPED'" class="text-[15px] tracking-[0.15em] text-sky-800">
            ✓ 包裹已在路上 —— 顺丰速运全程恒温配送，请注意查收。
          </p>
          <router-link v-else to="/orders" class="btn-ghost">
            返回订单列表
          </router-link>
        </div>

        <p v-if="cancelError" class="mt-4 text-[15px] text-red-700">{{ cancelError }}</p>
      </template>

      <!-- 未找到 -->
      <div v-else-if="loaded && notFound" class="py-24 text-center">
        <p class="font-display text-2xl tracking-[0.15em] text-ink/75">
          订单不存在
        </p>
        <router-link to="/orders" class="btn-primary mt-10">
          返回订单列表
        </router-link>
      </div>
    </div>
  </div>
</template>
