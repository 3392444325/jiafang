<script setup>
import { ref, onMounted } from 'vue'
import { designerApi } from '@/api'
import { pickDefaults, mergeContent } from '@/utils/siteContent'
import ImageUploader from '@/components/ImageUploader.vue'
import ListSection from '@/components/ListSection.vue'
import StringListSection from '@/components/StringListSection.vue'
import DesignerLayout from '@/components/DesignerLayout.vue'

/** 团购定制页设计：主视觉 / 定制场景 / 定制流程 / 服务承诺 */

const KEYS = [
  'groupbuy.hero', 'groupbuy.scenes', 'groupbuy.steps', 'groupbuy.promises',
]

const content = ref(pickDefaults(KEYS))
const loading = ref(true)
const saving = ref(false)
const savedTip = ref('')
const error = ref('')

async function load() {
  loading.value = true
  error.value = ''
  try {
    const data = await designerApi.content()
    content.value = mergeContent(pickDefaults(KEYS), data)
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

onMounted(() => {
  document.title = '页面设计 · 团购定制'
  load()
})
</script>

<template>
  <DesignerLayout>
    <div class="max-w-4xl">
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div>
          <p class="eyebrow">Groupbuy Design</p>
          <h2 class="mt-3 font-display text-2xl tracking-[0.15em] text-ink">
            团购定制页设计
          </h2>
        </div>
        <div class="flex items-center gap-4">
          <span v-if="savedTip" class="text-[14px] tracking-[0.1em] text-emerald-700">{{ savedTip }}</span>
          <span v-if="error" class="text-[14px] text-red-700">{{ error }}</span>
          <button class="btn-primary" :disabled="saving || loading" @click="save">
            {{ saving ? '保存中…' : '保存全部' }}
          </button>
        </div>
      </div>

      <div v-if="loading" class="mt-10 text-[15px] tracking-[0.2em] text-ink/75">加载中…</div>

      <template v-else>
        <!-- 页面主视觉 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            页面主视觉
          </div>
          <div class="grid gap-5 p-6 md:grid-cols-[280px_1fr]">
            <ImageUploader
              :modelValue="content['groupbuy.hero'].img ? [content['groupbuy.hero'].img] : []"
              aspect="aspect-[16/10]"
              @update:modelValue="(v) => (content['groupbuy.hero'].img = v[0] || '')"
            />
            <div class="grid gap-3 sm:grid-cols-2">
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">眉题</span>
                <input v-model="content['groupbuy.hero'].eyebrow" class="field" />
              </label>
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">标题（换行用回车）</span>
                <textarea v-model="content['groupbuy.hero'].title" class="field" rows="2" />
              </label>
              <label class="sm:col-span-2">
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">副标题</span>
                <textarea v-model="content['groupbuy.hero'].sub" class="field" rows="2" />
              </label>
            </div>
          </div>
        </section>

        <!-- 定制场景 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            定制场景
          </div>
          <div class="p-6">
            <ListSection
              v-model="content['groupbuy.scenes']"
              image-key="img"
              :fields="[
                { key: 't', label: '场景名' },
                { key: 'd', label: '描述', type: 'textarea' },
              ]"
              :addTemplate="{ img: '', t: '', d: '' }"
              :titleOf="(it, i) => it.t || `第 ${i + 1} 项`"
              add-text="+ 添加一个场景"
            />
          </div>
        </section>

        <!-- 定制流程 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            定制流程
          </div>
          <div class="p-6">
            <StringListSection
              v-model="content['groupbuy.steps']"
              placeholder="流程步骤"
              add-text="+ 添加一个步骤"
            />
          </div>
        </section>

        <!-- 服务承诺 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            服务承诺
          </div>
          <div class="p-6">
            <StringListSection
              v-model="content['groupbuy.promises']"
              placeholder="服务承诺"
              add-text="+ 添加一项承诺"
            />
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
