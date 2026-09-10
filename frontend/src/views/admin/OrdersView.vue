<script setup>
import { ref, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { adminApi } from '@/api'
import AdminLayout from '@/components/AdminLayout.vue'

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

const STATUS_OPTIONS = [
  { value: 'PENDING_PAYMENT', label: '待付款' },
  { value: 'PAID', label: '已付款' },
  { value: 'SHIPPED', label: '已发货' },
  { value: 'COMPLETED', label: '已完成' },
  { value: 'CANCELLED', label: '已取消' },
]

const FILTER_OPTIONS = [{ value: 'all', label: '全部' }, ...STATUS_OPTIONS]

const route = useRoute()
const router = useRouter()

const status = computed(() => (route.query.status ?? 'all'))
const q = computed(() => (route.query.q ?? '').trim())

const orders = ref([])
const statusDraft = ref({})
const qInput = ref(q.value)

watch(q, (val) => {
  qInput.value = val
})

const statusLabel = (val) => STATUS_OPTIONS.find((s) => s.value === val)?.label ?? ''

const summaryText = computed(() => {
  if (q.value) return `搜索「${q.value}」`
  if (status.value === 'all') return '全部订单'
  return statusLabel(status.value)
})

const queryTarget = (patch) => ({
  path: '/admin/orders',
  query: { status: status.value, ...(q.value ? { q: q.value } : {}), ...patch },
})

const onSearch = () => {
  router.push({
    path: '/admin/orders',
    query: { status: status.value, q: qInput.value },
  })
}

const fetchOrders = async () => {
  try {
    const res = await adminApi.orders({ status: status.value, q: q.value })
    orders.value = (res.orders || []).map((o) => ({
      ...o,
      userName: o.user?.name ?? o.userName ?? '',
      userEmail: o.user?.email ?? o.userEmail ?? '',
      items: o.items ?? [],
    }))
    const draft = {}
    orders.value.forEach((o) => {
      draft[o.id] = o.status
    })
    statusDraft.value = draft
  } catch (e) {
    console.error('Failed to load orders', e)
  }
}

watch(
  () => `${route.query.status}|${route.query.q}`,
  () => {
    fetchOrders()
  },
  { immediate: true }
)

const updateStatus = async (o) => {
  actionError.value = ''
  try {
    await adminApi.updateOrderStatus(o.id, statusDraft.value[o.id])
    await fetchOrders()
  } catch (e) {
    actionError.value = e.message || '状态更新失败'
    await fetchOrders()
  }
}

// 用 fetch + blob 导出，避免会话失效时整页跳到 JSON 错误页，并携带当前筛选条件
const exportCsv = async () => {
  actionError.value = ''
  try {
    const params = new URLSearchParams()
    if (status.value !== 'all') params.set('status', status.value)
    if (q.value) params.set('q', q.value)
    const qs = params.toString()
    const res = await fetch(`/api/admin/orders/export${qs ? `?${qs}` : ''}`, {
      credentials: 'include',
    })
    if (!res.ok) throw new Error('导出失败，请重新登录后重试')
    const blob = await res.blob()
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = 'orders.csv'
    a.click()
    URL.revokeObjectURL(url)
  } catch (e) {
    actionError.value = e.message || '导出失败'
  }
}

document.title = '订单管理'
</script>

<template>
  <AdminLayout>
    <div class="space-y-5">
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div class="flex flex-wrap items-center gap-x-5 gap-y-2 text-[12px] tracking-[0.15em]">
          <span class="text-[10px] uppercase tracking-[0.3em] text-ink/30">Filter</span>
          <router-link
            v-for="s in FILTER_OPTIONS"
            :key="s.value"
            :to="queryTarget({ status: s.value })"
            :class="status === s.value ? 'text-gold-deep' : 'text-ink/50 transition-colors hover:text-ink'"
          >
            {{ s.label }}
          </router-link>
        </div>
        <div class="flex items-center gap-4">
          <form @submit.prevent="onSearch" class="flex items-center gap-2">
            <input
              v-model="qInput"
              placeholder="搜索订单号…"
              class="field w-44! py-2! text-xs"
            />
            <button
              type="submit"
              class="cursor-pointer border border-ink/20 px-4 py-2 text-[11px] tracking-[0.2em] text-ink/70 transition-colors hover:border-gold-deep hover:text-gold-deep"
            >
              搜索
            </button>
          </form>
          <button
            type="button"
            @click="exportCsv"
            class="cursor-pointer border border-ink/20 px-4 py-2 text-[11px] tracking-[0.2em] text-ink/70 transition-colors hover:border-gold-deep hover:text-gold-deep"
          >
            导出 CSV
          </button>
        </div>
      </div>
      <div v-if="error" class="border border-red-700/30 bg-red-700/10 px-5 py-4 text-sm text-red-800">
        {{ error }}
      </div>
      <div v-if="actionError" class="border border-amber-700/30 bg-amber-700/10 px-5 py-4 text-sm text-amber-800">
        {{ actionError }}
      </div>
      <p class="text-xs tracking-[0.25em] text-ink/50">
        {{ summaryText }}（{{ orders.length }}）
      </p>
      <p v-if="loading" class="py-20 text-center text-sm text-ink/40">加载中…</p>
      <p v-else-if="!error && orders.length === 0" class="py-20 text-center text-sm text-ink/40">暂无订单</p>
      <div v-for="o in orders" :key="o.id" class="border border-ink/10 bg-ivory">
        <div class="flex flex-wrap items-center justify-between gap-3 border-b border-ink/10 px-6 py-4 text-sm">
          <span class="tracking-[0.1em] text-ink/80">{{ o.orderNo }}</span>
          <span class="text-xs text-ink/45">
            {{ o.userName || o.userEmail }} · {{ o.items.length }} 件商品 · {{ formatDateTime(o.createdAt) }}
          </span>
          <span class="font-display text-lg text-gold-deep">
            {{ yuan(o.totalFen) }}
          </span>
          <span :class="`border px-2.5 py-0.5 text-[11px] ${(ORDER_STATUS[o.status] ?? ORDER_STATUS.PENDING_PAYMENT).cls}`">
            {{ (ORDER_STATUS[o.status] ?? ORDER_STATUS.PENDING_PAYMENT).label }}
          </span>
        </div>
        <div class="flex flex-wrap items-center justify-between gap-4 px-6 py-4">
          <div class="text-xs leading-relaxed text-ink/50">
            <p v-for="it in o.items" :key="it.id">
              {{ it.nameSnap }} × {{ it.qty }}
            </p>
          </div>
          <form @submit.prevent="updateStatus(o)" class="flex items-center gap-3">
            <select v-model="statusDraft[o.id]" class="field !w-auto !py-2 text-xs">
              <option v-for="s in STATUS_OPTIONS" :key="s.value" :value="s.value">{{ s.label }}</option>
            </select>
            <button
              type="submit"
              class="cursor-pointer border border-ink/20 px-4 py-2 text-[11px] tracking-[0.2em] text-ink/70 transition-colors hover:border-gold-deep hover:text-gold-deep"
            >
              更新状态
            </button>
            <router-link
              :to="`/orders/${o.id}`"
              class="text-[11px] tracking-[0.2em] text-gold-deep hover:text-ink"
            >
              详情 →
            </router-link>
          </form>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>
