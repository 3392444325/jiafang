const api = require('../../utils/api')
const { resolveImg } = require('../../utils/img')
const { fmtDateTime } = require('../../utils/date')

const STATUS_TEXT = {
  PENDING_PAYMENT: '待付款',
  PAID: '已付款',
  SHIPPED: '已发货',
  COMPLETED: '已完成',
  CANCELLED: '已取消',
}
const PAY_TEXT = {
  WECHAT: '微信支付',
}

/** 订单详情：状态 + 收货信息 + 商品清单 + 金额 + 支付/取消/退款操作 */
Page({
  data: {
    loading: true,
    o: null,
    addr: null,
    items: [],
    paying: false,
  },

  onLoad(options) {
    this._id = options.id || ''
    this._autoPay = options.pay === '1'
  },

  onShow() {
    const app = getApp()
    if (!app.isLoggedIn()) {
      wx.navigateTo({
        url:
          '/pages/login/index?redirect=' +
          encodeURIComponent('/pages/order-detail/index?id=' + this._id),
      })
      return
    }
    this.load()
  },

  load() {
    this.setData({ loading: true })
    return api
      .orderDetail(this._id)
      .then((o) => {
        let addr = null
        if (o.addressJson) {
          try {
            addr = JSON.parse(o.addressJson)
          } catch (e) {
            addr = null
          }
        }
        const items = (o.items || []).map((it, i) => ({
          idx: i,
          nameSnap: it.nameSnap,
          image: resolveImg(it.imageSnap),
          priceFen: it.priceFen,
          qty: it.qty,
          _err: false,
        }))
        this.setData({
          loading: false,
          o: {
            id: o.id,
            orderNo: o.orderNo,
            status: o.status,
            statusText: STATUS_TEXT[o.status] || o.status,
            cancelRequested: !!o.cancelRequested,
            totalFen: o.totalFen,
            payText: PAY_TEXT[o.payMethod] || o.payMethod || '',
            paidText: o.paidAt ? fmtDateTime(o.paidAt) : '',
            createdText: fmtDateTime(o.createdAt),
          },
          addr,
          items,
        })
        // 从提交订单跳转过来时自动弹出支付确认（仅待付款）
        if (this._autoPay) {
          this._autoPay = false
          if (o.status === 'PENDING_PAYMENT') this.askPay()
        }
      })
      .catch(() => {
        this.setData({ loading: false, o: null })
      })
  },

  onImgErr(e) {
    const key = 'items[' + e.currentTarget.dataset.idx + ']._err'
    this.setData({ [key]: true })
  },

  askPay() {
    wx.showModal({
      title: '模拟微信支付',
      content: '确认支付该订单？',
      success: (r) => {
        if (!r.confirm || this.data.paying) return
        this.setData({ paying: true })
        api
          .orderPay(this._id, 'WECHAT')
          .then(() => {
            this.setData({ paying: false })
            wx.showToast({ title: '支付成功', icon: 'success' })
            this.load()
          })
          .catch(() => {
            this.setData({ paying: false })
          })
      },
    })
  },

  onPay() {
    if (this.data.paying) return
    this.askPay()
  },

  onCancel() {
    wx.showModal({
      title: '取消订单',
      content: '确定取消该订单？取消后不可恢复。',
      success: (r) => {
        if (!r.confirm) return
        api
          .orderCancel(this._id)
          .then(() => {
            wx.showToast({ title: '订单已取消', icon: 'success' })
            this.load()
          })
          .catch(() => {})
      },
    })
  },

  onRefund() {
    wx.showModal({
      title: '申请退款',
      content: '退款申请需商家审核，确认提交？',
      success: (r) => {
        if (!r.confirm) return
        api
          .orderCancelRequest(this._id)
          .then(() => {
            wx.showToast({ title: '已提交申请', icon: 'success' })
            this.load()
          })
          .catch(() => {})
      },
    })
  },

  onCopy() {
    wx.setClipboardData({
      data: this.data.o.orderNo,
      success: () => wx.showToast({ title: '已复制', icon: 'success' }),
    })
  },
})
