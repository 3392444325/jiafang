const api = require('../../utils/api')

/** 注册：昵称 + 邮箱 + 密码（至少 6 位），成功后自动登录并回跳 */
Page({
  data: {
    name: '',
    email: '',
    password: '',
    busy: false,
  },

  onLoad(options) {
    this._redirect = options.redirect ? decodeURIComponent(options.redirect) : ''
  },

  onInput(e) {
    this.setData({ [e.currentTarget.dataset.k]: e.detail.value })
  },

  submit() {
    if (this.data.busy) return
    const name = this.data.name.trim()
    const email = this.data.email.trim()
    const password = this.data.password
    if (!name) {
      wx.showToast({ title: '请输入昵称', icon: 'none' })
      return
    }
    if (!email || email.indexOf('@') < 0) {
      wx.showToast({ title: '请输入有效的邮箱地址', icon: 'none' })
      return
    }
    if (!password || password.length < 6) {
      wx.showToast({ title: '密码至少 6 位', icon: 'none' })
      return
    }
    this.setData({ busy: true })
    api
      .register(email, password, name)
      .then(() => getApp().setLoginSuccess())
      .then(() => {
        wx.showToast({ title: '注册成功', icon: 'success' })
        setTimeout(() => this.goNext(), 600)
      })
      .catch(() => {
        this.setData({ busy: false })
      })
  },

  goNext() {
    if (this._redirect) {
      wx.redirectTo({
        url: this._redirect,
        fail: () => wx.switchTab({ url: '/pages/profile/index' }),
      })
    } else {
      wx.navigateBack({ fail: () => wx.switchTab({ url: '/pages/profile/index' }) })
    }
  },

  goLogin() {
    let url = '/pages/login/index'
    if (this._redirect) url += '?redirect=' + encodeURIComponent(this._redirect)
    wx.navigateTo({ url })
  },
})
