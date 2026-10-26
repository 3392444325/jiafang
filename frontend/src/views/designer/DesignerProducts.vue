<script setup>
import { ref, onMounted } from 'vue'
import { designerApi } from '@/api'
import ImageUploader from '@/components/ImageUploader.vue'
import DesignerLayout from '@/components/DesignerLayout.vue'

/** 新品发布（多图上传 + 拖拽排序）与已有商品图片管理 */

const products = ref([])
const categories = ref([])
const loading = ref(true)
const error = ref('')
const tip = ref('')

const form = ref(emptyForm())
const publishing = ref(false)

/** 图片管理：当前展开的商品 id + 编辑中的图片数组 */
const editingId = ref('')
const editingImages = ref([])
const savingImages = ref(false)
const imageError = ref('')

function emptyForm() {
  return {
    name: '',
    subtitle: '',
    categoryId: '',
    price: '',
    stock: 999,
    description: '',
    featured: false,
    images: [],
  }
}

const yuan = (fen) => '¥' + (fen / 100).toLocaleString('zh-CN')

async function load() {
  loading.value = true
  error.value = ''
  try {
    const res = await designerApi.products()
    products.value = res.products || []
    categories.value = res.categories || []
  } catch (e) {
    error.value = e.message || '加载失败'
  } finally {
    loading.value = false
  }
}

async function publish() {
  error.value = ''
  tip.value = ''
  publishing.value = true
  try {
    await designerApi.createProduct({
      name: form.value.name,
      subtitle: form.value.subtitle,
      categoryId: form.value.categoryId,
      price: Number(form.value.price),
      stock: Number(form.value.stock) || 999,
      description: form.value.description,
      featured: form.value.featured,
      images: form.value.images,
    })
    form.value = emptyForm()
    tip.value = '发布成功'
    await load()
  } catch (e) {
    error.value = e.message || '发布失败'
  } finally {
    publishing.value = false
  }
}

function openImages(p) {
  editingId.value = p.id
  editingImages.value = [...(p.images || [])]
  imageError.value = ''
}
function cancelImages() {
  editingId.value = ''
  editingImages.value = []
  imageError.value = ''
}
async function saveImages() {
  if (!editingImages.value.length) {
    imageError.value = '至少保留一张图片'
    return
  }
  error.value = ''
  imageError.value = ''
  savingImages.value = true
  try {
    await designerApi.updateProductImages(editingId.value, editingImages.value)
    tip.value = '图片已更新'
    cancelImages()
    await load()
  } catch (e) {
    imageError.value = e.message || '保存失败'
  } finally {
    savingImages.value = false
  }
}

onMounted(() => {
  document.title = '新品发布'
  load()
})
</script>

