// 商品卡片：两列网格用（数据为 CardProduct：slug/name/subtitle/priceFen/compareAtFen/image/tag）
Component({
  options: { styleIsolation: 'apply-shared' },
  properties: {
    product: { type: Object, value: null },
  },
  data: { img: '', err: false },
  lifetimes: {
    attached() {
      this.resolve()
    },
  },
  observers: {
    product() {
      this.resolve()
    },
  },
  methods: {
    resolve() {
      const p = this.properties.product || {}
      const { resolveImg } = require('../../utils/img')
      this.setData({ img: resolveImg(p.image, ''), err: false })
    },
    goDetail() {
      const p = this.properties.product || {}
      if (!p.slug) return
      wx.navigateTo({ url: '/pages/product/index?slug=' + p.slug })
    },
    onImgErr() {
      // 官网占位图为 SVG（小程序 image 不支持），降级为品牌色块
      this.setData({ err: true })
    },
  },
})
