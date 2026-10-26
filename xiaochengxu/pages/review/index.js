const api = require('../../utils/api')

/** 发表评价：5 星评分 + 至少 10 字内容，仅购买过该商品的用户可评 */
Page({
  data: {
    productId: 0,
    productName: '',
    stars: [1, 2, 3, 4, 5],
    rating: 5,
    content: '',
    busy: false,
  },

  onLoad(options) {
    const back =
      '/pages/review/index?productId=' + (options.productId || '') +
      '&name=' + (options.name || '')
    // 登录守卫：未登录跳登录页，成功后回跳本页
    getApp()
      .restoreUser()
      .then((user) => {
        if (!user) {
          wx.navigateTo({
            url: '/pages/login/index?redirect=' + encodeURIComponent(back),
          })
          return
        }
        this.setData({
          productId: Number(options.productId) || 0,
          productName: options.name ? decodeURIComponent(options.name) : '',
        })
      })
  },

  pickStar(e) {
    this.setData({ rating: Number(e.currentTarget.dataset.v) || 5 })
  },

  onInput(e) {
    this.setData({ content: e.detail.value })
  },

  submit() {
    if (this.data.busy) return
    if (!this.data.productId) {
      wx.showToast({ title: '缺少商品信息', icon: 'none' })
      return
    }
    const content = this.data.content.trim()
    if (content.length < 10) {
      wx.showToast({ title: '评价内容至少 10 个字', icon: 'none' })
      return
    }
    this.setData({ busy: true })
    api
      .reviewSubmit(this.data.productId, this.data.rating, content)
      .then(() => {
        wx.showToast({ title: '评价成功', icon: 'success' })
        setTimeout(() => wx.navigateBack(), 800)
      })
      .catch(() => {
        this.setData({ busy: false })
      })
  },
})
