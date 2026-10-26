const api = require('../../utils/api')

const PAGE_SIZE = 10
const SORTS = [
  { key: 'default', label: '综合' },
  { key: 'price-asc', label: '价格↑' },
  { key: 'price-desc', label: '价格↓' },
  { key: 'sales', label: '销量' },
]

/** 商城：搜索 + 分类筛选 + 排序 + 两列网格（客户端分页，触底加载更多） */
Page({
  data: {
    q: '',
    cat: '',
    sort: 'default',
    sorts: SORTS,
    categories: [],
    shown: [],
    total: 0,
    hasMore: false,
    loading: false,
    loaded: false,
  },

  onLoad(options) {
    this._all = []
    this._page = 1
    this.setData({
      cat: options.cat || '',
      q: options.q || '',
      focus: !!options.focus,
    })
    this.loadCategories()
    this.load()
  },

  onShow() {
    getApp().refreshCartBadge()
  },

  onPullDownRefresh() {
    this._page = 1
    this.load().then(() => wx.stopPullDownRefresh())
  },

  onReachBottom() {
    if (!this.data.hasMore || this.data.loading) return
    this._page += 1
    this.appendPage()
  },

  loadCategories() {
    api.getShop().then((res) => {
      this.setData({
        categories: [{ slug: '', name: '全部' }].concat(
          (res.categories || []).map((c) => ({ slug: c.slug, name: c.name }))
        ),
      })
    }).catch(() => {})
  },

  load() {
    this.setData({ loading: true })
    return api
      .getProducts(this.data.cat, this.data.sort, this.data.q)
      .then((res) => {
        this._all = res.cards || []
        this._page = 1
        this.setData({ loading: false, loaded: true })
        this.applyPage()
      })
      .catch(() => {
        this.setData({ loading: false, loaded: true })
      })
  },

  applyPage() {
    const end = this._page * PAGE_SIZE
    this.setData({
      shown: this._all.slice(0, end),
      total: this._all.length,
      hasMore: end < this._all.length,
    })
  },

  appendPage() {
    this.applyPage()
  },

  onSearchInput(e) {
    this.setData({ q: e.detail.value })
  },

  onSearchConfirm() {
    this._page = 1
    this.load()
  },

  pickCat(e) {
    this.setData({ cat: e.currentTarget.dataset.slug })
    this._page = 1
    this.load()
  },

  pickSort(e) {
    this.setData({ sort: e.currentTarget.dataset.key })
    this._page = 1
    this.load()
  },
})
