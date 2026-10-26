<script setup>
import { ref, onMounted } from 'vue'
import { designerApi } from '@/api'
import { pickDefaults, mergeContent } from '@/utils/siteContent'
import DesignerLayout from '@/components/DesignerLayout.vue'

/** 全站联系方式：hotline / hours / 加盟、团购、合作、招聘等邮箱电话（前台多页面共用） */

const KEYS = ['global.contact']

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
  document.title = '页面设计 · 联系方式'
  load()
})
</script>

<template>
  <DesignerLayout>
    <div class="max-w-4xl">
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div>
          <p class="eyebrow">Global Contact</p>
          <h2 class="mt-3 font-display text-2xl tracking-[0.15em] text-ink">
            全站联系方式
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
        <!-- 全站联系方式 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            全站联系方式
            <p class="mt-1.5 text-[14px] leading-relaxed tracking-normal text-ink/75">
              以下联系方式在前台多个页面共用，修改后点击「保存全部」即可全站生效。
            </p>
          </div>
          <div class="grid gap-4 p-6 sm:grid-cols-2">
            <label>
              <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">服务热线</span>
              <input v-model="content['global.contact'].hotline" class="field" />
            </label>
            <label>
              <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">服务时间</span>
              <input v-model="content['global.contact'].hours" class="field" />
            </label>
            <label>
              <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">加盟邮箱</span>
              <input v-model="content['global.contact'].franchiseEmail" class="field" />
            </label>
            <label>
              <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">团购电话</span>
              <input v-model="content['global.contact'].groupPhone" class="field" />
            </label>
            <label>
              <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">团购邮箱</span>
              <input v-model="content['global.contact'].groupEmail" class="field" />
            </label>
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
