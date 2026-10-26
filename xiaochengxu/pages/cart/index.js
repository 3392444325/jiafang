const api = require('../../utils/api')
const { resolveImg } = require('../../utils/img')

/** 购物车：列表 + 数量步进 + 删除 + 合计结算 */
Page({
  data: {
    loading: true,
    items: [],
    totalFen: 0,
  },

  onShow() {
    this.load()
    getApp().refreshCartBadge()
  },

  onPullDownRefresh() {
    this.load().then(() => wx.stopPullDownRefresh())
  },

  load() {
    this.setData({ loading: true })
    return api
      .cartItems()
      .then((res) => {
        const items = (res.items || []).map((it) => ({
          id: it.id,
          slug: it.slug,
          name: it.name,
          image: resolveImg(it.image),
          priceFen: it.priceFen,
          qty: it.qty,
          stock: it.stock,
          tight: it.qty >= it.stock,
          _err: false,
        }))
        this.setData({ loading: false, items, totalFen: this.calcTotal(items) })
      })
      .catch(() => {
        this.setData({ loading: false })
      })
  },

  calcTotal(items) {
    return items.reduce((s, it) => s + it.priceFen * it.qty, 0)
  },

  onImgErr(e) {
    const key = 'items[' + e.currentTarget.dataset.idx + ']._err'
    this.setData({ [key]: true })
  },

  onStep(e) {
    const idx = Number(e.currentTarget.dataset.idx)
    const d = Number(e.currentTarget.dataset.d) || 0
    const it = this.data.items[idx]
    if (!it) return
    const qty = Math.min(Math.max(1, it.stock), Math.max(1, it.qty + d))
    if (qty === it.qty) return
    this.setData({ ['items[' + idx + '].qty']: qty })
    api
      .cartUpdate(it.id, qty)
      .then(() => {
        this.setData({
          totalFen: this.calcTotal(this.data.items),
          ['items[' + idx + '].tight']: qty >= it.stock,
        })
        getApp().refreshCartBadge()
      })
      .catch(() => {
        this.setData({ ['items[' + idx + '].qty']: it.qty })
      })
  },

  onRemove(e) {
    const idx = Number(e.currentTarget.dataset.idx)
    const it = this.data.items[idx]
    if (!it) return
    wx.showModal({
      title: '移除商品',
      content: '确定将「' + it.name + '」移出购物车？',
      success: (r) => {
        if (!r.confirm) return
        api
          .cartRemove(it.id)
          .then(() => {
            const items = this.data.items.filter((x) => x.id !== it.id)
            this.setData({ items, totalFen: this.calcTotal(items) })
            getApp().refreshCartBadge()
          })
          .catch(() => {})
      },
    })
  },

  goCheckout() {
    if (!this.data.items.length) return
    wx.navigateTo({ url: '/pages/checkout/index' })
  },

  goShop() {
    wx.switchTab({ url: '/pages/shop/index' })
  },
})
