<template>
  <div class="wrap flex min-h-[64vh] flex-col items-center justify-center py-24 text-center">
    <p class="eyebrow">404 · Page Not Found</p>
    <h1 class="mt-8 font-display text-7xl leading-none tracking-[0.08em] text-ink md:text-8xl">
      404
    </h1>
    <div class="mt-8 h-px w-14 bg-gold-deep/60" />
    <p class="mt-8 font-display text-2xl tracking-[0.15em] text-ink/90">
      这一页，仍在织造中
    </p>
    <p class="mt-4 max-w-md text-[15px] leading-loose text-ink/80">
      你要找的页面不存在或已下架。不如回到甄选系列，
      <br />
      为今晚挑一床好梦。
    </p>
    <div class="mt-10 flex flex-wrap justify-center gap-4">
      <router-link to="/" class="btn-primary">
        返回品牌首页
      </router-link>
      <router-link to="/products" class="btn-ghost">
        逛产品展示
      </router-link>
    </div>
  </div>
</template>
