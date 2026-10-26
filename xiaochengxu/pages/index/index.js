const api = require('../../utils/api')
const { resolveImg } = require('../../utils/img')

/** 首页：搜索入口 + Banner 轮播 + 分类横滑 + 新品网格 */
Page({
  data: {
    loading: true,
    banners: [],
    categories: [],
    products: [],
  },

  onShow() {
    getApp().refreshCartBadge()
    this.load()
  },

  onPullDownRefresh() {
    this.load().then(() => wx.stopPullDownRefresh())
  },

  load() {
    this.setData({ loading: true })
    return Promise.all([api.getHome(), api.getProducts('', 'default', '')])
      .then(([home, prods]) => {
        const content = home.content || {}
        const slides = (content['home.hero'] && content['home.hero'].slides) || []
        const banners = slides
          .filter((s) => s.src)
          .map((s) => ({
            img: resolveImg(s.src),
            title: (s.title || '').replace(/\n/g, ' '),
          }))
        if (!banners.length) {
          banners.push({ img: resolveImg('/images/heroes/hero-1.jpg'), title: 'ST.KELLY' })
        }
        this.setData({
          loading: false,
          banners,
          categories: (home.categories || []).map((c) => ({
            slug: c.slug,
            name: c.name,
            img: resolveImg(c.image),
          })),
          products: (prods.cards || []).slice(0, 6),
        })
      })
      .catch(() => {
        this.setData({ loading: false })
      })
  },

  goSearch() {
    wx.navigateTo({ url: '/pages/shop/index?focus=1' })
  },

  goCategory(e) {
    const slug = e.currentTarget.dataset.slug
    wx.navigateTo({ url: '/pages/shop/index?cat=' + slug })
  },

  goShop() {
    wx.switchTab({ url: '/pages/shop/index' })
  },
})
