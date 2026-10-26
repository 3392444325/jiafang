<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { adminApi } from '@/api'
import AdminLayout from '@/components/AdminLayout.vue'

const route = useRoute()
const router = useRouter()

const product = ref(null)
const categories = ref([])

const form = ref({
  name: '',
  subtitle: '',
  categoryId: '',
  price: '',
  stock: 0,
  featured: false,
  description: '',
})

const fetchProduct = async () => {
  try {
    const res = await adminApi.productForEdit(route.params.id)
    if (!res.product) {
      router.replace('/admin/products')
      return
    }
    const p = res.product
    product.value = p
    categories.value = res.categories || []
    form.value = {
      name: p.name ?? '',
      subtitle: p.subtitle ?? '',
      categoryId: p.categoryId ?? '',
      price: (p.priceFen / 100).toFixed(2),
      stock: p.stock ?? 0,
      featured: !!p.featured,
      description: p.description ?? '',
    }
  } catch (e) {
    console.error('Failed to load product', e)
    router.replace('/admin/products')
  }
}

const submit = async () => {
  await adminApi.updateProduct({
    id: route.params.id,
    name: form.value.name,
    subtitle: form.value.subtitle,
    description: form.value.description,
    categoryId: form.value.categoryId,
    price: Number(form.value.price),
    stock: Number(form.value.stock),
    featured: form.value.featured,
  })
  router.push('/admin/products')
}

onMounted(() => {
  document.title = '编辑商品'
  fetchProduct()
})
</script>

<template>
  <AdminLayout>
    <div v-if="product" class="max-w-3xl">
      <div class="flex items-center justify-between">
        <div>
          <p class="eyebrow">Edit Product</p>
          <h2 class="mt-3 font-display text-2xl tracking-[0.15em] text-ink">
            {{ product.name }}
          </h2>
        </div>
        <router-link
          to="/admin/products"
          class="text-[14px] tracking-[0.2em] text-gold-deep hover:text-ink"
        >
          ← 返回列表
        </router-link>
      </div>

      <form
        @submit.prevent="submit"
        class="mt-8 grid gap-4 border border-ink/10 bg-ivory p-6 sm:grid-cols-2"
      >
        <label class="sm:col-span-2">
          <span class="mb-1.5 block text-[14px] tracking-[0.2em] text-ink/80">商品名称</span>
          <input v-model="form.name" class="field" required />
        </label>
        <label class="sm:col-span-2">
          <span class="mb-1.5 block text-[14px] tracking-[0.2em] text-ink/80">副标题（选填）</span>
          <input v-model="form.subtitle" class="field" />
        </label>
        <label>
          <span class="mb-1.5 block text-[14px] tracking-[0.2em] text-ink/80">分类</span>
          <select v-model="form.categoryId" class="field" required>
            <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
          </select>
        </label>
        <label>
          <span class="mb-1.5 block text-[14px] tracking-[0.2em] text-ink/80">售价（元）</span>
          <input
            v-model="form.price"
            type="number"
            min="0.01"
            step="0.01"
            class="field"
            required
          />
        </label>
        <label>
          <span class="mb-1.5 block text-[14px] tracking-[0.2em] text-ink/80">库存</span>
          <input
            v-model.number="form.stock"
            type="number"
            min="0"
            step="1"
            class="field"
            required
          />
        </label>
        <label class="flex items-end pb-1">
          <span class="flex cursor-pointer items-center gap-3 text-[14px] tracking-[0.15em] text-ink/75">
            <input v-model="form.featured" type="checkbox" class="accent-[#8F7A50]" />
            设为首页「当季精选」
          </span>
        </label>
        <label class="sm:col-span-2">
          <span class="mb-1.5 block text-[14px] tracking-[0.2em] text-ink/80">商品描述</span>
          <textarea v-model="form.description" class="field" rows="4" />
        </label>
        <div class="sm:col-span-2">
          <button type="submit" class="btn-primary">保存修改</button>
        </div>
      </form>
    </div>
  </AdminLayout>
</template>
