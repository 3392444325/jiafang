const api = require('../../utils/api')
const { resolveImg } = require('../../utils/img')

/** 确认订单：地址选择/手填 + 商品清单 + 提交订单（按整个购物车创建） */
Page({
  data: {
    loading: true,
    items: [],
    totalFen: 0,
    addresses: [],
    addrId: 0,
    selAddr: null,
    showPicker: false,
    noAddress: false,
    form: { name: '', phone: '', province: '', city: '', district: '', detail: '' },
    saveAddress: false,
    submitting: false,
  },

  onShow() {
    const app = getApp()
    if (!app.isLoggedIn()) {
      wx.navigateTo({
        url: '/pages/login/index?redirect=' + encodeURIComponent('/pages/checkout/index'),
      })
      return
    }
    this.load()
  },

  load() {
    this.setData({ loading: true })
    return Promise.all([api.cartItems(), api.addressList()])
      .then(([cart, addr]) => {
        const items = (cart.items || []).map((it) => ({
          id: it.id,
          name: it.name,
          image: resolveImg(it.image),
          priceFen: it.priceFen,
          qty: it.qty,
          _err: false,
        }))
        const addresses = addr.addresses || []
        // 默认选中：上次的地址仍在则保留，否则 isDefault，再否则第一个
        let sel = null
        if (this._addrId) {
          sel = addresses.find((a) => a.id === this._addrId) || null
        }
        if (!sel) {
          sel = addresses.find((a) => a.isDefault) || addresses[0] || null
        }
        this._addrId = sel ? sel.id : 0
        this.setData({
          loading: false,
          items,
          totalFen: this.calcTotal(items),
          addresses,
          addrId: sel ? sel.id : 0,
          selAddr: sel,
          noAddress: addresses.length === 0,
        })
      })
      .catch(() => {
        this.setData({ loading: false })
      })
  },

  calcTotal(items) {
    return items.reduce((s, it) => s + it.priceFen * it.qty, 0)
  },

  onImgErr(e) {
    const key = 'items[' + e.currentTarget.dataset.idx + ']._err'
    this.setData({ [key]: true })
  },

  togglePicker() {
    this.setData({ showPicker: !this.data.showPicker })
  },

  pickAddr(e) {
    const id = e.currentTarget.dataset.id
    const sel = this.data.addresses.find((a) => a.id === id) || null
    this._addrId = id
    this.setData({ addrId: id, selAddr: sel, showPicker: false })
  },

  goAddAddress() {
    wx.navigateTo({ url: '/pages/address-edit/index?from=checkout' })
  },

  onFormInput(e) {
    const k = e.currentTarget.dataset.k
    this.setData({ ['form.' + k]: e.detail.value })
  },

  onSaveAddrChange(e) {
    this.setData({ saveAddress: e.detail.value })
  },

  submit() {
    if (this.data.submitting) return
    const f = this.data.form
    let d
    if (this.data.noAddress) {
      d = {
        name: f.name,
        phone: f.phone,
        province: f.province,
        city: f.city,
        district: f.district,
        detail: f.detail,
        saveAddress: this.data.saveAddress,
      }
    } else {
      const a = this.data.selAddr
      if (!a) {
        wx.showToast({ title: '请选择收货地址', icon: 'none' })
        return
      }
      d = {
        name: a.name,
        phone: a.phone,
        province: a.province,
        city: a.city,
        district: a.district,
        detail: a.detail,
        saveAddress: false,
      }
    }
    this.setData({ submitting: true })
    api
      .orderCreate(d)
      .then((res) => {
        getApp().refreshCartBadge()
        wx.redirectTo({ url: '/pages/order-detail/index?id=' + res.id + '&pay=1' })
      })
      .catch(() => {
        this.setData({ submitting: false })
      })
  },

  goShop() {
    wx.switchTab({ url: '/pages/shop/index' })
  },
})
