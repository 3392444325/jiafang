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
          <p class="mt-2 text-xs tracking-[0.15em] text-ink/55">
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
          <span :class="`border px-4 py-1.5 text-xs tracking-[0.2em] ${st.cls}`">
            {{ st.label }}
          </span>
        </div>

        <div class="mt-10 grid gap-3 text-sm text-ink/60 sm:grid-cols-2">
          <p>下单时间：{{ formatDateTime(order.createdAt) }}</p>
          <p v-if="order.paidAt">
            支付时间：{{ formatDateTime(order.paidAt) }}<span v-if="order.payMethod"> · {{ PAY_METHOD_LABEL[order.payMethod] || order.payMethod }}</span>
          </p>
        </div>

        <div v-if="addr" class="mt-8 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-xs tracking-[0.25em] text-ink/50">
            收货信息
          </div>
          <div class="px-6 py-5 text-sm leading-relaxed text-ink/75">
            {{ addr.name }} · {{ addr.phone }}
            <br />
            {{ addr.region }} {{ addr.detail }}
          </div>
        </div>

        <div class="mt-6 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-xs tracking-[0.25em] text-ink/50">
            商品清单
          </div>
          <div class="divide-y divide-ink/10">
            <div
              v-for="it in order.items"
              :key="it.id"
              class="flex items-center gap-5 px-6 py-5"
            >
              <img
                :src="it.imageSnap || '/images/products/p01.svg'"
                :alt="it.nameSnap"
                class="h-20 w-16 object-cover"
              />
              <div class="flex-1 text-sm">
                <p class="tracking-[0.1em] text-ink">{{ it.nameSnap }}</p>
                <p class="mt-1 text-xs text-ink/45">
                  {{ yuan(it.priceFen) }} × {{ it.qty }}
                </p>
              </div>
              <p class="font-display text-lg text-gold-deep">
                {{ yuan(it.priceFen * it.qty) }}
              </p>
            </div>
          </div>
          <div class="flex items-baseline justify-between border-t border-ink/10 px-6 py-5">
            <span class="text-sm tracking-[0.2em] text-ink">应付合计（顺丰包邮）</span>
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
            <router-link to="/products" class="btn-ghost">
              继续选购
            </router-link>
          </template>
          <p v-else-if="order.status === 'PAID'" class="text-sm tracking-[0.15em] text-emerald-800">
            ✓ 支付完成 —— 我们将尽快为你安排顺丰发货，织云七星洗护已同步生效。
          </p>
          <p v-else-if="order.status === 'SHIPPED'" class="text-sm tracking-[0.15em] text-sky-800">
            ✓ 包裹已在路上 —— 顺丰速运全程恒温配送，请注意查收。
          </p>
          <router-link v-else to="/orders" class="btn-ghost">
            返回订单列表
          </router-link>
        </div>
      </template>

      <!-- 未找到 -->
      <div v-else-if="loaded && notFound" class="py-24 text-center">
        <p class="font-display text-2xl tracking-[0.15em] text-ink/60">
          订单不存在
        </p>
        <router-link to="/orders" class="btn-primary mt-10">
          返回订单列表
        </router-link>
      </div>
    </div>
  </div>
</template>
