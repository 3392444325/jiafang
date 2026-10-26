<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCartStore } from '@/stores/cart'
import { addressApi, orderApi } from '@/api'
import { yuan } from '@/utils/format'

const router = useRouter()
const cart = useCartStore()

const addresses = ref([])
const useSaved = ref(null)
const form = ref({
  name: '',
  phone: '',
  province: '',
  city: '',
  district: '',
  detail: '',
})
const saveAddress = ref(false)
const error = ref('')
const busy = ref(false)

function pickSaved(i) {
  useSaved.value = i
  const a = addresses.value[i]
  form.value = {
    name: a.name,
    phone: a.phone,
    province: a.province,
    city: a.city,
    district: a.district ?? '',
    detail: a.detail,
  }
}

onMounted(async () => {
  await cart.fetchItems()
  try {
    const res = await addressApi.list()
    addresses.value = res.addresses || []
    if (addresses.value.length > 0) {
      pickSaved(0)
      saveAddress.value = false
    } else {
      useSaved.value = null
      saveAddress.value = true
    }
  } catch {
    addresses.value = []
    useSaved.value = null
    saveAddress.value = true
  }
})

async function submit() {
  busy.value = true
  error.value = ''
  try {
    const data = await orderApi.create({ ...form.value, saveAddress: saveAddress.value })
    if (data && data.id) {
      router.push(`/orders/${data.id}/pay`)
    } else {
      error.value = (data && data.error) || '创建订单失败，请重试'
    }
  } catch (e) {
    error.value = e.message || '网络异常，请重试'
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <div class="grid gap-14 lg:grid-cols-5">
    <!-- 收货信息 -->
    <form @submit.prevent="submit" class="space-y-6 lg:col-span-3">
      <div v-if="addresses.length > 0">
        <p class="text-[14px] tracking-[0.25em] text-ink/80">地址簿</p>
        <div class="mt-3 grid gap-3 sm:grid-cols-2">
          <button
            type="button"
            v-for="(a, i) in addresses"
            :key="a.id"
            @click="pickSaved(i)"
            :class="[
              'cursor-pointer border p-4 text-left text-[14px] leading-relaxed transition-colors',
              useSaved === i ? 'border-gold-deep bg-ivory' : 'border-ink/15 bg-transparent hover:border-ink/40',
            ]"
          >
            <span class="tracking-[0.15em] text-ink">
              {{ a.name }} · {{ a.phone }}
            </span>
            <span v-if="a.isDefault" class="ml-2 text-[13px] text-gold-deep">默认</span>
            <br />
            <span class="text-ink/80">
              {{ a.province }} {{ a.city }} {{ a.district ?? '' }} {{ a.detail }}
            </span>
          </button>
          <button
            type="button"
            @click="useSaved = null"
            :class="[
              'cursor-pointer border p-4 text-left text-[14px] tracking-[0.2em] transition-colors',
              useSaved === null ? 'border-gold-deep bg-ivory' : 'border-ink/15 hover:border-ink/40',
            ]"
          >
            + 使用新地址
          </button>
        </div>
      </div>

      <div class="grid gap-4 sm:grid-cols-2">
        <input v-model="form.name" class="field" placeholder="收货人姓名" required />
        <input v-model="form.phone" class="field" placeholder="手机号码" required />
        <input v-model="form.province" class="field" placeholder="省份" required />
        <input v-model="form.city" class="field" placeholder="城市" required />
        <input v-model="form.district" class="field" placeholder="区 / 县（可选）" />
        <input v-model="form.detail" class="field" placeholder="详细地址（街道、楼栋、门牌号）" required />
      </div>

      <label class="flex cursor-pointer items-center gap-3 text-[14px] tracking-[0.15em] text-ink/75">
        <input v-model="saveAddress" type="checkbox" class="accent-[#8F7A50]" />
        保存到地址簿，下次结算自动填入
      </label>

      <p v-if="error" class="text-[14px] tracking-[0.15em] text-red-700">{{ error }}</p>

      <button type="submit" :disabled="busy" class="btn-primary w-full disabled:opacity-50">
        {{ busy ? '正在创建订单…' : '提交订单' }}
      </button>
      <p class="text-[14px] leading-relaxed tracking-[0.12em] text-ink/75">
        提交订单后将进入支付环节。本站为演示项目，采用「模拟支付」完成闭环；
        接入微信支付 / 支付宝需企业商户资质，接口位已预留。
      </p>
    </form>

    <!-- 订单摘要 -->
    <aside class="h-fit border border-ink/10 bg-ivory p-8 lg:sticky lg:top-28 lg:col-span-2">
      <p class="text-[14px] uppercase tracking-[0.3em] text-gold-deep">
        Order Summary
      </p>
      <div class="mt-6 space-y-4">
        <div v-for="(it, i) in cart.items" :key="i" class="flex items-center gap-4">
          <img :src="it.image" :alt="it.name" class="h-16 w-14 object-cover" />
          <div class="flex-1 text-[14px] leading-relaxed">
            <p class="tracking-[0.1em] text-ink">{{ it.name }}</p>
            <p class="mt-1 text-ink/75">× {{ it.qty }}</p>
          </div>
          <p class="text-[15px] text-gold-deep">{{ yuan(it.priceFen * it.qty) }}</p>
        </div>
      </div>
      <div class="mt-7 border-t border-ink/10 pt-5 text-[15px]">
        <div class="flex justify-between text-ink/80">
          <span>商品小计</span>
          <span>{{ yuan(cart.totalFen) }}</span>
        </div>
        <div class="mt-2 flex justify-between text-ink/80">
          <span>运费</span>
          <span>顺丰包邮</span>
        </div>
        <div class="mt-5 flex items-baseline justify-between border-t border-ink/10 pt-5">
          <span class="tracking-[0.2em] text-ink">应付合计</span>
          <span class="font-display text-2xl text-gold-deep">
            {{ yuan(cart.totalFen) }}
          </span>
        </div>
      </div>
    </aside>
  </div>
</template>
