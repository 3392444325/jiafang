<script setup>
import ImageUploader from '@/components/ImageUploader.vue'

/**
 * 对象数组编辑器：每项支持 图片位（可选）+ 字段表单 + 增删 + 上移下移
 * v-model 为对象数组；fields 描述每个字段的表单：{ key, label, type: 'text'|'textarea'|'number', placeholder }
 * 传 imageKey 时为每一项渲染单图上传位，值写入该字段
 */
const props = defineProps({
  modelValue: { type: Array, default: () => [] },
  fields: { type: Array, default: () => [] },
  imageKey: { type: String, default: '' },
  addTemplate: { type: Object, default: () => ({}) },
  aspect: { type: String, default: 'aspect-[4/3]' },
  titleOf: { type: Function, default: null },
  addText: { type: String, default: '+ 添加一项' },
})

const emit = defineEmits(['update:modelValue'])

const items = () => props.modelValue || []

function emitItems(next) {
  emit('update:modelValue', next)
}
function setField(i, key, val) {
  emitItems(items().map((it, idx) => (idx === i ? { ...it, [key]: val } : it)))
}
function remove(i) {
  const next = [...items()]
  next.splice(i, 1)
  emitItems(next)
}
function move(i, dir) {
  const j = i + dir
  const next = [...items()]
  if (j < 0 || j >= next.length) return
  const [m] = next.splice(i, 1)
  next.splice(j, 0, m)
  emitItems(next)
}
function add() {
  emitItems([...items(), structuredClone(props.addTemplate)])
}
function onInput(i, f, e) {
  const raw = e.target.value
  setField(i, f.key, f.type === 'number' ? (Number(raw) || 0) : raw)
}
function labelOf(item, i) {
  return props.titleOf ? props.titleOf(item, i) : `第 ${i + 1} 项`
}
</script>

<template>
  <div class="space-y-4">
    <div
      v-for="(item, i) in items()"
      :key="i"
      class="border border-ink/10 bg-linen p-5"
    >
      <div class="flex items-center justify-between">
        <span class="text-[14px] tracking-[0.25em] text-ink/75">{{ labelOf(item, i) }}</span>
        <div class="flex items-center gap-2">
          <button
            type="button"
            class="cursor-pointer border border-ink/20 px-2.5 py-1 text-[14px] text-ink/75 transition-colors hover:border-gold-deep hover:text-gold-deep disabled:opacity-30"
            :disabled="i === 0"
            @click="move(i, -1)"
          >
            ↑
          </button>
          <button
            type="button"
            class="cursor-pointer border border-ink/20 px-2.5 py-1 text-[14px] text-ink/75 transition-colors hover:border-gold-deep hover:text-gold-deep disabled:opacity-30"
            :disabled="i === items().length - 1"
            @click="move(i, 1)"
          >
            ↓
          </button>
          <button
            type="button"
            class="cursor-pointer border border-ink/20 px-2.5 py-1 text-[14px] text-ink/75 transition-colors hover:border-red-700 hover:text-red-700"
            @click="remove(i)"
          >
            删除
          </button>
        </div>
      </div>

      <div :class="imageKey ? 'mt-4 grid gap-4 md:grid-cols-[220px_1fr]' : 'mt-4'">
        <ImageUploader
          v-if="imageKey"
          :modelValue="item[imageKey] ? [item[imageKey]] : []"
          :aspect="aspect"
          @update:modelValue="(v) => setField(i, imageKey, v[0] || '')"
        />
        <div class="grid gap-3 sm:grid-cols-2">
          <label
            v-for="f in fields"
            :key="f.key"
            :class="f.type === 'textarea' ? 'sm:col-span-2' : ''"
          >
            <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">{{ f.label }}</span>
            <textarea
              v-if="f.type === 'textarea'"
              class="field"
              rows="3"
              :placeholder="f.placeholder || ''"
              :value="item[f.key]"
              @input="onInput(i, f, $event)"
            />
            <input
              v-else
              class="field"
              :type="f.type === 'number' ? 'number' : 'text'"
              :placeholder="f.placeholder || ''"
              :value="item[f.key]"
              @input="onInput(i, f, $event)"
            />
          </label>
        </div>
      </div>
    </div>

    <button
      type="button"
      class="cursor-pointer border border-ink/20 px-4 py-2 text-[14px] tracking-[0.2em] text-ink/80 transition-colors hover:border-gold-deep hover:text-gold-deep"
      @click="add"
    >
      {{ addText }}
    </button>
  </div>
</template>
