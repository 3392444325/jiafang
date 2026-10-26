const api = require('../../utils/api')

/** 收货地址列表：设默认 / 编辑 / 删除 */
Page({
  data: {
    list: [],
    loading: true,
  },

  onShow() {
    // 登录守卫：未登录跳登录页，成功后回跳本页
    getApp()
      .restoreUser()
      .then((user) => {
        if (!user) {
          wx.navigateTo({
            url: '/pages/login/index?redirect=' + encodeURIComponent('/pages/address/index'),
          })
          return
        }
        this.load()
      })
  },

  onPullDownRefresh() {
    this.load().then(() => wx.stopPullDownRefresh())
  },

  load() {
    this.setData({ loading: true })
    return api
      .addressList()
      .then((res) => {
        this.setData({ loading: false, list: res.addresses || [] })
      })
      .catch(() => {
        this.setData({ loading: false })
      })
  },

  setDefault(e) {
    api
      .addressSetDefault(e.currentTarget.dataset.id)
      .then(() => this.load())
      .catch(() => {})
  },

  editAddr(e) {
    const it = this.data.list[e.currentTarget.dataset.idx]
    if (!it) return
    const q =
      'id=' + it.id +
      '&name=' + encodeURIComponent(it.name || '') +
      '&phone=' + encodeURIComponent(it.phone || '') +
      '&province=' + encodeURIComponent(it.province || '') +
      '&city=' + encodeURIComponent(it.city || '') +
      '&district=' + encodeURIComponent(it.district || '') +
      '&detail=' + encodeURIComponent(it.detail || '')
    wx.navigateTo({ url: '/pages/address-edit/index?' + q })
  },

  delAddr(e) {
    const id = e.currentTarget.dataset.id
    wx.showModal({
      title: '提示',
      content: '确定删除该收货地址吗？',
      success: (res) => {
        if (!res.confirm) return
        api
          .addressDelete(id)
          .then(() => {
            wx.showToast({ title: '已删除', icon: 'success' })
            this.load()
          })
          .catch(() => {})
      },
    })
  },

  goAdd() {
    wx.navigateTo({ url: '/pages/address-edit/index' })
  },
})
