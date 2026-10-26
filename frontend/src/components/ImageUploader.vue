<script setup>
import { ref, computed } from 'vue'
import { designerApi } from '@/api'

/**
 * 通用图片上传组件：选择文件 → 上传接口 → 返回 URL 预览
 * modelValue 为 URL 数组（单图模式最多 1 张）；多图支持拖拽排序与删除
 */
const props = defineProps({
  modelValue: { type: Array, default: () => [] },
  multiple: { type: Boolean, default: false },
  max: { type: Number, default: 0 }, // 0 = 不限制
  aspect: { type: String, default: 'aspect-[4/3]' }, // 预览框宽高比
})

const emit = defineEmits(['update:modelValue'])

const uploading = ref(false)
const error = ref('')
const dragIndex = ref(-1)
const overIndex = ref(-1)
const inputRef = ref(null)

const images = computed(() => props.modelValue || [])

function pick() {
  error.value = ''
  inputRef.value?.click()
}

async function onFiles(e) {
  const files = Array.from(e.target.files || [])
  e.target.value = ''
  if (!files.length) return
  error.value = ''
  uploading.value = true
  try {
    const list = props.multiple ? files : [files[0]]
    const urls = []
    for (const f of list) {
      const res = await designerApi.upload(f)
      urls.push(res.url)
    }
    let next = props.multiple ? [...images.value, ...urls] : [urls[0]]
    if (props.max > 0) next = next.slice(0, props.max)
    emit('update:modelValue', next)
  } catch (err) {
    error.value = err.message || '上传失败'
  } finally {
    uploading.value = false
  }
}

function removeAt(i) {
  const next = [...images.value]
  next.splice(i, 1)
  emit('update:modelValue', next)
}

function onDragStart(i) {
  dragIndex.value = i
}
function onDragOver(i) {
  overIndex.value = i
}
function onDrop(i) {
  const from = dragIndex.value
  dragIndex.value = -1
  overIndex.value = -1
  if (from < 0 || from === i) return
  const next = [...images.value]
  const [moved] = next.splice(from, 1)
  next.splice(i, 0, moved)
  emit('update:modelValue', next)
}
function onDragEnd() {
  dragIndex.value = -1
  overIndex.value = -1
}
</script>

<template>
  <div>
    <div class="flex flex-wrap gap-3">
      <!-- 已上传图片 -->
      <div
        v-for="(url, i) in images"
        :key="url + '#' + i"
        class="group relative cursor-grab overflow-hidden border border-ink/15 bg-sand active:cursor-grabbing"
        :class="[aspect, dragIndex === i ? 'opacity-40' : '', overIndex === i && dragIndex !== -1 && dragIndex !== i ? 'ring-2 ring-gold-deep' : '']"
        draggable="true"
        @dragstart="onDragStart(i)"
        @dragover.prevent="onDragOver(i)"
        @drop.prevent="onDrop(i)"
        @dragend="onDragEnd"
      >
        <img :src="url" alt="" class="h-full w-full object-cover" />
        <button
          type="button"
          aria-label="删除图片"
          class="absolute right-1 top-1 flex h-6 w-6 cursor-pointer items-center justify-center bg-ink/70 text-[14px] text-ivory opacity-0 transition-opacity group-hover:opacity-100"
          @click.stop="removeAt(i)"
        >
          ✕
        </button>
        <span
          v-if="images.length > 1 && i === 0"
          class="absolute bottom-0 left-0 bg-ink/70 px-1.5 py-0.5 text-[13px] tracking-[0.15em] text-ivory"
        >
          主图
        </span>
      </div>

      <!-- 上传入口 -->
      <button
        type="button"
        class="flex cursor-pointer flex-col items-center justify-center gap-1.5 border border-dashed border-ink/25 bg-transparent text-ink/75 transition-colors hover:border-gold-deep hover:text-gold-deep"
        :class="aspect"
        :disabled="uploading"
        @click="pick"
      >
        <span class="text-xl leading-none">{{ uploading ? '…' : '+' }}</span>
        <span class="text-[13px] tracking-[0.2em]">
          {{ uploading ? '上传中' : multiple ? '点击上传' : (images.length ? '替换图片' : '上传图片') }}
        </span>
      </button>
    </div>

    <p v-if="error" class="mt-2 text-[14px] text-red-700">{{ error }}</p>
    <p v-if="multiple && images.length > 1" class="mt-2 text-[13px] tracking-[0.15em] text-ink/75">
      拖拽图片可调整顺序，第一张为商品主图
    </p>

    <input
      ref="inputRef"
      type="file"
      class="hidden"
      accept="image/jpeg,image/png,image/webp,image/gif"
      :multiple="multiple"
      @change="onFiles"
    />
  </div>
</template>
