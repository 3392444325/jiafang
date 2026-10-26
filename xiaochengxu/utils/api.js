/** 全部后端接口汇总 —— 请求/响应契约以 backend/src/main/java/com/zhiyun/controller 为准 */
const { request } = require('./request')

module.exports = {
  // ============== 商品 / 首页 / 商城 ==============
  getHome: () => request({ path: '/home', silent: true }),
  getShop: () => request({ path: '/shop', silent: true }),
  getProducts: (cat, sort, q) =>
    request({
      path: '/products',
      data: { cat: cat || '', sort: sort || 'default', q: q || '' },
      silent: true,
    }),
  getProduct: (slug) => request({ path: '/products/' + slug, silent: true }),

  // ============== 认证 ==============
  login: (email, password) =>
    request({ path: '/auth/login', method: 'POST', data: { email, password } }),
  register: (email, password, name) =>
    request({ path: '/auth/register', method: 'POST', data: { email, password, name } }),
  me: () => request({ path: '/auth/me', silent: true }),
  logout: () => request({ path: '/auth/logout', method: 'POST' }),

  // ============== 购物车 ==============
  cartCount: () => request({ path: '/cart', silent: true }),
  cartItems: () => request({ path: '/cart/items', silent: true }),
  cartAdd: (productId, qty) =>
    request({ path: '/cart', method: 'POST', data: { productId, qty } }),
  cartUpdate: (id, qty) =>
    request({ path: '/cart/' + id, method: 'PATCH', data: { qty } }),
  cartRemove: (id) => request({ path: '/cart/' + id, method: 'DELETE' }),

  // ============== 收货地址 ==============
  addressList: () => request({ path: '/addresses' }),
  addressCreate: (d) => request({ path: '/addresses', method: 'POST', data: d }),
  addressUpdate: (id, d) =>
    request({ path: '/addresses/' + id, method: 'PUT', data: d }),
  addressSetDefault: (id) => request({ path: '/addresses/' + id, method: 'PATCH' }),
  addressDelete: (id) => request({ path: '/addresses/' + id, method: 'DELETE' }),

  // ============== 订单 ==============
  orderList: () => request({ path: '/orders' }),
  orderCreate: (d) => request({ path: '/orders', method: 'POST', data: d }),
  orderDetail: (id) => request({ path: '/orders/' + id }),
  orderPay: (id, method) =>
    request({ path: '/orders/' + id + '/pay', method: 'POST', data: { method: method || 'WECHAT' } }),
  orderCancel: (id) => request({ path: '/orders/' + id + '/cancel', method: 'POST' }),
  orderCancelRequest: (id) =>
    request({ path: '/orders/' + id + '/cancel-request', method: 'POST' }),

  // ============== 评价 ==============
  reviewSubmit: (productId, rating, content) =>
    request({ path: '/reviews', method: 'POST', data: { productId, rating, content } }),

  // ============== 商机留资 ==============
  leadSubmit: (type, name, phone, note) =>
    request({ path: '/leads', method: 'POST', data: { type, name, phone, note } }),
}
