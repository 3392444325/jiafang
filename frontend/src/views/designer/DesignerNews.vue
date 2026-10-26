<script setup>
import { ref, onMounted } from 'vue'
import { designerApi } from '@/api'
import { pickDefaults } from '@/utils/siteContent'
import { ymd } from '@/utils/format'
import ImageUploader from '@/components/ImageUploader.vue'
import DesignerLayout from '@/components/DesignerLayout.vue'

/** 品牌动态管理：新闻页头图（site_content）+ 文章管理（news 表，逐篇增删改） */

const content = ref(pickDefaults(['news.hero']))
const loading = ref(true)
const saving = ref(false)
const savedTip = ref('')
const error = ref('')

// 文章管理
const list = ref([])
const editing = ref(null)
const savingArticle = ref(false)
const titleError = ref('')
const articleError = ref('')
const tip = ref('')

function emptyArticle() {
  return {
    id: null,
    title: '',
    category: '品牌新闻',
    cover: '',
    excerpt: '',
    content: '',
    featured: false,
    published: true,
  }
}

async function load() {
  loading.value = true
  error.value = ''
  try {
    const [data, newsRes] = await Promise.all([designerApi.content(), designerApi.newsList()])
    const hero = data && data['news.hero']
    if (hero && typeof hero === 'object') {
      content.value['news.hero'] = { ...content.value['news.hero'], ...hero }
    }
    list.value = newsRes.news || []
  } catch (e) {
    error.value = e.message || '加载失败'
  } finally {
    loading.value = false
  }
}

async function save() {
  saving.value = true
  savedTip.value = ''
  error.value = ''
  try {
    await designerApi.saveContent(content.value)
    savedTip.value = '已保存，前台刷新页面即可看到效果'
    window.scrollTo({ top: 0, behavior: 'smooth' })
  } catch (e) {
    error.value = e.message || '保存失败'
  } finally {
    saving.value = false
  }
}

function writeNew() {
  tip.value = ''
  titleError.value = ''
  articleError.value = ''
  editing.value = emptyArticle()
}

function editArticle(a) {
  tip.value = ''
  titleError.value = ''
  articleError.value = ''
  editing.value = {
    id: a.id,
    title: a.title || '',
    category: a.category || '品牌新闻',
    cover: a.cover || '',
    excerpt: a.excerpt || '',
    content: a.content || '',
    featured: !!a.featured,
    published: !!a.published,
  }
}

function cancelEdit() {
  editing.value = null
  titleError.value = ''
  articleError.value = ''
}

async function saveArticle() {
  if (!editing.value) return
  if (!editing.value.title.trim()) {
    titleError.value = '请填写文章标题'
    return
  }
  titleError.value = ''
  articleError.value = ''
  savingArticle.value = true
  try {
    const payload = {
      title: editing.value.title,
      category: editing.value.category,
      cover: editing.value.cover,
      excerpt: editing.value.excerpt,
      content: editing.value.content,
      featured: editing.value.featured,
      published: editing.value.published,
    }
    if (editing.value.id) {
      await designerApi.newsUpdate({ id: editing.value.id, ...payload })
    } else {
      await designerApi.newsCreate(payload)
    }
    editing.value = null
    tip.value = '文章已保存'
    await load()
  } catch (e) {
    articleError.value = e.message || '保存失败'
  } finally {
    savingArticle.value = false
  }
}

async function removeArticle(a) {
  if (!window.confirm('确认删除这篇文章？')) return
  articleError.value = ''
  try {
    await designerApi.newsDelete(a.id)
    tip.value = '文章已删除'
    await load()
  } catch (e) {
    articleError.value = e.message || '删除失败'
  }
}

onMounted(() => {
  document.title = '页面设计 · 品牌动态'
  load()
})
</script>

