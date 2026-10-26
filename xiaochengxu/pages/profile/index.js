const api = require('../../utils/api')
const { clearToken } = require('../../utils/request')

/** 「我的」：登录态展示 + 菜单入口 + 退出登录 */
Page({
  data: {
    user: null,
  },

  onShow() {
    const app = getApp()
    // 每次展示都刷新登录态（如从登录页返回后）
    app.restoreUser().then(() => {
      this.setData({ user: app.globalData.user })
    })
    app.refreshCartBadge()
  },

  goLogin() {
    wx.navigateTo({ url: '/pages/login/index' })
  },

  goRegister() {
    wx.navigateTo({ url: '/pages/register/index' })
  },

  goOrder() {
    wx.navigateTo({ url: '/pages/order-list/index' })
  },

  goAddress() {
    wx.navigateTo({ url: '/pages/address/index' })
  },

  goLeads() {
    wx.navigateTo({ url: '/pages/leads/index' })
  },

  logout() {
    wx.showModal({
      title: '提示',
      content: '确定要退出登录吗？',
      success: (res) => {
        if (!res.confirm) return
        api
          .logout()
          .catch(() => {})
          .then(() => {
            clearToken()
            getApp().globalData.user = null
            this.setData({ user: null })
            wx.showToast({ title: '已退出登录', icon: 'success' })
          })
      },
    })
  },
})
