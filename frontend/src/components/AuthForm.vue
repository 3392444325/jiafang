<script setup>
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const props = defineProps({
  mode: { type: String, required: true },
})

const router = useRouter()
const route = useRoute()
const auth = useAuthStore()

const email = ref('')
const password = ref('')
const name = ref('')
const error = ref('')
const busy = ref(false)

const isLogin = computed(() => props.mode === 'login')

async function submit() {
  busy.value = true
  error.value = ''
  try {
    if (isLogin.value) {
      await auth.login(email.value, password.value)
    } else {
      await auth.register(email.value, password.value, name.value)
    }
    const redirect = route.query.redirect ? String(route.query.redirect) : '/'
    router.push(redirect)
  } catch (e) {
    error.value = e.message || '操作失败，请重试'
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <div>
    <div class="text-center">
      <p class="eyebrow">{{ isLogin ? 'Sign In' : 'Join Zhiyun' }}</p>
      <h1 class="mt-4 font-display text-3xl tracking-[0.2em] text-ink">
        {{ isLogin ? '欢迎回来' : '加入织云' }}
      </h1>
      <div class="mx-auto mt-5 h-px w-12 bg-gold-deep/60" />
    </div>

    <form @submit.prevent="submit" class="mt-10 space-y-5">
      <input
        v-if="!isLogin"
        v-model="name"
        class="field"
        placeholder="昵称"
        required
      />
      <input
        v-model="email"
        class="field"
        type="email"
        placeholder="邮箱"
        required
      />
      <input
        v-model="password"
        class="field"
        type="password"
        placeholder="密码（至少 6 位）"
        required
        minlength="6"
      />
      <p v-if="error" class="text-xs tracking-[0.15em] text-red-700">{{ error }}</p>
      <button type="submit" :disabled="busy" class="btn-primary w-full disabled:opacity-50">
        {{ busy ? '处理中…' : isLogin ? '登 录' : '注 册' }}
      </button>
    </form>

    <p class="mt-8 text-center text-xs tracking-[0.15em] text-ink/50">
      {{ isLogin ? '还没有织云账户？' : '已经是会员？' }}
      <router-link
        :to="isLogin ? '/register' : '/login'"
        class="ml-2 text-gold-deep transition-colors hover:text-ink"
      >
        {{ isLogin ? '立即注册' : '直接登录' }}
      </router-link>
    </p>

    <p
      v-if="isLogin"
      class="mt-6 border border-ink/10 bg-ivory px-4 py-3 text-center text-[11px] leading-relaxed tracking-[0.1em] text-ink/45"
    >
      客服热线 400-860-1988（9:00 - 21:00）
      <br />
      service@zhiyun.cn · 登录遇到问题可随时联系我们
    </p>
  </div>
</template>
