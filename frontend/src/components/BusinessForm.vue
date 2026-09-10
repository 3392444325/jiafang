<script setup>
import { ref } from 'vue'
import { leadApi } from '@/api'

const props = defineProps({
  tag: { type: String, required: true },
  title: { type: String, required: true },
  desc: { type: String, default: '' },
  type: { type: String, required: true },
})

const done = ref(false)
const busy = ref(false)
const form = ref({ name: '', phone: '', note: '' })
const error = ref('')

async function submit() {
  if (!form.value.name.trim() || !/^1\d{10}$/.test(form.value.phone.trim())) {
    error.value = '请填写姓名与 11 位手机号码'
    return
  }
  busy.value = true
  error.value = ''
  try {
    await leadApi.submit({ ...form.value, type: props.type })
    done.value = true
  } catch (e) {
    error.value = e.message || '提交失败，请重试'
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <div v-if="done" class="border border-gold/40 bg-gold/10 px-8 py-14 text-center">
    <p class="font-display text-2xl tracking-[0.2em] text-gold-deep">
      提交成功
    </p>
    <p class="mt-4 text-sm leading-loose text-ink/60">
      感谢你的信任，织云{{ tag }}顾问将在 1 个工作日内与你联系。
    </p>
  </div>

  <div v-else class="border border-ink/10 bg-ivory p-8 md:p-10">
    <p class="eyebrow">{{ tag }} Inquiry</p>
    <h3 class="mt-3 font-display text-2xl tracking-[0.15em] text-ink">
      {{ title }}
    </h3>
    <p v-if="desc" class="mt-3 text-sm leading-loose text-ink/55">{{ desc }}</p>
    <form @submit.prevent="submit" class="mt-7 space-y-4">
      <input
        v-model="form.name"
        class="field"
        placeholder="你的称呼"
        required
      />
      <input
        v-model="form.phone"
        class="field"
        placeholder="联系电话（11 位手机号）"
        required
      />
      <textarea
        v-model="form.note"
        class="field"
        rows="3"
        placeholder="意向说明（城市 / 规模 / 预算，选填）"
      />
      <p v-if="error" class="text-xs tracking-[0.15em] text-red-700">{{ error }}</p>
      <button type="submit" :disabled="busy" class="btn-primary w-full disabled:opacity-50">
        {{ busy ? '提交中…' : '提交意向' }}
      </button>
      <p class="text-[11px] leading-relaxed tracking-[0.12em] text-ink/40">
        提交即视为同意织云与你联系，招商顾问将在 1 个工作日内致电。
      </p>
    </form>
  </div>
</template>
