<script setup>
import { ref, computed, onMounted } from 'vue'
import { adminApi } from '@/api'
import AdminLayout from '@/components/AdminLayout.vue'

const formatDateTime = (date) => {
  const d = new Date(date)
  const pad = (n) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`
}

const LEAD_TYPE = {
  FRANCHISE: '招商加盟',
  GROUP_BUY: '团购定制',
  COOPERATION: '商务合作',
}

const LEAD_STATUS = {
  NEW: { label: '新线索', cls: 'text-gold-deep border-gold/40 bg-gold/10' },
  CONTACTED: { label: '已联系', cls: 'text-sky-800 border-sky-700/30 bg-sky-700/10' },
  CLOSED: { label: '已关闭', cls: 'text-ink-soft border-ink/20 bg-ink/5' },
}

const STATUS_OPTIONS = [
  { value: 'NEW', label: '新线索' },
  { value: 'CONTACTED', label: '已联系' },
  { value: 'CLOSED', label: '已关闭' },
]

const leads = ref([])
const statusDraft = ref({})

const newCount = computed(() => leads.value.filter((l) => l.status === 'NEW').length)

const fetchLeads = async () => {
  try {
    const res = await adminApi.leads()
    leads.value = res.leads || []
    const draft = {}
    leads.value.forEach((l) => {
      draft[l.id] = l.status
    })
    statusDraft.value = draft
  } catch (e) {
    console.error('Failed to load leads', e)
  }
}

const updateStatus = async (l) => {
  await adminApi.updateLeadStatus(l.id, statusDraft.value[l.id])
  await fetchLeads()
}

onMounted(() => {
  document.title = '商机线索'
  fetchLeads()
})
</script>

<template>
  <AdminLayout>
    <div class="space-y-5">
      <div class="flex items-center justify-between">
        <p class="text-xs tracking-[0.25em] text-ink/50">
          全部线索（{{ leads.length }}）<span v-if="newCount > 0"> · {{ newCount }} 条待跟进</span>
        </p>
      </div>

      <p
        v-if="leads.length === 0"
        class="border border-ink/10 bg-ivory py-20 text-center text-sm text-ink/40"
      >
        暂无机会议——招商 / 团购 / 合作表单提交后将显示在这里。
      </p>

      <div v-for="l in leads" :key="l.id" class="border border-ink/10 bg-ivory">
        <div class="flex flex-wrap items-center justify-between gap-3 border-b border-ink/10 px-6 py-4 text-sm">
          <span class="border border-gold/40 bg-gold/10 px-2.5 py-0.5 text-[11px] tracking-[0.2em] text-gold-deep">
            {{ LEAD_TYPE[l.type] ?? l.type }}
          </span>
          <span class="tracking-[0.15em] text-ink">{{ l.name }}</span>
          <span class="font-display text-base text-ink/80">{{ l.phone }}</span>
          <span class="text-xs text-ink/45">{{ formatDateTime(l.createdAt) }}</span>
          <span :class="`border px-2.5 py-0.5 text-[11px] ${(LEAD_STATUS[l.status] ?? LEAD_STATUS.NEW).cls}`">
            {{ (LEAD_STATUS[l.status] ?? LEAD_STATUS.NEW).label }}
          </span>
        </div>
        <div class="flex flex-wrap items-center justify-between gap-4 px-6 py-4">
          <p class="min-w-0 flex-1 text-xs leading-relaxed text-ink/55">
            {{ l.note || '（未填写意向说明）' }}
          </p>
          <form @submit.prevent="updateStatus(l)" class="flex items-center gap-3">
            <select v-model="statusDraft[l.id]" class="field w-auto! py-2! text-xs">
              <option v-for="s in STATUS_OPTIONS" :key="s.value" :value="s.value">{{ s.label }}</option>
            </select>
            <button
              type="submit"
              class="cursor-pointer border border-ink/20 px-4 py-2 text-[11px] tracking-[0.2em] text-ink/70 transition-colors hover:border-gold-deep hover:text-gold-deep"
            >
              更新状态
            </button>
          </form>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>
