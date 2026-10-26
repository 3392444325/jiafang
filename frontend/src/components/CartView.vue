<script setup>
import { ref, onMounted } from 'vue'
import { useCartStore } from '@/stores/cart'
import { yuan } from '@/utils/format'

const cart = useCartStore()
const busyId = ref(null)

onMounted(() => {
  cart.fetchItems()
})

async function setQty(id, qty) {
  busyId.value = id
  try {
    await cart.update(id, qty)
  } finally {
    busyId.value = null
  }
}

async function remove(id) {
  busyId.value = id
  try {
    await cart.remove(id)
  } finally {
    busyId.value = null
  }
}
</script>

<template>
  <div v-if="cart.items.length === 0" class="py-24 text-center">
    <p class="font-display text-2xl tracking-[0.2em] text-ink/75">
      你的购物车还空着
    </p>
    <p class="mt-4 text-[15px] tracking-[0.2em] text-ink/75">
      去挑选一床好梦吧。
    </p>
    <router-link to="/products" class="btn-primary mt-10">
      去逛逛
    </router-link>
  </div>

  <div v-else>
    <div class="mt-10">
      <div
        v-for="it in cart.items"
        :key="it.id"
        :class="[
          'flex flex-wrap items-center gap-5 border-b border-ink/10 py-6 transition-opacity sm:gap-6',
          busyId === it.id ? 'opacity-40' : '',
        ]"
      >
        <router-link :to="`/products/${it.slug}`" class="shrink-0">
          <img
            :src="it.image"
            :alt="it.name"
            class="h-28 w-24 object-cover"
          />
        </router-link>
        <div class="min-w-40 flex-1">
          <router-link
            :to="`/products/${it.slug}`"
            class="font-display text-lg tracking-wide text-ink transition-colors hover:text-gold-deep"
          >
            {{ it.name }}
          </router-link>
          <p class="mt-1.5 text-[14px] tracking-[0.15em] text-ink/75">
            {{ yuan(it.priceFen) }} / 件
          </p>
        </div>
        <div class="flex items-center border border-ink/20">
          <button
            @click="setQty(it.id, it.qty - 1)"
            :disabled="it.qty <= 1"
            class="cursor-pointer px-3.5 py-2 text-ink/75 transition-colors hover:text-gold-deep disabled:opacity-30"
            aria-label="减少数量"
          >
            −
          </button>
          <span class="min-w-10 text-center text-[15px]">{{ it.qty }}</span>
          <button
            @click="setQty(it.id, Math.min(it.stock, it.qty + 1))"
            :disabled="it.qty >= it.stock"
            class="cursor-pointer px-3.5 py-2 text-ink/75 transition-colors hover:text-gold-deep disabled:opacity-30"
            aria-label="增加数量"
          >
            +
          </button>
        </div>
        <p class="w-28 text-right font-display text-lg text-gold-deep">
          {{ yuan(it.priceFen * it.qty) }}
        </p>
        <button
          @click="remove(it.id)"
          aria-label="移除"
          class="cursor-pointer px-1 text-ink/70 transition-colors hover:text-red-700"
        >
          ✕
        </button>
      </div>
    </div>

    <div class="flex flex-col items-end gap-6 pt-10">
      <div class="text-right">
        <p class="text-[14px] tracking-[0.25em] text-ink/75">
          共 {{ cart.items.length }} 件商品 · 运费：顺丰包邮
        </p>
        <p class="mt-3 text-[15px] tracking-[0.2em] text-ink/75">合计</p>
        <p class="font-display text-4xl text-gold-deep">{{ yuan(cart.totalFen) }}</p>
      </div>
      <div class="flex w-full flex-col gap-3 sm:w-auto sm:flex-row">
        <router-link to="/products" class="btn-ghost">
          继续选购
        </router-link>
        <router-link to="/checkout" class="btn-primary">
          去结算
        </router-link>
      </div>
      <p class="text-[14px] tracking-[0.15em] text-ink/75">
        结算前请先登录ST.KELLY账户 · 游客购物车将在登录后自动合并
      </p>
    </div>
  </div>
</template>
