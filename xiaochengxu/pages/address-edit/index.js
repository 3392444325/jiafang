const api = require('../../utils/api')

/** 新增 / 编辑收货地址：编辑模式通过 URL 参数预填 */
Page({
  data: {
    isEdit: false,
    name: '',
    phone: '',
    province: '',
    city: '',
    district: '',
    detail: '',
    isDefault: false,
    saving: false,
  },

  onLoad(options) {
    if (options.id) {
      this._id = options.id
      const d = (v) => (v === undefined ? '' : decodeURIComponent(v))
      this.setData({
        isEdit: true,
        name: d(options.name),
        phone: d(options.phone),
        province: d(options.province),
        city: d(options.city),
        district: d(options.district),
        detail: d(options.detail),
      })
      wx.setNavigationBarTitle({ title: '编辑地址' })
    }
  },

  onInput(e) {
    this.setData({ [e.currentTarget.dataset.k]: e.detail.value })
  },

  onDefaultChange(e) {
    this.setData({ isDefault: e.detail.value })
  },

  save() {
    if (this.data.saving) return
    const d = this.data
    if (!d.name.trim()) {
      wx.showToast({ title: '请输入联系人', icon: 'none' })
      return
    }
    if (!/^1\d{10}$/.test(d.phone.trim())) {
      wx.showToast({ title: '请输入 11 位手机号', icon: 'none' })
      return
    }
    if (!d.province.trim()) {
      wx.showToast({ title: '请输入省份', icon: 'none' })
      return
    }
    if (!d.city.trim()) {
      wx.showToast({ title: '请输入城市', icon: 'none' })
      return
    }
    if (!d.detail.trim()) {
      wx.showToast({ title: '请输入详细地址', icon: 'none' })
      return
    }
    const body = {
      name: d.name.trim(),
      phone: d.phone.trim(),
      province: d.province.trim(),
      city: d.city.trim(),
      district: d.district.trim(),
      detail: d.detail.trim(),
    }
    this.setData({ saving: true })
    const req = d.isEdit
      ? api.addressUpdate(this._id, body)
      : api.addressCreate(Object.assign({ isDefault: d.isDefault }, body))
    req
      .then(() => {
        wx.showToast({ title: '已保存', icon: 'success' })
        setTimeout(() => wx.navigateBack(), 600)
      })
      .catch(() => {
        this.setData({ saving: false })
      })
  },
})