<template>
  <DesignerLayout>
    <div class="max-w-4xl">
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div>
          <p class="eyebrow">News Design</p>
          <h2 class="mt-3 font-display text-2xl tracking-[0.15em] text-ink">
            品牌动态管理
          </h2>
        </div>
        <div class="flex items-center gap-4">
          <span v-if="savedTip || tip" class="text-[14px] tracking-[0.1em] text-emerald-700">{{ savedTip || tip }}</span>
          <span v-if="error" class="text-[14px] text-red-700">{{ error }}</span>
          <button class="btn-primary" :disabled="saving || loading" @click="save">
            {{ saving ? '保存中…' : '保存全部' }}
          </button>
        </div>
      </div>

      <div v-if="loading" class="mt-10 text-[15px] tracking-[0.2em] text-ink/75">加载中…</div>

      <template v-else>
        <!-- 新闻页头图 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            新闻页头图
          </div>
          <div class="grid gap-5 p-6 md:grid-cols-[280px_1fr]">
            <ImageUploader
              :modelValue="content['news.hero'].img ? [content['news.hero'].img] : []"
              aspect="aspect-[16/10]"
              @update:modelValue="(v) => (content['news.hero'].img = v[0] || '')"
            />
            <div class="grid gap-3 sm:grid-cols-2">
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">眉题</span>
                <input v-model="content['news.hero'].eyebrow" class="field" />
              </label>
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">标题</span>
                <input v-model="content['news.hero'].title" class="field" />
              </label>
              <label class="sm:col-span-2">
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">副标题</span>
                <textarea v-model="content['news.hero'].sub" class="field" rows="2" />
              </label>
            </div>
          </div>
        </section>

        <!-- 文章管理 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="flex items-center justify-between border-b border-ink/10 px-6 py-4">
            <span class="text-[14px] tracking-[0.25em] text-ink/80">文章管理（{{ list.length }} 篇）</span>
            <button
              class="cursor-pointer border border-ink/20 px-4 py-1.5 text-[14px] tracking-[0.2em] text-ink/80 transition-colors hover:border-gold-deep hover:text-gold-deep"
              @click="writeNew"
            >
              + 写新文章
            </button>
          </div>

          <!-- 文章编辑器（新建 / 编辑） -->
          <div v-if="editing" class="border-b border-ink/10 bg-linen">
            <div class="px-6 pt-5 text-[14px] tracking-[0.25em] text-ink/75">
              {{ editing.id ? '编辑文章' : '新建文章' }}
            </div>
            <div class="grid gap-4 p-6 pt-4 sm:grid-cols-2">
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">标题</span>
                <input v-model="editing.title" class="field" />
                <span v-if="titleError" class="mt-1 block text-[14px] text-red-700">{{ titleError }}</span>
              </label>
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">分类</span>
                <input v-model="editing.category" class="field" />
              </label>
              <div class="sm:col-span-2">
                <span class="mb-2 block text-[14px] tracking-[0.2em] text-ink/80">封面图</span>
                <ImageUploader
                  :modelValue="editing.cover ? [editing.cover] : []"
                  aspect="aspect-[16/9]"
                  @update:modelValue="(v) => (editing.cover = v[0] || '')"
                />
              </div>
              <label class="sm:col-span-2">
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">摘要</span>
                <textarea v-model="editing.excerpt" class="field" rows="3" />
              </label>
              <label class="sm:col-span-2">
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">正文</span>
                <textarea v-model="editing.content" class="field" rows="8" />
              </label>
              <label class="flex items-end pb-1">
                <span class="flex cursor-pointer items-center gap-3 text-[14px] tracking-[0.15em] text-ink/75">
                  <input v-model="editing.featured" type="checkbox" class="accent-[#8F7A50]" />
                  设为头条
                </span>
              </label>
              <label class="flex items-end pb-1">
                <span class="flex cursor-pointer items-center gap-3 text-[14px] tracking-[0.15em] text-ink/75">
                  <input v-model="editing.published" type="checkbox" class="accent-[#8F7A50]" />
                  发布（取消勾选则保存为草稿）
                </span>
              </label>
              <p v-if="articleError" class="text-[14px] text-red-700 sm:col-span-2">{{ articleError }}</p>
              <div class="flex gap-3 sm:col-span-2">
                <button class="btn-primary" :disabled="savingArticle" @click="saveArticle">
                  {{ savingArticle ? '保存中…' : '保存文章' }}
                </button>
                <button
                  class="cursor-pointer border border-ink/20 px-5 py-2 text-[14px] tracking-[0.2em] text-ink/75 transition-colors hover:border-ink hover:text-ink"
                  @click="cancelEdit"
                >
                  取消
                </button>
              </div>
            </div>
          </div>

          <!-- 文章列表 -->
          <div v-if="list.length" class="divide-y divide-ink/10">
            <div v-for="a in list" :key="a.id" class="flex flex-wrap items-center gap-4 px-6 py-4">
              <span class="min-w-40 flex-1 text-[15px] tracking-[0.08em] text-ink">{{ a.title }}</span>
              <span class="text-[14px] text-ink/80">{{ a.category }}</span>
              <span
                :class="`border px-2.5 py-0.5 text-[14px] ${
                  a.featured
                    ? 'border-gold-deep/40 bg-gold-deep/10 text-gold-deep'
                    : 'border-ink/20 bg-ink/5 text-ink/80'
                }`"
              >
                {{ a.featured ? '头条' : '普通' }}
              </span>
              <span
                :class="`border px-2.5 py-0.5 text-[14px] ${
                  a.published
                    ? 'border-emerald-700/30 bg-emerald-700/10 text-emerald-800'
                    : 'border-ink/20 bg-ink/5 text-ink/80'
                }`"
              >
                {{ a.published ? '已发布' : '草稿' }}
              </span>
              <span class="text-[14px] text-ink/75">{{ a.publishedAt ? ymd(a.publishedAt) : '—' }}</span>
              <button
                class="cursor-pointer border border-ink/20 px-4 py-1.5 text-[14px] tracking-[0.2em] text-ink/80 transition-colors hover:border-gold-deep hover:text-gold-deep"
                @click="editing && editing.id === a.id ? cancelEdit() : editArticle(a)"
              >
                {{ editing && editing.id === a.id ? '收起' : '编辑' }}
              </button>
              <button
                class="cursor-pointer border border-ink/20 px-4 py-1.5 text-[14px] tracking-[0.2em] text-ink/80 transition-colors hover:border-red-700 hover:text-red-700"
                @click="removeArticle(a)"
              >
                删除
              </button>
            </div>
          </div>
          <div v-else class="px-6 py-10 text-center text-[14px] tracking-[0.2em] text-ink/75">
            暂无文章，点击右上角「+ 写新文章」创建第一篇
          </div>
        </section>

        <div class="mt-8 flex items-center justify-end gap-4">
          <span v-if="savedTip" class="text-[14px] tracking-[0.1em] text-emerald-700">{{ savedTip }}</span>
          <button class="btn-primary" :disabled="saving || loading" @click="save">
            {{ saving ? '保存中…' : '保存全部' }}
          </button>
        </div>
      </template>
    </div>
  </DesignerLayout>
</template>
