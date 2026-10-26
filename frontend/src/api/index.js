import axios from 'axios'

// 统一 API 客户端：基于 /api 前缀（vite dev proxy 转发到 http://localhost:8082）
// 所有请求携带 cookie（withCredentials）以维持 session
const http = axios.create({
  baseURL: '/api',
  withCredentials: true,
  timeout: 15000,
})

// 响应拦截：统一提取 error message
http.interceptors.response.use(
  (res) => res.data,
  (err) => {
    const msg = err.response?.data?.error || err.message || '请求失败'
    return Promise.reject(new Error(msg))
  }
)

// ============== 认证 ==============
export const authApi = {
  register: (data) => http.post('/auth/register', data),
  login: (data) => http.post('/auth/login', data),
  logout: () => http.post('/auth/logout'),
  me: () => http.get('/auth/me'),
}

// ============== 商品 / 首页 ==============
export const productApi = {
  home: () => http.get('/home'),
  shop: () => http.get('/shop'),
  products: (params) => http.get('/products', { params }),
  detail: (slug) => http.get(`/products/${slug}`),
}

// ============== 购物车 ==============
export const cartApi = {
  count: () => http.get('/cart'),
  items: () => http.get('/cart/items'),
  add: (productId, qty = 1) => http.post('/cart', { productId, qty }),
  update: (id, qty) => http.patch(`/cart/${id}`, { qty }),
  remove: (id) => http.delete(`/cart/${id}`),
}

// ============== 收货地址 ==============
export const addressApi = {
  list: () => http.get('/addresses'),
  create: (data) => http.post('/addresses', data),
  update: (id, data) => http.put(`/addresses/${id}`, data),
  setDefault: (id) => http.patch(`/addresses/${id}`),
  delete: (id) => http.delete(`/addresses/${id}`),
}

// ============== 订单 ==============
export const orderApi = {
  list: () => http.get('/orders'),
  create: (data) => http.post('/orders', data),
  detail: (id) => http.get(`/orders/${id}`),
  pay: (id, method) => http.post(`/orders/${id}/pay`, { method }),
  cancel: (id) => http.post(`/orders/${id}/cancel`),
  requestCancel: (id) => http.post(`/orders/${id}/cancel-request`),
}

// ============== 评价 ==============
export const reviewApi = {
  submit: (data) => http.post('/reviews', data),
}

// ============== 商机线索 ==============
export const leadApi = {
  submit: (data) => http.post('/leads', data),
}

// ============== 品牌官网内容（公开） ==============
export const contentApi = {
  all: () => http.get('/content'), // { content: {...site_content}, news: [已发布文章] }
  newsDetail: (id) => http.get(`/news/${id}`),
}

// ============== 页面设计后台（独立入口 /designer） ==============
export const designerApi = {
  content: () => http.get('/designer/content'),
  saveContent: (data) => http.post('/designer/content/save', data),
  upload: (file) => {
    const fd = new FormData()
    fd.append('file', file)
    return http.post('/designer/upload', fd, {
      headers: { 'Content-Type': 'multipart/form-data' },
      timeout: 60000,
    })
  },
  products: () => http.get('/designer/products'),
  createProduct: (data) => http.post('/designer/products', data),
  updateProductImages: (id, images) =>
    http.post(`/designer/products/${id}/images`, { images }),
  newsList: () => http.get('/designer/news'),
  newsCreate: (data) => http.post('/designer/news', data),
  newsUpdate: (data) => http.post('/designer/news/update', data),
  newsDelete: (id) => http.post('/designer/news/delete', { id }),
}

// ============== 后台管理 ==============
export const adminApi = {
  dashboard: () => http.get('/admin/dashboard'),
  products: () => http.get('/admin/products'),
  productForEdit: (id) => http.get(`/admin/products/${id}`),
  toggleProduct: (id) => http.post('/admin/products/toggle', { id }),
  updateStock: (id, stock) => http.post('/admin/products/stock', { id, stock }),
  createProduct: (data) => http.post('/admin/products/create', data),
  updateProduct: (data) => http.post('/admin/products/update', data),
  createCategory: (data) => http.post('/admin/categories/create', data),
  orders: (params) => http.get('/admin/orders', { params }),
  updateOrderStatus: (id, status) => http.post('/admin/orders/status', { id, status }),
  approveCancel: (id) => http.post('/admin/orders/cancel-approve', { id }),
  rejectCancel: (id) => http.post('/admin/orders/cancel-reject', { id }),
  exportOrdersCsv: () =>
    http.get('/admin/orders/export', { responseType: 'blob' }),
  customers: () => http.get('/admin/customers'),
  reviews: () => http.get('/admin/reviews'),
  deleteReview: (id) => http.post('/admin/reviews/delete', { id }),
  leads: () => http.get('/admin/leads'),
  updateLeadStatus: (id, status) => http.post('/admin/leads/status', { id, status }),
}

export default http
