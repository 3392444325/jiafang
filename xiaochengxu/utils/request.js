/**
 * 请求核心封装
 * - 自动携带 zy_session Cookie（小程序不自动管理 Cookie，需手动存取）
 * - 自动捕获响应 Set-Cookie 并更新本地存储（游客会话由首次 POST /cart 建立）
 * - 401 统一清除本地登录态；错误 toast 可用 silent 关闭
 */
const { apiBase } = require('../config/env')

const TOKEN_KEY = 'zy_session'

function getToken() {
  try {
    return wx.getStorageSync(TOKEN_KEY) || ''
  } catch (e) {
    return ''
  }
}

function clearToken() {
  try {
    wx.removeStorageSync(TOKEN_KEY)
  } catch (e) {
    /* ignore */
  }
}

/** 从响应头捕获 Set-Cookie，更新本地 token */
function captureCookie(res) {
  const h = res.header || res.headers || {}
  const raw = h['Set-Cookie'] || h['set-cookie'] || ''
  if (!raw) return
  const m = /zy_session=([^;]+)/.exec(raw)
  if (m && m[1]) {
    try {
      wx.setStorageSync(TOKEN_KEY, m[1])
    } catch (e) {
      /* ignore */
    }
  }
}

/**
 * request({ path, method, data, silent }) -> Promise<res.data>
 */
function request(options) {
  const opts = typeof options === 'string' ? { path: options } : options
  const path = opts.path
  const method = opts.method || 'GET'
  const data = opts.data || {}
  const silent = !!opts.silent

  return new Promise((resolve, reject) => {
    const header = { 'Content-Type': 'application/json' }
    const token = getToken()
    if (token) header.Cookie = 'zy_session=' + token

    wx.request({
      url: apiBase + path,
      method,
      data,
      header,
      success(res) {
        captureCookie(res)
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve(res.data)
          return
        }
        if (res.statusCode === 401) {
          clearToken()
          const app = getApp()
          if (app) app.globalData.user = null
        }
        const msg = (res.data && res.data.error) || '请求失败(' + res.statusCode + ')'
        if (!silent) {
          wx.showToast({ title: msg, icon: 'none', duration: 2200 })
        }
        reject(new Error(msg))
      },
      fail() {
        const msg = '网络连接失败，请稍后再试'
        if (!silent) {
          wx.showToast({ title: msg, icon: 'none', duration: 2200 })
        }
        reject(new Error(msg))
      },
    })
  })
}

module.exports = { request, getToken, clearToken }
