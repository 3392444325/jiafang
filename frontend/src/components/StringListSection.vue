<script setup>
/** 字符串数组编辑器：每行一个输入框，支持增删与上下移动（加盟条件、流程、伙伴墙等） */
const props = defineProps({
  modelValue: { type: Array, default: () => [] },
  placeholder: { type: String, default: '' },
  addText: { type: String, default: '+ 添加一项' },
})

const emit = defineEmits(['update:modelValue'])

const items = () => props.modelValue || []

function setAt(i, val) {
  emit('update:modelValue', items().map((it, idx) => (idx === i ? val : it)))
}
function remove(i) {
  const next = [...items()]
  next.splice(i, 1)
  emit('update:modelValue', next)
}
function move(i, dir) {
  const j = i + dir
  const next = [...items()]
  if (j < 0 || j >= next.length) return
  const [m] = next.splice(i, 1)
  next.splice(j, 0, m)
  emit('update:modelValue', next)
}
function add() {
  emit('update:modelValue', [...items(), ''])
}
</script>

<template>
  <div class="space-y-2">
    <div
      v-for="(item, i) in items()"
      :key="i"
      class="flex items-center gap-2"
    >
      <span class="w-6 shrink-0 text-center text-[14px] text-ink/75">{{ i + 1 }}</span>
      <input class="field" :placeholder="placeholder" :value="item" @input="setAt(i, $event.target.value)" />
      <button
        type="button"
        class="shrink-0 cursor-pointer border border-ink/20 px-2 py-1.5 text-[14px] text-ink/75 transition-colors hover:border-gold-deep hover:text-gold-deep disabled:opacity-30"
        :disabled="i === 0"
        @click="move(i, -1)"
      >
        ↑
      </button>
      <button
        type="button"
        class="shrink-0 cursor-pointer border border-ink/20 px-2 py-1.5 text-[14px] text-ink/75 transition-colors hover:border-gold-deep hover:text-gold-deep disabled:opacity-30"
        :disabled="i === items().length - 1"
        @click="move(i, 1)"
      >
        ↓
      </button>
      <button
        type="button"
        class="shrink-0 cursor-pointer border border-ink/20 px-2 py-1.5 text-[14px] text-ink/75 transition-colors hover:border-red-700 hover:text-red-700"
        @click="remove(i)"
      >
        删除
      </button>
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
