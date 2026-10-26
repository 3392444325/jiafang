const api = require('../../utils/api')

const TYPES = [
  { key: 'FRANCHISE', label: '招商加盟', desc: '加入ST.KELLY，共享睡眠经济红利' },
  { key: 'GROUP_BUY', label: '团购定制', desc: '团购 / 企业福利 / 礼品定制' },
  { key: 'COOPERATION', label: '商务合作', desc: '渠道 / 品牌 / 空间合作' },
]

/** 意向登记：招商加盟 / 团购定制 / 商务合作 留资 */
Page({
  data: {
    types: TYPES,
    type: 'FRANCHISE',
    name: '',
    phone: '',
    note: '',
    busy: false,
  },

  pickType(e) {
    this.setData({ type: e.currentTarget.dataset.key })
  },

  onInput(e) {
    this.setData({ [e.currentTarget.dataset.k]: e.detail.value })
  },

  submit() {
    if (this.data.busy) return
    const name = this.data.name.trim()
    const phone = this.data.phone.trim()
    if (!name) {
      wx.showToast({ title: '请输入姓名', icon: 'none' })
      return
    }
    if (!/^1\d{10}$/.test(phone)) {
      wx.showToast({ title: '请输入 11 位手机号', icon: 'none' })
      return
    }
    this.setData({ busy: true })
    api
      .leadSubmit(this.data.type, name, phone, this.data.note.trim())
      .then(() => {
        this.setData({ busy: false })
        wx.showModal({
          title: '登记成功',
          content: '已收到您的登记，顾问将在 1 个工作日内联系您',
          showCancel: false,
          confirmText: '知道了',
          success: () => {
            this.setData({ name: '', phone: '', note: '' })
          },
        })
      })
      .catch(() => {
        this.setData({ busy: false })
      })
  },
})
