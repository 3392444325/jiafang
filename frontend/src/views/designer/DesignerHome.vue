<script setup>
import { ref, onMounted } from 'vue'
import { designerApi } from '@/api'
import ImageUploader from '@/components/ImageUploader.vue'
import DesignerLayout from '@/components/DesignerLayout.vue'

/**
 * 首页设计：轮播图、品牌宣言、大师联名区、商城头图、新闻页头图
 * 内容存于 site_content 表，前台页面读取配置渲染（无配置时使用默认值）
 */

const DEFAULT_CONTENT = {
  'home.hero': {
    slides: [
      {
        src: '/images/heroes/hero-1.jpg',
        eyebrow: 'ST.KELLY · Since 1988',
        title: '以东方织造，\n致一世安眠',
        sub: '三十八年，三代织人，一件事：把「睡个好觉」，做成值得传家的东西。',
        href: '/story',
        cta: '走进品牌',
      },
      {
        src: '/images/heroes/hero-2.jpg',
        eyebrow: 'Craftsmanship · 匠心',
        title: '不赶时间，只赶手艺',
        sub: '绒朵、长丝与贡缎——95% 的预算花在看不见的地方。27 项原材检测，43 道出厂工序。',
        href: '/story',
        cta: '了解匠心',
      },
      {
        src: '/images/heroes/hero-3.jpg',
        eyebrow: 'Master Collaboration · 大师联名',
        title: '当莫奈的睡莲，\n开在枕畔',
        sub: '与前GUCCI印花设计总监联名，十六色渐变直喷——艺术家纺，自此有了模样。',
        href: '/shop',
        cta: '走进官方商城',
      },
    ],
  },
  'home.philosophy': {
    eyebrow: 'Philosophy',
    title: 'ST.KELLY，织的是时间',
    desc: '从一颗茧、一束绒到一寸缎，ST.KELLY坚持最古老的方式：不赶时间，只赶手艺。我们把「睡个好觉」这件事，做成了值得传家的东西。',
  },
  'home.collab': {
    image: '',
    title: '当莫奈的睡莲，\n开在枕畔。',
    desc: '与前 GUCCI 印花设计总监联手的艺术家纺系列——十六色渐变直喷工艺，将《睡莲》的光影移植到 100 支贡缎之上。',
  },
  'shop.hero': {
    img: '/images/heroes/hero-2.jpg',
    eyebrow: 'ST.KELLY Official Store',
    title: '秋季焕新 · 官方商城',
    sub: '全场满 ¥1,299 减 ¥150 · 顺丰包邮 · 30 天无忧退换\n新会员注册即赠 ¥100 礼遇',
  },
}

const content = ref(structuredClone(DEFAULT_CONTENT))
const loading = ref(true)
const saving = ref(false)
const savedTip = ref('')
const error = ref('')

/** 将接口返回的配置合并到默认结构上（对象浅合并，数组整体替换；slides 元素补齐默认字段） */
function mergeOverDefaults(incoming) {
  const result = structuredClone(DEFAULT_CONTENT)
  if (!incoming) return result
  for (const key of Object.keys(result)) {
    const v = incoming[key]
    if (v == null) continue
    if (Array.isArray(v)) {
      result[key] = v
    } else if (typeof v === 'object') {
      result[key] = { ...result[key], ...v }
    }
  }
  // 旧数据可能缺少后续新增的字段，补齐默认值避免 v-model 绑定 undefined
  const slideDefaults = { src: '', eyebrow: '', title: '', sub: '', href: '', cta: '' }
  result['home.hero'].slides = (result['home.hero'].slides || []).map((s) => ({
    ...slideDefaults,
    ...s,
  }))
  return result
}

const slides = () => content.value['home.hero'].slides

function addSlide() {
  content.value['home.hero'].slides.push({
    src: '',
    eyebrow: '',
    title: '',
    sub: '',
    href: '/',
    cta: '查看更多',
  })
}
function removeSlide(i) {
  content.value['home.hero'].slides.splice(i, 1)
}
function moveSlide(i, dir) {
  const arr = content.value['home.hero'].slides
  const j = i + dir
  if (j < 0 || j >= arr.length) return
  const [m] = arr.splice(i, 1)
  arr.splice(j, 0, m)
}

async function load() {
  loading.value = true
  error.value = ''
  try {
    const data = await designerApi.content()
    content.value = mergeOverDefaults(data)
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
  document.title = '页面设计'
  load()
})
</script>

