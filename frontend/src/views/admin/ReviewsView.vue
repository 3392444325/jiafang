<script setup>
import { ref, onMounted } from 'vue'
import { adminApi } from '@/api'
import AdminLayout from '@/components/AdminLayout.vue'

const formatDate = (date) => {
  const d = new Date(date)
  return `${d.getFullYear()}年${d.getMonth() + 1}月${d.getDate()}日`
}

const reviews = ref([])
const avg = ref('—')

const fetchReviews = async () => {
  try {
    const res = await adminApi.reviews()
    reviews.value = (res.reviews || []).map((r) => ({
      ...r,
      userName: r.user?.name ?? r.userName ?? '',
      userEmail: r.user?.email ?? r.userEmail ?? '',
      productSlug: r.product?.slug ?? r.productSlug ?? '',
      productName: r.product?.name ?? r.productName ?? '',
    }))
    avg.value = res.avg ?? (reviews.value.length > 0
      ? (reviews.value.reduce((s, r) => s + r.rating, 0) / reviews.value.length).toFixed(1)
      : '—')
  } catch (e) {
    console.error('Failed to load reviews', e)
  }
}

const deleteReview = async (r) => {
  await adminApi.deleteReview(r.id)
  await fetchReviews()
}

onMounted(() => {
  document.title = '评论管理'
  fetchReviews()
})
</script>

<template>
  <AdminLayout>
    <div class="space-y-5">
      <div class="flex items-center justify-between">
        <p class="text-xs tracking-[0.25em] text-ink/50">
          全部评论（{{ reviews.length }}）· 平均评分 {{ avg }} / 5.0
        </p>
      </div>

      <div v-if="error" class="border border-red-700/30 bg-red-700/10 px-5 py-4 text-sm text-red-800">
        {{ error }}
      </div>
      <div v-if="actionError" class="border border-amber-700/30 bg-amber-700/10 px-5 py-4 text-sm text-amber-800">
        {{ actionError }}
      </div>

      <p
        v-if="loading"
        class="border border-ink/10 bg-ivory py-20 text-center text-sm text-ink/40"
      >
        加载中…
      </p>
      <p
        v-else-if="!error && reviews.length === 0"
        class="border border-ink/10 bg-ivory py-20 text-center text-sm text-ink/40"
      >
        暂无用户评论
      </p>

      <div v-for="r in reviews" :key="r.id" class="border border-ink/10 bg-ivory px-6 py-5">
        <div class="flex flex-wrap items-center justify-between gap-3 text-sm">
          <div class="flex items-center gap-4">
            <span class="tracking-[0.15em] text-gold">
              {{ '★'.repeat(r.rating) }}<span class="text-ink/20">{{ '☆'.repeat(5 - r.rating) }}</span>
            </span>
            <span class="text-xs text-ink/60">
              {{ r.userName || r.userEmail }}
            </span>
            <span class="text-[11px] text-ink/40">
              {{ formatDate(r.createdAt) }}
            </span>
          </div>
          <form @submit.prevent="deleteReview(r)">
            <button
              type="submit"
              class="cursor-pointer border border-ink/20 px-4 py-1.5 text-[11px] tracking-[0.2em] text-ink/70 transition-colors hover:border-red-700/50 hover:text-red-800"
            >
              删除
            </button>
          </form>
        </div>
        <p class="mt-3 text-sm leading-loose text-ink/75">「{{ r.content }}」</p>
        <router-link
          :to="`/products/${r.productSlug}`"
          class="link-underline mt-3 inline-block text-[11px] tracking-[0.15em] text-ink/45 hover:text-gold-deep"
        >
          {{ r.productName }} →
        </router-link>
      </div>
    </div>
  </AdminLayout>
</template>
