<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { productApi } from '@/api'
import { yuan, maskName, formatDate } from '@/utils/format'
import ProductGallery from '@/components/ProductGallery.vue'
import AddToCart from '@/components/AddToCart.vue'
import ProductCard from '@/components/ProductCard.vue'
import Reveal from '@/components/Reveal.vue'
import ReviewForm from '@/components/ReviewForm.vue'

const route = useRoute()

const detail = ref(null)
const loaded = ref(false)
const notFound = ref(false)

async function load() {
  loaded.value = false
  notFound.value = false
  try {
    detail.value = await productApi.detail(route.params.slug)
  } catch (e) {
    notFound.value = true
  } finally {
    loaded.value = true
  }
}

// 评价提交成功后刷新详情（对应原 Next.js revalidatePath 行为）
async function refetch() {
  try {
    detail.value = await productApi.detail(route.params.slug)
  } catch (e) {
    // ignore
  }
}

onMounted(load)
watch(() => route.params.slug, load)
</script>

<template>
  <div class="pt-[72px]">
    <template v-if="loaded && detail && !notFound">
      <!-- 面包屑 -->
      <div class="wrap flex items-center gap-2 py-6 text-[11px] tracking-[0.2em] text-ink/40">
        <router-link to="/" class="transition-colors hover:text-ink">
          品牌首页
        </router-link>
        <span>/</span>
        <router-link to="/shop" class="transition-colors hover:text-ink">
          官方商城
        </router-link>
        <span>/</span>
        <router-link
          :to="`/products?cat=${detail.category.slug}`"
          class="transition-colors hover:text-ink"
        >
          {{ detail.category.name }}
        </router-link>
        <span>/</span>
        <span class="text-ink/70">{{ detail.name }}</span>
      </div>

      <!-- 商品主区 -->
      <div class="wrap grid gap-12 pb-20 lg:grid-cols-2 lg:gap-16">
        <div class="lg:sticky lg:top-28 lg:self-start">
          <ProductGallery :images="detail.images" :name="detail.name" />
        </div>

        <div>
          <p class="eyebrow">{{ detail.category.nameEn }}</p>
          <h1 class="mt-4 font-display text-3xl leading-snug tracking-[0.08em] text-ink md:text-4xl">
            {{ detail.name }}
          </h1>
          <p v-if="detail.subtitle" class="mt-3 text-sm tracking-[0.18em] text-ink/50">
            {{ detail.subtitle }}
          </p>

          <div class="mt-7 flex items-baseline gap-4">
            <span class="font-display text-3xl text-gold-deep">
              {{ yuan(detail.priceFen) }}
            </span>
            <span v-if="detail.compareAtFen" class="text-sm text-ink/30 line-through">
              {{ yuan(detail.compareAtFen) }}
            </span>
            <span v-if="detail.compareAtFen" class="bg-ink/85 px-2.5 py-1 text-[10px] tracking-[0.2em] text-ivory">
              限时礼遇
            </span>
          </div>

          <div class="my-8 h-px bg-ink/10" />

          <p class="text-[15px] leading-loose text-ink/75">
            {{ detail.description }}
          </p>
          <p v-if="detail.story" class="mt-5 border-l-2 border-gold/50 pl-5 text-sm leading-loose text-ink/55">
            {{ detail.story }}
          </p>

          <div class="mt-9">
            <AddToCart :product-id="detail.id" :stock="detail.stock" />
          </div>

          <!-- 服务保障 -->
          <ul class="mt-10 space-y-3 border border-ink/10 bg-ivory p-6 text-[12px] tracking-[0.12em] text-ink/60">
            <li class="flex items-center gap-3">
              <span class="text-gold-deep">◆</span> 顺丰包邮 · 48 小时内发出
            </li>
            <li class="flex items-center gap-3">
              <span class="text-gold-deep">◆</span> 30 天无忧退换 · 七星洗护服务
            </li>
            <li class="flex items-center gap-3">
              <span class="text-gold-deep">◆</span> 绮云会员享生日臻礼与专属折扣
            </li>
          </ul>
        </div>
      </div>

      <!-- 规格参数 + 评价 -->
      <div class="wrap grid gap-16 pb-20 lg:grid-cols-5">
        <div class="lg:col-span-2">
          <Reveal>
            <p class="eyebrow">Specifications</p>
            <h2 class="mt-4 font-display text-2xl tracking-[0.15em]">规格参数</h2>
            <dl class="mt-8">
              <div v-if="detail.material" class="flex gap-6 border-t border-ink/10 py-4 text-sm">
                <dt class="w-20 shrink-0 tracking-[0.2em] text-ink/45">材质</dt>
                <dd class="leading-relaxed text-ink/75">{{ detail.material }}</dd>
              </div>
              <div
                v-for="s in detail.specs"
                :key="s.label"
                class="flex gap-6 border-t border-ink/10 py-4 text-sm"
              >
                <dt class="w-20 shrink-0 tracking-[0.2em] text-ink/45">
                  {{ s.label }}
                </dt>
                <dd class="leading-relaxed text-ink/75">{{ s.value }}</dd>
              </div>
              <div class="flex gap-6 border-y border-ink/10 py-4 text-sm">
                <dt class="w-20 shrink-0 tracking-[0.2em] text-ink/45">销量</dt>
                <dd class="text-ink/75">已售 {{ detail.sales.toLocaleString('zh-CN') }} 件</dd>
              </div>
            </dl>
          </Reveal>
        </div>

        <div class="lg:col-span-3">
          <Reveal>
            <div class="flex items-baseline justify-between">
              <div>
                <p class="eyebrow">Reviews</p>
                <h2 class="mt-4 font-display text-2xl tracking-[0.15em]">
                  用户评价（{{ detail.reviews.length }}）
                </h2>
              </div>
              <p class="font-display text-3xl text-gold-deep">
                {{ detail.avgRating.toFixed(1) }}
                <span class="ml-1 text-sm text-ink/40">/ 5.0</span>
              </p>
            </div>
            <div class="mt-8 space-y-6">
              <p v-if="detail.reviews.length === 0" class="py-8 text-sm tracking-[0.15em] text-ink/40">
                暂无评价，成为第一位分享者。
              </p>
              <div v-for="r in detail.reviews" :key="r.id" class="border-b border-ink/10 pb-6">
                <p class="text-sm tracking-[0.2em] text-gold">
                  {{ '★'.repeat(r.rating) }}<span class="text-ink/20">{{ '☆'.repeat(5 - r.rating) }}</span>
                </p>
                <p class="mt-3 text-sm leading-loose text-ink/75">
                  「{{ r.content }}」
                </p>
                <p class="mt-3 text-[11px] tracking-[0.2em] text-ink/40">
                  {{ maskName(r.userName) }} · {{ formatDate(r.createdAt) }}
                </p>
              </div>
            </div>
            <ReviewForm v-if="detail.loggedIn && detail.canReview" :product-id="detail.id" @submitted="refetch" />
            <p v-else-if="detail.loggedIn" class="mt-6 text-[11px] tracking-[0.15em] text-ink/40">
              购买过该商品后即可发表评价（每个商品限一次）。
            </p>
            <p v-else class="mt-6 text-[11px] tracking-[0.15em] text-ink/40">
              登录并购买过该商品后即可发表评价。
            </p>
          </Reveal>
        </div>
      </div>

      <!-- 相关推荐 -->
      <section v-if="detail.related.length > 0" class="bg-ivory py-20">
        <div class="wrap">
          <Reveal>
            <p class="eyebrow">You May Also Like</p>
            <h2 class="mt-4 font-display text-2xl tracking-[0.15em]">
              同系列甄选
            </h2>
          </Reveal>
          <div class="mt-12 grid gap-x-7 gap-y-14 sm:grid-cols-2 lg:grid-cols-4">
            <ProductCard
              v-for="(p, i) in detail.related"
              :key="p.slug"
              :p="p"
              :delay="i * 90"
            />
          </div>
        </div>
      </section>
    </template>

    <!-- 未找到 -->
    <div v-else-if="loaded && notFound" class="wrap py-24 text-center">
      <p class="font-display text-2xl tracking-[0.15em] text-ink/60">
        商品不存在或已下架
      </p>
      <router-link to="/products" class="btn-primary mt-10">
        浏览产品展示
      </router-link>
    </div>
  </div>
</template>
