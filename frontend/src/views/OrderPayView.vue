<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { orderApi } from '@/api'
import { yuan, formatDateTime } from '@/utils/format'
import PayPanel from '@/components/PayPanel.vue'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const order = ref(null)
const loaded = ref(false)
const notFound = ref(false)

function onPaid() {
  router.replace(`/orders/${route.params.id}`)
}

onMounted(async () => {
  if (!auth.isLoggedIn) await auth.fetchCurrentUser()
  if (!auth.isLoggedIn) {
    router.replace('/login?redirect=/orders')
    return
  }
  try {
    const res = await orderApi.detail(route.params.id)
    if (res.status !== 'PENDING_PAYMENT') {
      router.replace(`/orders/${res.id}`)
      return
    }
    order.value = res
  } catch (e) {
    notFound.value = true
  } finally {
    loaded.value = true
  }
})
</script>

<template>
  <div class="pt-[72px]">
    <div class="wrap max-w-3xl py-16">
      <template v-if="loaded && order && !notFound">
        <div class="text-center">
          <p class="eyebrow">Checkout · Payment</p>
          <h1 class="mt-4 font-display text-3xl tracking-[0.15em] text-ink">
            订单支付
          </h1>
          <p class="mt-3 text-xs tracking-[0.2em] text-ink/45">
            订单号 {{ order.orderNo }} · {{ formatDateTime(order.createdAt) }}
          </p>
        </div>

        <div class="mt-12">
          <PayPanel
            :order-id="order.id"
            :order-no="order.orderNo"
            :total-fen="order.totalFen"
            @paid="onPaid"
            @success="onPaid"
            @done="onPaid"
          />
        </div>

        <div class="mt-12 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-xs tracking-[0.25em] text-ink/50">
            商品清单（{{ order.items.length }}）
          </div>
          <div class="divide-y divide-ink/10">
            <div
              v-for="it in order.items"
              :key="it.id"
              class="flex items-center justify-between px-6 py-4 text-sm"
            >
              <span class="tracking-[0.1em] text-ink/80">
                {{ it.nameSnap }} × {{ it.qty }}
              </span>
              <span class="text-gold-deep">
                {{ yuan(it.priceFen * it.qty) }}
              </span>
            </div>
          </div>
          <div class="flex items-baseline justify-between border-t border-ink/10 px-6 py-5">
            <span class="text-sm tracking-[0.2em] text-ink">应付合计（顺丰包邮）</span>
            <span class="font-display text-3xl text-gold-deep">
              {{ yuan(order.totalFen) }}
            </span>
          </div>
        </div>

        <p class="mt-8 text-center text-[11px] leading-relaxed tracking-[0.12em] text-ink/40">
          本站为演示项目，采用「模拟支付」完成闭环；接入微信支付 / 支付宝需企业商户资质，接口位已预留。
        </p>
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
