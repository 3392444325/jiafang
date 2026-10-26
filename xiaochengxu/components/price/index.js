// 价格组件：分 → 千分位元，可带划线价
function fmt(fen) {
  const yuanVal = Number(fen || 0) / 100
  const hasDecimal = Math.round(Number(fen || 0)) % 100 !== 0
  const s = hasDecimal ? yuanVal.toFixed(2) : String(yuanVal)
  const parts = s.split('.')
  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',')
  return parts.join('.')
}

Component({
  options: { styleIsolation: 'apply-shared' },
  properties: {
    fen: { type: null, value: 0 },
    compare: { type: null, value: 0 }, // 划线价（分），0/空不显示
    size: { type: String, value: 'md' }, // sm | md | lg
  },
  data: { text: '', compareText: '' },
  lifetimes: {
    attached() {
      this.format()
    },
  },
  observers: {
    'fen, compare'() {
      this.format()
    },
  },
  methods: {
    format() {
      const f = Number(this.properties.fen || 0)
      const c = Number(this.properties.compare || 0)
      this.setData({
        text: '¥' + fmt(f),
        compareText: c > f ? '¥' + fmt(c) : '',
      })
    },
  },
})
