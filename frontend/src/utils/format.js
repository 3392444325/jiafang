// 格式化工具 —— 移植自原 Next.js 项目 @/lib/format

/** 分 → ¥1,299 */
export function yuan(fen) {
  return `¥${(fen / 100).toLocaleString('zh-CN', { maximumFractionDigits: 0 })}`
}

/** 分 → 1,299.00 */
export function fenToNum(fen) {
  return (fen / 100).toLocaleString('zh-CN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })
}

export function formatDate(d) {
  const date = typeof d === 'string' ? new Date(d) : d
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

/** 后端 Date 统一转为本地时区 YYYY-MM-DD（兼容 ISO 字符串与毫秒时间戳） */
export function ymd(v) {
  if (!v) return ''
  const d = v instanceof Date ? v : new Date(v)
  return isNaN(d.getTime()) ? '' : d.toLocaleDateString('sv-SE')
}

export function formatDateTime(d) {
  const date = typeof d === 'string' ? new Date(d) : d
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
  })
}

/** 姓名脱敏:张三 → 张**, Leon → L*** */
export function maskName(name) {
  const n = (name || '').trim()
  if (!n) return '匿名用户'
  if (/^[\u4e00-\u9fa5]+$/.test(n)) {
    return n.length <= 1 ? `${n}**` : `${n[0]}${'*'.repeat(Math.min(n.length - 1, 2))}`
  }
  return `${n[0]}${'*'.repeat(Math.max(n.length - 1, 2))}`
}

export const PAY_METHOD_LABEL = {
  WECHAT: '微信支付',
  ALIPAY: '支付宝',
  CARD: '银行卡',
}

export const ORDER_STATUS = {
  PENDING_PAYMENT: { label: '待付款', cls: 'text-gold-deep border-gold/40 bg-gold/10' },
  PAID: { label: '已付款', cls: 'text-emerald-800 border-emerald-700/30 bg-emerald-700/10' },
  SHIPPED: { label: '已发货', cls: 'text-sky-800 border-sky-700/30 bg-sky-700/10' },
  COMPLETED: { label: '已完成', cls: 'text-ink-soft border-ink/20 bg-ink/5' },
  CANCELLED: { label: '已取消', cls: 'text-red-800 border-red-700/30 bg-red-700/10' },
}
