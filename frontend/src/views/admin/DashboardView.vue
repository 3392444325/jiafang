<script setup>
import { ref, onMounted } from 'vue'
import { adminApi } from '@/api'
import AdminLayout from '@/components/AdminLayout.vue'
import Reveal from '@/components/Reveal.vue'

const yuan = (fen) => '¥' + (fen / 100).toLocaleString()

const formatDateTime = (date) => {
  const d = new Date(date)
  const pad = (n) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`
}

const ORDER_STATUS = {
  PENDING_PAYMENT: { label: '待付款', cls: 'text-ink/50 border-ink/20 bg-ink/5' },
  PAID: { label: '已付款', cls: 'text-emerald-800 border-emerald-700/30 bg-emerald-700/10' },
  SHIPPED: { label: '已发货', cls: 'text-sky-800 border-sky-700/30 bg-sky-700/10' },
  COMPLETED: { label: '已完成', cls: 'text-gold-deep border-gold/40 bg-gold/10' },
  CANCELLED: { label: '已取消', cls: 'text-ink/40 border-ink/20 bg-ink/5' },
}

const stats = ref([])
const daily = ref([])
const trendMax = ref(1)
const topProducts = ref([])
const statusCounts = ref({})
const statusMax = ref(1)
const recentOrders = ref([])

onMounted(async () => {
  try {
    const data = await adminApi.dashboard()
    const d = data.stats
    stats.value = [
      { label: '在售商品', value: String(d.activeProducts) },
      { label: '累计订单', value: String(d.totalOrders) },
      { label: '实收销售额', value: yuan(d.paidTotalFen) },
      { label: '待跟进线索', value: String(d.newLeads) },
    ]
    daily.value = data.daily || []
    trendMax.value = Math.max(1, ...daily.value.map((x) => x.fen))
    topProducts.value = data.topProducts || []
    statusCounts.value = data.statusCounts || {}
    statusMax.value = Math.max(1, ...Object.values(statusCounts.value))
    recentOrders.value = data.recentOrders || []
  } catch (e) {
    console.error('Failed to load dashboard', e)
  }
})

const barHeight = (fen) => Math.max(2, (fen / trendMax.value) * 110) + 'px'
const barWidth = (n) => Math.round((n / statusMax.value) * 100) + '%'
</script>

<template>
  <AdminLayout>
    <div>
      <div v-if="error" class="border border-red-700/30 bg-red-700/10 px-5 py-4 text-sm text-red-800">
        {{ error }}
      </div>

      <div class="grid gap-px bg-ink/10 sm:grid-cols-2 lg:grid-cols-4">
        <Reveal v-for="(s, i) in stats" :key="s.label" :delay="i * 80">
          <div class="h-full bg-linen p-7">
            <p class="text-[11px] tracking-[0.3em] text-ink/45">{{ s.label }}</p>
            <p class="mt-4 font-display text-3xl text-gold-deep">{{ s.value }}</p>
          </div>
        </Reveal>
      </div>
      <div v-if="!loading && !error && !stats.length" class="py-16 text-center text-sm tracking-[0.2em] text-ink/45">
        暂无数据
      </div>

      <div class="mt-12 grid gap-8 lg:grid-cols-2">
        <!-- 近 7 日销售趋势 -->
        <div class="border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-xs tracking-[0.25em] text-ink/50">
            近 7 日销售趋势
          </div>
          <div class="flex h-48 items-end gap-3 px-6 pb-4 pt-6">
            <div v-for="d in daily" :key="d.label" class="flex flex-1 flex-col items-center gap-2">
              <span class="text-[10px] text-ink/45">
                {{ d.fen > 0 ? yuan(d.fen) : '' }}
              </span>
              <div
                class="w-full bg-gold-deep/85 transition-all"
                :style="{ height: barHeight(d.fen) }"
                :title="`${d.label} · ${yuan(d.fen)}`"
              />
              <span class="text-[10px] tracking-[0.1em] text-ink/40">
                {{ d.label }}
              </span>
            </div>
          </div>
        </div>

        <!-- 热销商品 Top5 -->
        <div class="border border-ink/10 bg-ivory">
          <div class="flex items-center justify-between border-b border-ink/10 px-6 py-4">
            <p class="text-xs tracking-[0.25em] text-ink/50">热销商品 Top 5</p>
            <router-link
              to="/admin/products"
              class="text-[11px] tracking-[0.2em] text-gold-deep hover:text-ink"
            >
              商品管理 →
            </router-link>
          </div>
          <div class="divide-y divide-ink/10">
            <div
              v-for="(p, i) in topProducts"
              :key="p.id"
              class="flex items-center gap-4 px-6 py-3.5 text-sm"
            >
              <span class="font-display text-lg text-gold-deep">
                {{ i + 1 }}
              </span>
              <span class="min-w-0 flex-1 truncate tracking-[0.08em] text-ink">
                {{ p.name }}
              </span>
              <span class="text-[10px] uppercase tracking-[0.15em] text-ink/35">
                {{ p.categoryName }}
              </span>
              <span class="text-xs text-ink/45">已售 {{ p.sales }}</span>
              <span class="text-gold-deep">{{ yuan(p.priceFen) }}</span>
            </div>
            <p v-if="topProducts.length === 0" class="px-6 py-10 text-center text-sm text-ink/40">
              暂无商品
            </p>
          </div>
        </div>

        <!-- 订单状态分布 -->
        <div class="border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-xs tracking-[0.25em] text-ink/50">
            订单状态分布
          </div>
          <div class="space-y-4 p-6">
            <div v-for="(st, key) in ORDER_STATUS" :key="key" class="flex items-center gap-4 text-xs">
              <span :class="`w-16 shrink-0 border px-2 py-0.5 text-center text-[10px] ${st.cls}`">
                {{ st.label }}
              </span>
              <div class="h-2 flex-1 bg-ink/[0.08]">
                <div
                  class="h-full bg-gold-deep"
                  :style="{ width: barWidth(statusCounts[key] ?? 0) }"
                />
              </div>
              <span class="w-8 text-right text-ink/60">{{ statusCounts[key] ?? 0 }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="mt-8 border border-ink/10 bg-ivory">
        <div class="flex items-center justify-between border-b border-ink/10 px-6 py-4">
          <p class="text-xs tracking-[0.25em] text-ink/50">最近订单</p>
          <router-link
            to="/admin/orders"
            class="text-[11px] tracking-[0.2em] text-gold-deep hover:text-ink"
          >
            全部订单 →
          </router-link>
        </div>
        <div class="divide-y divide-ink/10">
          <div
            v-for="o in recentOrders"
            :key="o.id"
            class="flex flex-wrap items-center justify-between gap-3 px-6 py-4 text-sm"
          >
            <span class="tracking-[0.1em] text-ink/80">{{ o.orderNo }}</span>
            <span class="text-xs text-ink/45">
              {{ o.userName || o.userEmail }}
            </span>
            <span class="text-xs text-ink/45">
              {{ formatDateTime(o.createdAt) }}
            </span>
            <span :class="`border px-2.5 py-0.5 text-[11px] ${(ORDER_STATUS[o.status] ?? ORDER_STATUS.PENDING_PAYMENT).cls}`">
              {{ (ORDER_STATUS[o.status] ?? ORDER_STATUS.PENDING_PAYMENT).label }}
            </span>
            <span class="font-display text-gold-deep">
              {{ yuan(o.totalFen) }}
            </span>
          </div>
          <p v-if="recentOrders.length === 0" class="px-6 py-10 text-center text-sm text-ink/40">
            暂无订单
          </p>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>
