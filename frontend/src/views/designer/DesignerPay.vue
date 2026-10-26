<script setup>
import { ref, onMounted } from 'vue'
import { designerApi } from '@/api'
import DesignerLayout from '@/components/DesignerLayout.vue'

/** 收款码设置：个人微信 / 支付宝收款码图片与收款人姓名，存 site_content 的 pay.* 键 */

const KEYS = ['pay.wechatQrUrl', 'pay.alipayQrUrl', 'pay.wechatName', 'pay.alipayName', 'pay.alipayAccount']

const content = ref(Object.fromEntries(KEYS.map((k) => [k, ''])))
const loading = ref(true)
const saving = ref(false)
const savedTip = ref('')
const error = ref('')
const uploading = ref('') // 正在上传的键名
const uploadError = ref('')

async function load() {
  loading.value = true
  error.value = ''
  try {
    const data = await designerApi.content()
    for (const k of KEYS) {
      if (typeof data[k] === 'string') content.value[k] = data[k]
    }
  } catch (e) {
    error.value = e.message || '加载失败'
  } finally {
    loading.value = false
  }
}

async function save() {
  saving.value = true
  savedTip.value = ''
  error.value = ''
  try {
    await designerApi.saveContent(content.value)
    savedTip.value = '已保存，用户支付页即可看到最新收款码'
  } catch (e) {
    error.value = e.message || '保存失败'
  } finally {
    saving.value = false
  }
}

async function onFileChange(key, e) {
  const file = e.target.files && e.target.files[0]
  e.target.value = ''
  if (!file) return
  uploading.value = key
  uploadError.value = ''
  try {
    const res = await designerApi.upload(file)
    content.value[key] = res.url
  } catch (err) {
    uploadError.value = err.message || '上传失败'
  } finally {
    uploading.value = ''
  }
}

onMounted(() => {
  document.title = '页面设计 · 收款码'
  load()
})
</script>

<template>
  <DesignerLayout>
    <div class="max-w-4xl">
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div>
          <p class="eyebrow">Payment QR Codes</p>
          <h2 class="mt-3 font-display text-2xl tracking-[0.15em] text-ink">
            收款码设置
          </h2>
        </div>
        <div class="flex items-center gap-4">
          <span v-if="savedTip" class="text-[14px] tracking-[0.1em] text-emerald-700">{{ savedTip }}</span>
          <span v-if="error" class="text-[14px] text-red-700">{{ error }}</span>
          <button class="btn-primary" :disabled="saving || loading" @click="save">
            {{ saving ? '保存中…' : '保存全部' }}
          </button>
        </div>
      </div>

      <div v-if="loading" class="mt-10 text-[15px] tracking-[0.2em] text-ink/75">加载中…</div>

      <template v-else>
        <div class="mt-10 border border-ink/10 bg-ivory">
          <div class="border-b border-ink/10 px-6 py-4 text-[14px] tracking-[0.25em] text-ink/80">
            收款码配置
            <p class="mt-1.5 text-[14px] leading-relaxed tracking-normal text-ink/75">
              上传你的个人微信 / 支付宝收款码截图（微信：我 → 服务 → 收付款 → 二维码收款 → 保存收款码）。
              填写支付宝账号 / UID 后，买家支付时会收到「金额与订单号已自动填好」的支付宝转账二维码，按商品价格精确收款；
              微信个人收款码不支持带金额，买家将按页面提示金额手动转账。
              用户提交付款凭证后，你在「商家后台 → 订单管理」核对金额并确认收款，订单完成支付。
              收款码仅登录用户可见，不会出现在公开页面。
            </p>
          </div>
          <div class="grid gap-8 p-6 sm:grid-cols-2">
            <div v-for="m in [{ key: 'wechat', label: '微信收款码', urlKey: 'pay.wechatQrUrl', nameKey: 'pay.wechatName' }, { key: 'alipay', label: '支付宝收款码', urlKey: 'pay.alipayQrUrl', nameKey: 'pay.alipayName' }]"
              :key="m.key"
              class="flex flex-col gap-3"
            >
              <span class="text-[14px] tracking-[0.2em] text-ink/80">{{ m.label }}</span>
              <label class="flex h-52 cursor-pointer items-center justify-center border border-dashed border-ink/25 bg-white transition-colors hover:border-gold-deep">
                <input type="file" accept="image/*" class="hidden" :disabled="uploading === m.urlKey" @change="onFileChange(m.urlKey, $event)" />
                <img v-if="content[m.urlKey]" :src="content[m.urlKey]" :alt="m.label" class="max-h-full max-w-full object-contain p-2" />
                <span v-else class="text-[14px] tracking-[0.15em] text-ink/75">
                  {{ uploading === m.urlKey ? '上传中…' : '点击上传收款码图片' }}
                </span>
              </label>
              <label>
                <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">收款人姓名（显示给买家）</span>
                <input v-model="content[m.nameKey]" class="field" placeholder="如：王师傅" />
              </label>
            </div>
          </div>
          <div class="border-t border-ink/10 px-6 py-5">
            <label>
              <span class="mb-1 block text-[14px] tracking-[0.2em] text-ink/80">支付宝 UID（强烈推荐填写，启用金额自动填充的转账码）</span>
              <input v-model="content['pay.alipayAccount']" class="field" placeholder="支付宝 UID（2088 开头，推荐）" />
            </label>
            <p class="mt-2 text-[14px] leading-relaxed tracking-normal text-ink/75">
              填写后，买家选支付宝支付时会生成含订单金额、订单号备注的专属转账二维码，扫码即打开转账页且<b class="text-ink">金额已自动填好、无需任何验证</b>，直接点确认转账即可。
            </p>
            <p class="mt-1.5 text-[14px] leading-relaxed tracking-normal text-amber-800">
              UID 查询方法：电脑浏览器打开 open.alipay.com（支付宝开放平台），用支付宝 App 扫码登录 → 右上角头像 →「账号中心」，即可看到 2088 开头的 UID（合作伙伴身份 PID）。
              请勿填手机号 / 邮箱——支付宝对「向手机号转账」强制要求二次确认收款账户，扫码后会让买家填写手机号验证，体验很差。
            </p>
          </div>
          <p v-if="uploadError" class="border-t border-ink/10 px-6 py-3 text-[14px] text-red-700">{{ uploadError }}</p>
        </div>

        <div class="mt-8 flex items-center justify-end gap-4">
          <span v-if="savedTip" class="text-[14px] tracking-[0.1em] text-emerald-700">{{ savedTip }}</span>
          <button class="btn-primary" :disabled="saving || loading" @click="save">
            {{ saving ? '保存中…' : '保存全部' }}
          </button>
        </div>
      </template>
    </div>
  </DesignerLayout>
</template>
