<script setup>
import { ref, onMounted, computed } from 'vue'
import { addressApi } from '@/api'

const EMPTY = {
  name: '',
  phone: '',
  province: '',
  city: '',
  district: '',
  detail: '',
}

const addresses = ref([])
const adding = ref(false)
const editingId = ref(null)
const form = ref({ ...EMPTY })
const isDefault = ref(false)
const busy = ref(false)
const error = ref('')

const formOpen = computed(() => adding.value || editingId.value !== null)

async function load() {
  try {
    const res = await addressApi.list()
    addresses.value = res.addresses || []
    if (addresses.value.length === 0 && !editingId.value && !adding.value) {
      adding.value = true
    }
  } catch {
    addresses.value = []
  }
}

onMounted(load)

function startAdd() {
  editingId.value = null
  form.value = { ...EMPTY }
  isDefault.value = false
  adding.value = true
  error.value = ''
}

function startEdit(a) {
  adding.value = false
  editingId.value = a.id
  form.value = {
    name: a.name,
    phone: a.phone,
    province: a.province,
    city: a.city,
    district: a.district ?? '',
    detail: a.detail,
  }
  error.value = ''
}

async function save() {
  busy.value = true
  error.value = ''
  try {
    const editing = editingId.value !== null
    if (editing) {
      await addressApi.update(editingId.value, { ...form.value })
    } else {
      await addressApi.create({ ...form.value, isDefault: isDefault.value })
    }
    adding.value = false
    editingId.value = null
    await load()
  } catch (e) {
    error.value = e.message || '保存失败，请重试'
  } finally {
    busy.value = false
  }
}

function cancel() {
  adding.value = false
  editingId.value = null
}

async function remove(id) {
  if (!window.confirm('确定删除该地址？')) return
  await addressApi.delete(id)
  await load()
}

async function setDefault(id) {
  await addressApi.setDefault(id)
  await load()
}
</script>

<template>
  <div class="space-y-5">
    <div
      v-for="a in addresses"
      :key="a.id"
      class="flex flex-wrap items-center justify-between gap-4 border border-ink/10 bg-ivory px-6 py-5 text-[15px]"
    >
      <div class="min-w-64 flex-1">
        <p class="tracking-[0.15em] text-ink">
          {{ a.name }} · {{ a.phone }}
          <span
            v-if="a.isDefault"
            class="ml-3 border border-gold/40 bg-gold/10 px-2 py-0.5 text-[13px] tracking-[0.2em] text-gold-deep"
          >
            默认
          </span>
        </p>
        <p class="mt-1 text-[14px] leading-relaxed text-ink/80">
          {{ a.province }} {{ a.city }} {{ a.district ?? '' }} {{ a.detail }}
        </p>
      </div>
      <div class="flex items-center gap-4 text-[14px] tracking-[0.2em]">
        <button
          v-if="!a.isDefault"
          @click="setDefault(a.id)"
          class="cursor-pointer text-ink/80 transition-colors hover:text-gold-deep"
        >
          设为默认
        </button>
        <button
          @click="startEdit(a)"
          class="cursor-pointer text-ink/80 transition-colors hover:text-gold-deep"
        >
          编辑
        </button>
        <button
          @click="remove(a.id)"
          class="cursor-pointer text-ink/80 transition-colors hover:text-red-700"
        >
          删除
        </button>
      </div>
    </div>

    <button v-if="!formOpen" @click="startAdd" class="btn-ghost">
      + 新增收货地址
    </button>

    <form
      v-if="formOpen"
      @submit.prevent="save"
      class="grid gap-4 border border-ink/10 bg-ivory p-6 sm:grid-cols-2"
    >
      <p class="text-[14px] tracking-[0.25em] text-ink/80 sm:col-span-2">
        {{ editingId ? '编辑地址' : '新增地址' }}
      </p>
      <input v-model="form.name" class="field" placeholder="收货人姓名" required />
      <input v-model="form.phone" class="field" placeholder="手机号码" required />
      <input v-model="form.province" class="field" placeholder="省份" required />
      <input v-model="form.city" class="field" placeholder="城市" required />
      <input v-model="form.district" class="field" placeholder="区 / 县（可选）" />
      <input
        v-model="form.detail"
        class="field"
        placeholder="详细地址（街道、楼栋、门牌号）"
        required
      />
      <label
        v-if="editingId === null"
        class="flex cursor-pointer items-center gap-3 text-[14px] tracking-[0.15em] text-ink/75 sm:col-span-2"
      >
        <input v-model="isDefault" type="checkbox" class="accent-[#8F7A50]" />
        设为默认地址
      </label>
      <p v-if="error" class="text-[14px] tracking-[0.15em] text-red-700 sm:col-span-2">
        {{ error }}
      </p>
      <div class="flex items-center gap-4 sm:col-span-2">
        <button type="submit" :disabled="busy" class="btn-primary disabled:opacity-50">
          {{ busy ? '保存中…' : '保存地址' }}
        </button>
        <button
          type="button"
          @click="cancel"
          class="cursor-pointer text-[14px] tracking-[0.2em] text-ink/80 hover:text-ink"
        >
          取消
        </button>
      </div>
    </form>
  </div>
</template>