<template>
  <DesignerLayout>
    <div class="max-w-4xl">
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div>
          <p class="eyebrow">Page Design</p>
          <h2 class="mt-3 font-display text-2xl tracking-[0.15em] text-ink">
            首页与版块设计
          </h2>
          <p class="mt-2 text-[14px] text-ink/75">
            替换图片、编辑文案后点击「保存全部」，前台立即生效。
          </p>
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
        <!-- 首页轮播图 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="flex items-center justify-between border-b border-ink/10 px-6 py-4">
            <span class="text-[14px] tracking-[0.25em] text-ink/80">首页轮播图（{{ slides().length }} 张）</span>
            <button
              class="cursor-pointer border border-ink/20 px-4 py-1.5 text-[14px] tracking-[0.2em] text-ink/80 transition-colors hover:border-gold-deep hover:text-gold-deep"
              @click="addSlide"
            >
              + 添加一张
            </button>
          </div>
          <div class="divide-y divide-ink/10">
            <div
              v-for="(s, i) in content['home.hero'].slides"
              :key="i"
              class="grid gap-5 p-6 md:grid-cols-[280px_1fr]"
            >
              <ImageUploader
                :modelValue="s.src ? [s.src] : []"
                :aspect="'aspect-[16/10]'"
                @update:modelValue="(v) => (s.src = v[0] || '')"
              />
              <div class="grid gap-3">
                <div class="flex items-center justify-between">
                  <span class="text-[14px] tracking-[0.25em] text-ink/75">第 {{ i + 1 }} 张</span>
                  <div class="flex items-center gap-2">
                    <button
                      type="button"
                      class="cursor-pointer border border-ink/20 px-2.5 py-1 text-[14px] text-ink/75 transition-colors hover:border-gold-deep hover:text-gold-deep disabled:opacity-30"
                      :disabled="i === 0"
                      @click="moveSlide(i, -1)"
                    >
                      ↑ 上移
                    </button>
                    <button
                      type="button"
                      class="cursor-pointer border border-ink/20 px-2.5 py-1 text-[14px] text-ink/75 transition-colors hover:border-gold-deep hover:text-gold-deep disabled:opacity-30"
                      :disabled="i === content['home.hero'].slides.length - 1"
                      @click="moveSlide(i, 1)"
                    >
                      ↓ 下移
                    </button>
                    <button
                      type="button"
                      class="cursor-pointer border border-ink/20 px-2.5 py-1 text-[14px] text-ink/75 transition-colors hover:border-red-700 hover:text-red-700"
                      @click="removeSlide(i)"
                    >
                      删除
                    </button>
                  </div>
                </div>
                <div class="grid gap-3 sm:grid-cols-2">
                  <label>
                    <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">眉题（英文小字）</span>
                    <input v-model="s.eyebrow" class="field" />
                  </label>
                  <label>
                    <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">跳转链接</span>
                    <input v-model="s.href" class="field" placeholder="/story" />
                  </label>
                  <label class="sm:col-span-2">
                    <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">主标题（换行请用回车）</span>
                    <textarea v-model="s.title" class="field" rows="2" />
                  </label>
                  <label class="sm:col-span-2">
                    <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">副标题</span>
                    <textarea v-model="s.sub" class="field" rows="2" />
                  </label>
                  <label>
                    <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">按钮文字</span>
                    <input v-model="s.cta" class="field" />
                  </label>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- 品牌宣言 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            品牌宣言区（首页深色段）
          </div>
          <div class="grid gap-3 p-6 sm:grid-cols-2">
            <label>
              <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">眉题</span>
              <input v-model="content['home.philosophy'].eyebrow" class="field" />
            </label>
            <label>
              <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">标题</span>
              <input v-model="content['home.philosophy'].title" class="field" />
            </label>
            <label class="sm:col-span-2">
              <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">描述文字</span>
              <textarea v-model="content['home.philosophy'].desc" class="field" rows="3" />
            </label>
          </div>
        </section>

        <!-- 大师联名区 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            大师联名区（图片留空则使用联名商品图）
            <p class="mt-1.5 text-[14px] leading-relaxed tracking-normal text-ink/75">
              注：只要配置了图片，此版块就会在首页展示；未上架联名商品时不显示联名价与商品链接。
            </p>
          </div>
          <div class="grid gap-5 p-6 md:grid-cols-[280px_1fr]">
            <ImageUploader
              :modelValue="content['home.collab'].image ? [content['home.collab'].image] : []"
              :aspect="'aspect-[4/5]'"
              @update:modelValue="(v) => (content['home.collab'].image = v[0] || '')"
            />
            <div class="grid gap-3">
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">标题</span>
                <textarea v-model="content['home.collab'].title" class="field" rows="2" />
              </label>
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">描述文字</span>
                <textarea v-model="content['home.collab'].desc" class="field" rows="4" />
              </label>
            </div>
          </div>
        </section>

        <!-- 商城头图 -->
        <section class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            商城页头图
          </div>
          <div class="grid gap-5 p-6 md:grid-cols-[280px_1fr]">
            <ImageUploader
              :modelValue="content['shop.hero'].img ? [content['shop.hero'].img] : []"
              :aspect="'aspect-[16/10]'"
              @update:modelValue="(v) => (content['shop.hero'].img = v[0] || '')"
            />
            <div class="grid gap-3 sm:grid-cols-2">
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">眉题</span>
                <input v-model="content['shop.hero'].eyebrow" class="field" />
              </label>
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">标题</span>
                <input v-model="content['shop.hero'].title" class="field" />
              </label>
              <label class="sm:col-span-2">
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">副标题</span>
                <textarea v-model="content['shop.hero'].sub" class="field" rows="2" />
              </label>
            </div>
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
