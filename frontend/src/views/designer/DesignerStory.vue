<script setup>
import { ref, onMounted } from 'vue'
import { designerApi } from '@/api'
import { pickDefaults, mergeContent } from '@/utils/siteContent'
import ImageUploader from '@/components/ImageUploader.vue'
import ListSection from '@/components/ListSection.vue'
import DesignerLayout from '@/components/DesignerLayout.vue'

/** 品牌故事页设计：主视觉 / 时间线 / 三重匠心 / 六大材质 / 门店 / 统计 / 会员服务 */

const KEYS = [
  'story.hero', 'story.timeline', 'story.crafts', 'story.materials',
  'story.stores', 'story.stats', 'story.service',
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
  document.title = '页面设计 · 品牌故事'
  load()
})
</script>

<template>
  <DesignerLayout>
    <div class="max-w-4xl">
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div>
          <p class="eyebrow">Story Design</p>
          <h2 class="mt-3 font-display text-2xl tracking-[0.15em] text-ink">
            品牌故事页设计
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
        <!-- 品牌主视觉 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            品牌主视觉
          </div>
          <div class="grid gap-5 p-6 md:grid-cols-[280px_1fr]">
            <ImageUploader
              :modelValue="content['story.hero'].img ? [content['story.hero'].img] : []"
              aspect="aspect-[16/10]"
              @update:modelValue="(v) => (content['story.hero'].img = v[0] || '')"
            />
            <div class="grid gap-3 sm:grid-cols-2">
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">眉题</span>
                <input v-model="content['story.hero'].eyebrow" class="field" />
              </label>
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">标题（换行用回车）</span>
                <textarea v-model="content['story.hero'].title" class="field" rows="2" />
              </label>
              <label class="sm:col-span-2">
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">副标题</span>
                <textarea v-model="content['story.hero'].sub" class="field" rows="2" />
              </label>
            </div>
          </div>
        </section>

        <!-- 品牌时间线 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            品牌时间线
          </div>
          <div class="p-6">
            <ListSection
              v-model="content['story.timeline']"
              :fields="[
                { key: 'year', label: '年份' },
                { key: 'text', label: '事件描述', type: 'textarea' },
              ]"
              :addTemplate="{ year: '', text: '' }"
              :titleOf="(it, i) => it.year || `第 ${i + 1} 项`"
              add-text="+ 添加一个里程碑"
            />
          </div>
        </section>

        <!-- 三重匠心 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            三重匠心
          </div>
          <div class="p-6">
            <ListSection
              v-model="content['story.crafts']"
              image-key="img"
              :fields="[
                { key: 'n', label: '序号（壹/贰/叁）' },
                { key: 't', label: '标题' },
                { key: 'd', label: '描述', type: 'textarea' },
              ]"
              :addTemplate="{ img: '', n: '', t: '', d: '' }"
              :titleOf="(it, i) => it.t || `第 ${i + 1} 项`"
              add-text="+ 添加一项工艺"
            />
          </div>
        </section>

        <!-- 六大材质 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            六大材质
          </div>
          <div class="p-6">
            <ListSection
              v-model="content['story.materials']"
              image-key="img"
              :fields="[
                { key: 'name', label: '名称' },
                { key: 'en', label: '英文名' },
                { key: 'origin', label: '产地' },
                { key: 'desc', label: '描述', type: 'textarea' },
              ]"
              :addTemplate="{ img: '', name: '', en: '', origin: '', desc: '' }"
              :titleOf="(it, i) => it.name || `第 ${i + 1} 项`"
              add-text="+ 添加一种材质"
            />
          </div>
        </section>

        <!-- 线下门店 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            线下门店
          </div>
          <div class="p-6">
            <ListSection
              v-model="content['story.stores']"
              :fields="[
                { key: 'city', label: '城市' },
                { key: 'name', label: '门店名' },
                { key: 'addr', label: '地址', type: 'textarea' },
              ]"
              :addTemplate="{ city: '', name: '', addr: '' }"
              :titleOf="(it, i) => it.name || `第 ${i + 1} 项`"
              add-text="+ 添加一家门店"
            />
          </div>
        </section>

        <!-- 品牌统计 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            品牌统计（数字滚动）
          </div>
          <div class="p-6">
            <ListSection
              v-model="content['story.stats']"
              :fields="[
                { key: 'to', label: '数值', type: 'number' },
                { key: 'suffix', label: '后缀（+ / %）' },
                { key: 'label', label: '说明文字' },
              ]"
              :addTemplate="{ to: 0, suffix: '', label: '' }"
              :titleOf="(it, i) => it.label || `第 ${i + 1} 项`"
              add-text="+ 添加一项统计"
            />
          </div>
        </section>

        <!-- 会员服务 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            会员服务
          </div>
          <div class="p-6">
            <ListSection
              v-model="content['story.service']"
              :fields="[
                { key: 't', label: '服务名' },
                { key: 'd', label: '服务说明', type: 'textarea' },
              ]"
              :addTemplate="{ t: '', d: '' }"
              :titleOf="(it, i) => it.t || `第 ${i + 1} 项`"
              add-text="+ 添加一项服务"
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
