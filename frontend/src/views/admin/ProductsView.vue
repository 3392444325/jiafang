<script setup>
import { ref, onMounted } from 'vue'
import { adminApi } from '@/api'
import AdminLayout from '@/components/AdminLayout.vue'

const yuan = (fen) => '¥' + (fen / 100).toLocaleString()

const IMAGE_OPTIONS = Array.from({ length: 12 }, (_, i) => {
  const n = String(i + 1).padStart(2, '0')
  return { value: `/images/products/p${n}.svg`, label: `织物质感 ${n}` }
})

const products = ref([])
const categories = ref([])

const newProduct = ref({
  name: '',
  categoryId: '',
  price: '',
  image: IMAGE_OPTIONS[0].value,
  description: '',
  featured: false,
})

const newCategory = ref({ name: '', nameEn: '', tagline: '' })

const fetchProducts = async () => {
  try {
    const res = await adminApi.products()
    products.value = (res.products || []).map((p) => ({
      ...p,
      categoryName: p.category?.name ?? p.categoryName ?? '',
    }))
    categories.value = res.categories || []
  } catch (e) {
    console.error('Failed to load products', e)
  }
}

const saveStock = async (p) => {
  await adminApi.updateStock(p.id, p.stock)
  await fetchProducts()
}

const toggleProduct = async (p) => {
  await adminApi.toggleProduct(p.id)
  await fetchProducts()
}

const submitProduct = async () => {
  await adminApi.createProduct({
    name: newProduct.value.name,
    categoryId: newProduct.value.categoryId,
    price: Number(newProduct.value.price),
    description: newProduct.value.description,
    image: newProduct.value.image,
    featured: newProduct.value.featured,
  })
  newProduct.value = {
    name: '',
    categoryId: '',
    price: '',
    image: IMAGE_OPTIONS[0].value,
    description: '',
    featured: false,
  }
  await fetchProducts()
}

const submitCategory = async () => {
  await adminApi.createCategory({
    name: newCategory.value.name,
    nameEn: newCategory.value.nameEn,
    tagline: newCategory.value.tagline,
  })
  newCategory.value = { name: '', nameEn: '', tagline: '' }
  await fetchProducts()
}

onMounted(() => {
  document.title = '商品管理'
  fetchProducts()
})
</script>

<template>
  <AdminLayout>
    <div>
      <!-- 商品列表 -->
      <div class="border border-ink/10 bg-ivory">
        <div class="border-b border-ink/10 px-6 py-4 text-xs tracking-[0.25em] text-ink/50">
          全部商品（{{ products.length }}）
        </div>
        <div class="divide-y divide-ink/10">
          <div
            v-for="p in products"
            :key="p.id"
            class="flex flex-wrap items-center gap-4 px-6 py-4 text-sm"
          >
            <span class="min-w-48 flex-1 tracking-[0.08em] text-ink">
              {{ p.name }}
              <span class="ml-3 text-[10px] uppercase tracking-[0.15em] text-ink/35">
                {{ p.slug }}
              </span>
            </span>
            <span class="text-xs text-ink/50">{{ p.categoryName }}</span>
            <span class="text-gold-deep">{{ yuan(p.priceFen) }}</span>
            <span class="text-xs text-ink/45">已售 {{ p.sales }}</span>
            <form @submit.prevent="saveStock(p)" class="flex items-center gap-2">
              <input
                v-model.number="p.stock"
                type="number"
                min="0"
                step="1"
                title="库存"
                class="field w-20! py-1.5! text-xs"
              />
              <button
                type="submit"
                class="cursor-pointer border border-ink/20 px-3 py-1.5 text-[10px] tracking-[0.15em] text-ink/70 transition-colors hover:border-gold-deep hover:text-gold-deep"
              >
                存
              </button>
            </form>
            <span
              :class="`border px-2.5 py-0.5 text-[11px] ${
                p.status === 'ACTIVE'
                  ? 'border-emerald-700/30 bg-emerald-700/10 text-emerald-800'
                  : 'border-ink/20 bg-ink/5 text-ink/50'
              }`"
            >
              {{ p.status === 'ACTIVE' ? '在售' : '已下架' }}
            </span>
            <form @submit.prevent="toggleProduct(p)">
              <button
                type="submit"
                class="cursor-pointer border border-ink/20 px-4 py-1.5 text-[11px] tracking-[0.2em] text-ink/70 transition-colors hover:border-gold-deep hover:text-gold-deep"
              >
                {{ p.status === 'ACTIVE' ? '下架' : '上架' }}
              </button>
            </form>
            <router-link
              :to="`/admin/products/${p.id}`"
              class="border border-ink/20 px-4 py-1.5 text-[11px] tracking-[0.2em] text-ink/70 transition-colors hover:border-gold-deep hover:text-gold-deep"
            >
              编辑
            </router-link>
          </div>
        </div>
      </div>

      <!-- 新品上架 -->
      <div class="mt-10 border border-ink/10 bg-ivory">
        <div class="border-b border-ink/10 px-6 py-4 text-xs tracking-[0.25em] text-ink/50">
          新品上架
        </div>
        <form @submit.prevent="submitProduct" class="grid gap-4 p-6 sm:grid-cols-2">
          <input
            v-model="newProduct.name"
            class="field"
            placeholder="商品名称（如：「初雪」羊毛护膝毯）"
            required
          />
          <select v-model="newProduct.categoryId" class="field" required>
            <option value="" disabled>选择分类</option>
            <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
          </select>
          <input
            v-model="newProduct.price"
            type="number"
            min="1"
            step="0.01"
            placeholder="售价（元）"
            class="field"
            required
          />
          <select v-model="newProduct.image" class="field">
            <option v-for="o in IMAGE_OPTIONS" :key="o.value" :value="o.value">{{ o.label }}</option>
          </select>
          <textarea
            v-model="newProduct.description"
            class="field sm:col-span-2"
            rows="3"
            placeholder="商品描述（选填）"
          />
          <label class="flex cursor-pointer items-center gap-3 text-xs tracking-[0.15em] text-ink/60">
            <input v-model="newProduct.featured" type="checkbox" class="accent-[#8F7A50]" />
            设为首页「当季精选」
          </label>
          <div class="sm:col-span-2">
            <button type="submit" class="btn-primary">发布商品</button>
          </div>
        </form>
      </div>

      <!-- 新增分类 -->
      <div class="mt-10 border border-ink/10 bg-ivory">
        <div class="border-b border-ink/10 px-6 py-4 text-xs tracking-[0.25em] text-ink/50">
          新增分类
        </div>
        <form @submit.prevent="submitCategory" class="grid gap-4 p-6 sm:grid-cols-4">
          <input v-model="newCategory.name" class="field" placeholder="分类名称（如：毯类）" required />
          <input v-model="newCategory.nameEn" class="field" placeholder="英文名（如 Throws）" required />
          <input v-model="newCategory.tagline" class="field" placeholder="一句话介绍（选填）" />
          <button type="submit" class="btn-primary">创建分类</button>
        </form>
      </div>
    </div>
  </AdminLayout>
</template>
