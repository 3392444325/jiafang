/** 图片地址解析：后端上传图 / 官网静态图 / 完整 URL 统一转为可访问地址 */
const { imgApiBase, imgWebBase } = require('../config/env')

function resolveImg(url, fallback) {
  if (!url) return fallback || ''
  if (/^https?:\/\//.test(url)) return url
  if (url.indexOf('/api/uploads/') === 0) return imgApiBase + url
  if (url.indexOf('/') === 0) return imgWebBase + url
  return url
}

module.exports = { resolveImg }
