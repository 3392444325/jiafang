const api = require('../../utils/api')
const { resolveImg } = require('../../utils/img')

/** 商品详情：图集 + 参数 + 评价 + 相关推荐 + 底部加购/购买栏 */
Page({
  data: {
    loading: true,
    p: null,
    imgs: [],
    cur: 0,
    qty: 1,
    reviews: [],
    related: [],
    adding: false,
  },

  onLoad(options) {
    this._slug = options.slug || ''
    this.load()
  },

  load() {
    this.setData({ loading: true })
    return api
      .getProduct(this._slug)
      .then((p) => {
        this.setData({
          loading: false,
          p,
          imgs: (p.images || []).map((u) => resolveImg(u)),
          reviews: p.reviews || [],
          related: p.related || [],
          qty: 1,
        })
        wx.setNavigationBarTitle({ title: p.name || 'ST.KELLY' })
      })
      .catch(() => {
        this.setData({ loading: false })
        wx.showToast({ title: '商品不存在或已下架', icon: 'none' })
      })
  },

  onImgChange(e) {
    this.setData({ cur: e.detail.current })
  },

  onImgErr(e) {
    // SVG 占位图在小程序内不渲染时降级为空占位
    const key = 'imgs[' + e.currentTarget.dataset.idx + ']'
    this.setData({ [key]: '' })
  },

  onRelatedErr(e) {
    const key = 'related[' + e.currentTarget.dataset.idx + '].image'
    this.setData({ [key]: '' })
  },

  step(e) {
    const d = Number(e.currentTarget.dataset.d) || 1
    const p = this.data.p
    const max = Math.max(1, Math.min(p ? p.stock : 99, 99))
    this.setData({ qty: Math.min(max, Math.max(1, this.data.qty + d)) })
  },

  addCart(buyNow) {
    const p = this.data.p
    if (!p || this.data.adding) return
    this.setData({ adding: true })
    api
      .cartAdd(p.id, this.data.qty)
      .then(() => getApp().refreshCartBadge())
      .then(() => {
        this.setData({ adding: false })
        if (buyNow) {
          wx.navigateTo({ url: '/pages/checkout/index' })
        } else {
          wx.showToast({ title: '已加入购物车', icon: 'success' })
        }
      })
      .catch(() => {
        this.setData({ adding: false })
      })
  },

  onAdd() {
    this.addCart(false)
  },

  onBuy() {
    this.addCart(true)
  },

  goReview() {
    const p = this.data.p
    wx.navigateTo({
      url:
        '/pages/review/index?productId=' + p.id + '&name=' + encodeURIComponent(p.name),
    })
  },

  goRelated(e) {
    wx.navigateTo({
      url: '/pages/product/index?slug=' + e.currentTarget.dataset.slug,
    })
  },
})