<template>
  <DesignerLayout>
    <div class="max-w-4xl">
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div>
          <p class="eyebrow">New Arrival</p>
          <h2 class="mt-3 font-display text-2xl tracking-[0.15em] text-ink">
            新品发布与图片管理
          </h2>
        </div>
        <div class="flex items-center gap-4">
          <span v-if="tip" class="text-[14px] tracking-[0.1em] text-emerald-700">{{ tip }}</span>
          <span v-if="error" class="text-[14px] text-red-700">{{ error }}</span>
        </div>
      </div>

      <div v-if="loading" class="mt-10 text-[15px] tracking-[0.2em] text-ink/75">加载中…</div>

      <template v-else>
        <!-- 商品列表 -->
        <section class="mt-8 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            全部商品（{{ products.length }}）
          </div>
          <div class="divide-y divide-ink/10">
            <div v-for="p in products" :key="p.id" class="px-6 py-4">
              <div class="flex flex-wrap items-center gap-4">
                <img
                  :src="(p.images && p.images[0]) || '/images/products/p01.jpg'"
                  :alt="p.name"
                  class="h-14 w-14 shrink-0 border border-ink/10 object-cover"
                />
                <span class="min-w-40 flex-1 text-[15px] tracking-[0.08em] text-ink">{{ p.name }}</span>
                <span class="text-[14px] text-ink/80">{{ p.categoryName }}</span>
                <span class="text-[15px] text-gold-deep">{{ yuan(p.priceFen) }}</span>
                <span class="text-[14px] text-ink/75">{{ (p.images || []).length }} 张图</span>
                <span
                  :class="`border px-2.5 py-0.5 text-[14px] ${
                    p.status === 'ACTIVE'
                      ? 'border-emerald-700/30 bg-emerald-700/10 text-emerald-800'
                      : 'border-ink/20 bg-ink/5 text-ink/80'
                  }`"
                >
                  {{ p.status === 'ACTIVE' ? '在售' : '已下架' }}
                </span>
                <button
                  class="cursor-pointer border border-ink/20 px-4 py-1.5 text-[14px] tracking-[0.2em] text-ink/80 transition-colors hover:border-gold-deep hover:text-gold-deep"
                  @click="editingId === p.id ? cancelImages() : openImages(p)"
                >
                  {{ editingId === p.id ? '收起' : '管理图片' }}
                </button>
              </div>

              <!-- 图片管理（展开） -->
              <div v-if="editingId === p.id" class="mt-5 border border-ink/10 bg-linen p-5">
                <ImageUploader v-model="editingImages" multiple aspect="aspect-square" />
                <p v-if="imageError" class="mt-2 text-[14px] text-red-700">{{ imageError }}</p>
                <div class="mt-4 flex gap-3">
                  <button class="btn-primary" :disabled="savingImages" @click="saveImages">
                    {{ savingImages ? '保存中…' : '保存图片' }}
                  </button>
                  <button
                    class="cursor-pointer border border-ink/20 px-5 py-2 text-[14px] tracking-[0.2em] text-ink/75 transition-colors hover:border-ink hover:text-ink"
                    @click="cancelImages"
                  >
                    取消
                  </button>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- 新品发布 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            新品发布
          </div>
          <form class="grid gap-4 p-6 sm:grid-cols-2" @submit.prevent="publish">
            <label>
              <span class="mb-1.5 block text-[14px] tracking-[0.2em] text-ink/80">商品名称</span>
              <input v-model="form.name" class="field" placeholder="如：「初雪」羊毛护膝毯" required />
            </label>
            <label>
              <span class="mb-1.5 block text-[14px] tracking-[0.2em] text-ink/80">副标题（选填）</span>
              <input v-model="form.subtitle" class="field" />
            </label>
            <label>
              <span class="mb-1.5 block text-[14px] tracking-[0.2em] text-ink/80">分类</span>
              <select v-model="form.categoryId" class="field" required>
                <option value="" disabled>选择分类</option>
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
              <input v-model.number="form.stock" type="number" min="0" step="1" class="field" />
            </label>
            <label class="flex items-end pb-1">
              <span class="flex cursor-pointer items-center gap-3 text-[14px] tracking-[0.15em] text-ink/75">
                <input v-model="form.featured" type="checkbox" class="accent-[#8F7A50]" />
                设为商城「当季精选」
              </span>
            </label>
            <label class="sm:col-span-2">
              <span class="mb-1.5 block text-[14px] tracking-[0.2em] text-ink/80">商品描述</span>
              <textarea v-model="form.description" class="field" rows="3" placeholder="选填" />
            </label>
            <div class="sm:col-span-2">
              <span class="mb-2 block text-[14px] tracking-[0.2em] text-ink/80">
                商品图片（可多张上传，拖拽排序，第一张为主图）
              </span>
              <ImageUploader v-model="form.images" multiple aspect="aspect-square" />
            </div>
            <div class="sm:col-span-2">
              <button type="submit" class="btn-primary" :disabled="publishing">
                {{ publishing ? '发布中…' : '发布商品' }}
              </button>
            </div>
          </form>
        </section>
      </template>
    </div>
  </DesignerLayout>
</template>
