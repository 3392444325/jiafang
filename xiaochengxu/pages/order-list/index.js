const api = require('../../utils/api')
const { resolveImg } = require('../../utils/img')
const { ymd } = require('../../utils/date')

const STATUS = [
  { key: '', label: '全部' },
  { key: 'PENDING_PAYMENT', label: '待付款' },
  { key: 'PAID', label: '已付款' },
  { key: 'SHIPPED', label: '已发货' },
  { key: 'COMPLETED', label: '已完成' },
  { key: 'CANCELLED', label: '已取消' },
]
const STATUS_TEXT = {
  PENDING_PAYMENT: '待付款',
  PAID: '已付款',
  SHIPPED: '已发货',
  COMPLETED: '已完成',
  CANCELLED: '已取消',
}

/** 我的订单：状态筛选 chips + 订单卡片列表（客户端过滤） */
Page({
  data: {
    statuses: STATUS,
    status: '',
    loading: true,
    orders: [],
    shown: [],
  },

  onShow() {
    const app = getApp()
    if (!app.isLoggedIn()) {
      wx.navigateTo({
        url: '/pages/login/index?redirect=' + encodeURIComponent('/pages/order-list/index'),
      })
      return
    }
    this.load()
  },

  onPullDownRefresh() {
    this.load().then(() => wx.stopPullDownRefresh())
  },

  load() {
    this.setData({ loading: true })
    return api
      .orderList()
      .then((res) => {
        const orders = (res.orders || []).map((o) => {
          const items = o.items || []
          const first = items[0] || null
          return {
            id: o.id,
            orderNo: o.orderNo,
            status: o.status,
            statusText: STATUS_TEXT[o.status] || o.status,
            totalFen: o.totalFen,
            dateText: ymd(o.createdAt),
            kinds: items.length,
            totalQty: items.reduce((s, it) => s + (it.qty || 0), 0),
            first: first
              ? { nameSnap: first.nameSnap, image: resolveImg(first.imageSnap), qty: first.qty }
              : null,
            _err: false,
          }
        })
        this.setData({ loading: false, orders })
        this.applyFilter()
      })
      .catch(() => {
        this.setData({ loading: false })
      })
  },

  applyFilter() {
    const st = this.data.status
    const shown = st
      ? this.data.orders.filter((o) => o.status === st)
      : this.data.orders
    this.setData({ shown })
  },

  pickStatus(e) {
    this.setData({ status: e.currentTarget.dataset.key })
    this.applyFilter()
  },

  onImgErr(e) {
    const key = 'shown[' + e.currentTarget.dataset.idx + ']._err'
    this.setData({ [key]: true })
  },

  goDetail(e) {
    wx.navigateTo({ url: '/pages/order-detail/index?id=' + e.currentTarget.dataset.id })
  },

  goShop() {
    wx.switchTab({ url: '/pages/shop/index' })
  },
})
