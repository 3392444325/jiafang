<script setup>
import { ref, onMounted } from 'vue'
import { adminApi } from '@/api'
import AdminLayout from '@/components/AdminLayout.vue'

const yuan = (fen) => '¥' + (fen / 100).toLocaleString()

const formatDateTime = (date) => {
  const d = new Date(date)
  const pad = (n) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`
}

const rows = ref([])
const totalSpent = ref(0)
const loading = ref(true)
const error = ref('')

onMounted(async () => {
  try {
    const res = await adminApi.customers()
    rows.value = res.customers || []
    totalSpent.value = res.totalSpent ?? 0
    error.value = ''
  } catch (e) {
    error.value = e.message || '客户数据加载失败，请刷新重试'
  } finally {
    loading.value = false
  }
})

document.title = '客户管理'
</script>

<template>
  <AdminLayout>
    <div>
      <div class="flex items-center justify-between border border-ink/10 bg-ivory px-6 py-4">
        <p class="text-xs tracking-[0.25em] text-ink/50">
          注册客户（{{ rows.length }}）
        </p>
        <p class="text-xs tracking-[0.2em] text-ink/50">
          累计贡献销售额
          <span class="font-display text-base text-gold-deep">
            {{ yuan(totalSpent) }}
          </span>
        </p>
      </div>

      <div v-if="error" class="mt-5 border border-red-700/30 bg-red-700/10 px-5 py-4 text-sm text-red-800">
        {{ error }}
      </div>

      <div class="mt-5 border border-ink/10 bg-ivory">
        <div class="grid grid-cols-[2fr_1fr_1fr_1fr_1.5fr] gap-4 border-b border-ink/10 px-6 py-3.5 text-[10px] uppercase tracking-[0.2em] text-ink/40">
          <span>客户</span>
          <span>注册时间</span>
          <span class="text-right">订单</span>
          <span class="text-right">最近下单</span>
          <span class="text-right">累计消费</span>
        </div>
        <div v-if="loading" class="px-6 py-10 text-sm tracking-[0.2em] text-ink/45">加载中…</div>
        <div v-else-if="!error && rows.length === 0" class="px-6 py-10 text-sm tracking-[0.2em] text-ink/45">
          暂无客户
        </div>
        <div v-else class="divide-y divide-ink/10">
          <div
            v-for="c in rows"
            :key="c.id"
            class="grid grid-cols-[2fr_1fr_1fr_1fr_1.5fr] items-center gap-4 px-6 py-4 text-sm"
          >
            <span class="min-w-0">
              <span class="block truncate tracking-[0.1em] text-ink">
                {{ c.name ?? '（未命名）' }}
                <span
                  v-if="c.role === 'ADMIN'"
                  class="ml-2 border border-sky-700/30 bg-sky-700/10 px-1.5 py-0.5 text-[9px] tracking-[0.15em] text-sky-800"
                >
                  管理员
                </span>
              </span>
              <span class="mt-0.5 block truncate text-[11px] text-ink/40">
                {{ c.email }}
              </span>
            </span>
            <span class="text-xs text-ink/45">
              {{ formatDateTime(c.createdAt) }}
            </span>
            <span class="text-right text-xs text-ink/60">
              {{ c.orderCount }} 单<span v-if="c.paidCount < c.orderCount">（付 {{ c.paidCount }}）</span>
            </span>
            <span class="text-right text-xs text-ink/45">
              {{ c.lastOrderAt ? formatDateTime(c.lastOrderAt) : '—' }}
            </span>
            <span class="text-right font-display text-gold-deep">
              {{ c.spent > 0 ? yuan(c.spent) : '—' }}
            </span>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>
