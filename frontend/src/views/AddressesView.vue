<script setup>
import AddressManager from '@/components/AddressManager.vue'
</script>

<template>
  <div class="pt-[72px]">
    <div class="wrap max-w-4xl py-16">
      <p class="eyebrow">Account · Addresses</p>
      <h1 class="mt-4 font-display text-3xl tracking-[0.15em] text-ink">
        地址簿
      </h1>
      <p class="mt-3 text-[14px] tracking-[0.2em] text-ink/75">
        管理你的收货地址，默认地址将在结算时自动填入。
      </p>
      <div class="mt-12">
        <AddressManager />
      </div>
    </div>
  </div>
</template>
