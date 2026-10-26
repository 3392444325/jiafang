/**
 * 环境配置 —— 小程序与后端/官网的地址切换
 *
 * dev（联调）：
 *   - 后端本机 Spring Boot :8082（start.bat 启动）
 *   - 官网前端 Vite :5173（商品/头图等静态图片由官网托管）
 *   - 微信开发者工具需勾选：详情 → 本地设置 → 「不校验合法域名…」
 * prod（上线）：
 *   - 需 HTTPS + 已备案域名，并在小程序后台配置 request 合法域名
 */
const ENV = 'dev'

const CONFIGS = {
  dev: {
    apiBase: 'http://localhost:8082/api', // 后端接口（含 /api/uploads/** 上传图）
    imgApiBase: 'http://localhost:8082', // 后端静态资源根（uploads 图片）
    imgWebBase: 'http://localhost:5173', // 官网静态资源根（/images/** 占位图与商品图）
  },
  prod: {
    apiBase: 'https://your-domain.com/api',
    imgApiBase: 'https://your-domain.com',
    imgWebBase: 'https://your-domain.com',
  },
}

module.exports = { ENV, ...CONFIGS[ENV] }
