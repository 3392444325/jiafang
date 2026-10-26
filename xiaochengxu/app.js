const { me } = require('./utils/api')
const { cartCount } = require('./utils/api')

App({
  globalData: {
    user: null, // { id, email, name, role }
  },

  onLaunch() {
    this.restoreUser()
  },

  /** 启动时用已存的 zy_session 恢复登录态（未登录返回 null，浏览/游客加购不受影响） */
  restoreUser() {
    return me()
      .then((res) => {
        this.globalData.user = res.user && res.user.id ? res.user : null
        return this.globalData.user
      })
      .catch(() => {
        this.globalData.user = null
        return null
      })
  },

  isLoggedIn() {
    return !!this.globalData.user
  },

  setLoginSuccess() {
    // 登录/注册成功后调用：刷新用户态 + 购物车角标
    return this.restoreUser().then(() => this.refreshCartBadge())
  },

  /** 更新 tabBar「购物车」角标（index: 2） */
  refreshCartBadge() {
    return cartCount()
      .then((res) => {
        const count = res.count || 0
        if (count > 0) {
          wx.setTabBarBadge({ index: 2, text: count > 99 ? '99+' : String(count), fail: () => {} })
        } else {
          wx.removeTabBarBadge({ index: 2, fail: () => {} })
        }
        return count
      })
      .catch(() => {})
  },
})
