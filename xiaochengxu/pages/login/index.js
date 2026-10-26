const api = require('../../utils/api')

/** 登录：官网注册的邮箱账号 + 密码，成功后回跳来源页 */
Page({
  data: {
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
    const email = this.data.email.trim()
    const password = this.data.password
    if (!email || email.indexOf('@') < 0) {
      wx.showToast({ title: '请输入有效的邮箱地址', icon: 'none' })
      return
    }
    if (!password) {
      wx.showToast({ title: '请输入密码', icon: 'none' })
      return
    }
    this.setData({ busy: true })
    api
      .login(email, password)
      .then(() => getApp().setLoginSuccess())
      .then(() => {
        wx.showToast({ title: '登录成功', icon: 'success' })
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

  goRegister() {
    let url = '/pages/register/index'
    if (this._redirect) url += '?redirect=' + encodeURIComponent(this._redirect)
    wx.navigateTo({ url })
  },
})
