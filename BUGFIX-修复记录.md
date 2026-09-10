# Bug 修复记录

> 项目：织云 ZHIYUN LIVING 电商系统
> 说明：本项目每次修复 bug 后，修复报告按时间顺序追加到本文档，便于追溯。

## 修复记录索引

| 编号 | 日期 | 问题摘要 | 涉及模块 |
| --- | --- | --- | --- |
| #001 | 2026-09-09 | 登录/注册后购物车条目丢失、登出后角标不消失 | 后端 AuthService/Session 实体、前端 auth/cart store |
| #002 | 2026-09-09 | 登录状态下刷新受保护页面被踢回登录页 | 前端 router/index.js 路由守卫 |
| #003 | 2026-09-09 | 导航栏点击后无"当前页"高亮反馈，按钮不突出 | 前端 SiteHeader.vue（含 Tailwind important 语法修正） |

---

## #001 登录/注册后购物车条目丢失、登出后角标不消失

> 日期：2026-09-09
> 涉及模块：后端 AuthService / Session 实体、前端 auth store / cart store

### 一、问题描述

用户报告了两个现象：

| 编号 | 现象 | 触发路径 |
| --- | --- | --- |
| Bug 1 | 登录后看不到以前添加的购物车（角标数量不变，条目丢失） | 游客加购 → 登录/注册 |
| Bug 2 | 退出登录后，购物车角标上的数字不消失 | 登录状态加购 → 退出登录 |

### 二、排查过程

#### 2.1 排查思路

1. 梳理购物车归属模型：`cart_items` 表采用"用户 / 游客会话"双归属设计（`user_id` 与 `session_id` 二选一）。
2. 核对后端登录逻辑：发现 `AuthService.login()` 已实现游客购物车合并（`mergeGuestCart`），理论上数据不应丢失。
3. 使用 curl 模拟完整流程（游客加购 → 注册 → 查购物车），发现**合并流程执行了，但条目仍然消失**。
4. 开启 Hibernate SQL 日志（`org.hibernate.SQL: debug` + `org.hibernate.orm.jdbc.bind: trace`）追踪注册事务中实际执行的 SQL。

#### 2.2 关键 SQL 证据

注册事务中实际执行的 SQL 顺序如下：

```
1. select cart_items  where session_id = 游客会话ID      ← 合并：查出游客条目
2. select cart_items  where product_id=? and user_id=?   ← 合并：检查用户名下是否已有同商品
3. select cart_items  where session_id = 游客会话ID      ← ★ 删会话触发的级联加载
4. insert sessions                                        ← 为登录用户创建新会话
5. delete cart_items  where id = 条目ID                   ← ★ 刚合并的条目被删除！
6. delete sessions    where id = 游客会话ID               ← 删除旧游客会话
```

疑点：全程**没有出现 `UPDATE cart_items`**，本应"迁移"的条目反而被 DELETE 了。

#### 2.3 根因定位

检查 `Session` 实体发现：

```java
@OneToMany(mappedBy = "session", cascade = CascadeType.REMOVE)
private List<CartItem> cartItems = new ArrayList<>();
```

**根因链**：

1. 合并逻辑先修改条目归属（`item.setUserId(用户ID); item.setSessionId(null)`），但修改仅停留在持久化上下文中，**尚未刷入数据库**；
2. 随后执行 `sessionRepo.delete(旧游客会话)`；
3. Session 实体上的 `cascade = CascadeType.REMOVE` 触发级联删除，Hibernate 先加载该会话名下所有条目（此时数据库中条目的 `session_id` 仍是旧会话），再逐条 **DELETE**；
4. 结果：刚"迁移"的购物车条目被级联删除，数据永久丢失。

**一句话总结：条目还没落库就被删会话的级联 REMOVE 一起删掉了。**

### 三、修复方案

#### 3.1 后端修改（AuthService.java）

**修改 1：合并后先 flush 再删会话（核心修复）**

```java
private void mergeGuestSessionCart(String userId) {
    String oldToken = readCookie();
    if (oldToken == null) return;
    Session old = sessionRepo.findByToken(oldToken).orElse(null);
    if (old != null && old.getUserId() == null) {
        mergeGuestCart(old.getId(), userId);
        // 必须先 flush：Session.cartItems 配置了 cascade=REMOVE，
        // 若不先落库（条目 session_id 已置 NULL），删除会话时级联会把刚迁移的条目一并删除
        cartRepo.flush();
        sessionRepo.delete(old);
    }
}
```

修复原理：flush 后条目的 `session_id` 已在数据库中置为 NULL，删除会话时的级联加载查不到该条目，因此不会再被误删。

**修改 2：注册流程补齐合并逻辑**

原 `register()` 只创建用户并登录，未合并游客购物车（与数据库设计文档描述不符）。现提取公共方法 `mergeGuestSessionCart(userId)`，登录与注册均调用。

#### 3.2 前端修改（stores/auth.js）

**修改 3：登录/注册成功后刷新购物车**

```js
async login(email, password) {
  const res = await authApi.login({ email, password })
  await this.fetchCurrentUser()
  // 登录成功后后端已合并游客购物车，刷新购物车角标与列表
  const cart = useCartStore()
  await Promise.all([cart.fetchCount(), cart.fetchItems()])
  return res
}
```

原先登录后仅拉取用户信息，不刷新购物车状态，导致角标数量停留在登录前的旧值。

**修改 4：退出登录后重置购物车状态**

```js
async logout() {
  await authApi.logout()
  this.user = null
  // 退出后后端已删除会话并清 Cookie，重置购物车状态
  const cart = useCartStore()
  cart.$reset()
}
```

原先登出仅清空用户信息，`cart.count` / `cart.items` 残留，导致角标数字不消失。

### 四、验证结果

使用 curl 携带 Cookie 模拟完整用户链路，三个场景全部通过：

| 场景 | 操作序列 | 预期 | 实测 |
| --- | --- | --- | --- |
| 场景 1：游客购物车合并 | 游客加购（count=1）→ 注册 → 查购物车 | count=1 | count=1 ✅ |
| 场景 2：登出角标归零 | 登出 → 查购物车 | count=0 | count=0 ✅ |
| 场景 3：历史购物车保留 | 重新登录 → 查购物车 | count=1 | count=1 ✅ |

数据库复核：合并后的条目归属正确（`user_id=用户ID`，`session_id=NULL`）。

### 五、影响范围与注意事项

1. **行为变化**：注册后同样会合并游客购物车（此前会丢失），与产品文档描述对齐。
2. **保持不变**：`Session` 实体上的 `cascade = REMOVE` 未删除——过期会话定时清理、登出清游客会话等场景仍依赖它级联清理孤儿条目。
3. **经验教训**：JPA 中"先修改关联数据、再删除父实体"时，务必注意父实体上的级联策略（`CascadeType.REMOVE` / `orphanRemoval`）。必要时先 `flush()` 使修改落库，或断开关联后再删除父实体。
4. **测试数据**：验证过程中产生的测试账号与条目已全部清理。

---

## #002 登录状态下刷新受保护页面被踢回登录页

> 日期：2026-09-09
> 涉及模块：前端 `router/index.js`（全局前置守卫）+ `App.vue`

### 一、问题描述

已登录用户在浏览器中**硬刷新**受保护页面（`/orders`、`/orders/:id`、`/account/addresses`）会被重定向到登录页；管理员硬刷新 `/admin` 会被弹回首页。⭐ 影响所有带鉴权元信息的路由。

### 二、根因定位

时序竞争问题：

1. 登录态的初始化是**异步**的：`App.vue onMounted` 中调用 `auth.fetchCurrentUser()` 请求 `/api/auth/me`；
2. `router.beforeEach` 是**同步**守卫，直接检查 `auth.isLoggedIn`；
3. 硬刷新时，路由守卫先于 `onMounted` 的 HTTP 响应执行，此时 `auth.user` 还是 `null` → `isLoggedIn === false` → 守卫直接重定向，受影响页面自身的 `await fetchCurrentUser()` 补救逻辑根本执行不到。

### 三、修复方案

**修改：守卫改为 async，首次导航先等登录态就绪（router/index.js）**

```js
// 登录态由 App.vue onMounted 异步拉取 /auth/me 初始化。
// 硬刷新受保护页面时守卫先于 onMounted 执行，此时 user 还是 null，
// 因此首次导航必须先等登录态就绪，否则已登录用户会被误踢回登录页。
let authReady = false

router.beforeEach(async (to) => {
  const auth = useAuthStore()
  if (!authReady) {
    await auth.fetchCurrentUser()
    authReady = true
  }
  if (to.meta.requiresAuth && !auth.isLoggedIn) {
    return { name: 'login', query: { redirect: to.fullPath } }
  }
  if (to.meta.requiresAdmin && !auth.isAdmin) {
    return { name: 'home' }
  }
})
```

要点：

- `authReady` 标志保证 `/auth/me` 只在**首次导航**时 await 一次，后续导航零开销（登录/注册 action 内部会自行更新 user 状态）；
- `fetchCurrentUser()` 内部已 catch 异常并把 user 置 null，未登录用户首次导航不会报错，拦截逻辑不受影响。

### 四、验证结果

浏览器实测（管理员账号 admin@zhiyun.cn）：

| 场景 | 预期 | 实测 |
| --- | --- | --- |
| 登录后进入 /admin | 正常显示后台 | ✅ |
| **硬刷新 /admin**（关键） | 保持后台页面，不被弹回首页 | ✅ |
| **直接导航 /orders**（关键） | 显示订单页，不被踢去 /login | ✅ |

### 五、注意事项

1. 副作用：首次导航会多发一次 `/auth/me` 请求（App.vue onMounted 中仍保留一次），幂等且开销可忽略；如需优化可在 onMounted 中复用守卫的就绪状态。
2. 经验教训：路由守卫中依赖异步初始化的全局状态时，守卫必须 await 状态就绪后再做拦截判断，否则存在"刷新即误判"的时序竞争。

---

## #003 导航栏点击后无"当前页"高亮反馈，按钮不突出

> 日期：2026-09-09
> 涉及模块：前端 `components/SiteHeader.vue`

### 一、问题描述

点击顶部导航栏（如"品牌"）进入对应页面后，导航栏上的按钮没有任何选中反馈——所有按钮颜色一致，用户无法分辨当前所在页面，视觉上也不够精致。

### 二、根因定位

1. **无 active 状态设计**：导航链接统一使用同一个 `navLink` 样式类，没有为"当前页面对应的导航项"定义高亮样式，也没有基于路由的激活判定逻辑。
2. **连带发现的历史隐患**：项目使用 Tailwind CSS **v3.4**，其 important 语法是**前缀** `!text-gold`；而原代码中写的是 `hover:text-gold!`（v4 的后缀语法），属于无效类——深色透明导航态下的 hover 变色其实一直未生效。

### 三、修复方案（SiteHeader.vue）

**修改 1：新增路由激活判定与动态样式函数**

```js
// 导航高亮：判断目标路由是否为当前页面（首页精确匹配，其余按前缀匹配）
function isActive(to) {
  if (to === '/') return route.path === '/'
  return route.path === to || route.path.startsWith(to + '/')
}

const navCls = (to) => {
  const base = `link-underline text-[13px] tracking-[0.2em] transition-colors ${
    solid.value ? 'hover:text-gold-deep' : 'hover:!text-gold'
  }`
  // 当前页对应的导航项：文字变金色 + 下划线常显，突出选中态
  return isActive(to)
    ? `${base} ${solid.value ? 'text-gold-deep' : '!text-gold'} after:w-full`
    : base
}

// 胶囊按钮（品牌官网 / 官方商城）的选中高亮
const pillCls = (to) =>
  `border px-4 py-1.5 text-[12px] tracking-[0.25em] transition-colors ${
    isActive(to) ? 'border-gold text-gold' : 'border-current hover:border-gold hover:text-gold'
  }`
```

**修改 2：全部导航项改用动态高亮**

桌面导航 13 个链接（首页/品牌/动态/招商/团购/合作/人才、商城首页/产品展示/我的订单/地址簿、管理后台、登录注册）及"品牌官网/官方商城"胶囊按钮，统一改为 `navCls(路径)` / `pillCls(路径)`，当前页自动高亮。

高亮效果：
- **浅色实底态**（滚动后/非覆盖页）：文字变金棕色 `text-gold-deep` + 下划线常显
- **深色透明态**（首页/品牌页顶部大图上）：文字变金色 `!text-gold` + 下划线常显
- 胶囊按钮：边框与文字变金 `border-gold text-gold`

**修改 3：修正 Tailwind v3 important 语法**

`hover:text-gold!` → `hover:!text-gold`（v3 语法为前缀 `!`，原后缀写法无效）。

### 四、验证结果

浏览器实测三种状态全部通过：

| 场景 | 预期 | 实测 |
| --- | --- | --- |
| 首页导航"首页" | 金色 + 下划线，其余白色 | ✅ rgb(179,155,107) |
| 品牌页顶部深色大图上"品牌" | 金色 + 下划线 | ✅ |
| 品牌页滚动后（米白底）"品牌" | 保持金棕色高亮 | ✅ rgb(143,122,80) |

### 五、注意事项

1. "官方商城"/"品牌官网"胶囊按钮的选中态在视觉上不可见——点击后导航整体切换为另一组子导航（`isShop` 分支），按钮本身不再渲染，属设计使然，非缺陷。
2. 激活判定规则：首页 `/` 精确匹配；其余路由按前缀匹配（如 `/orders` 覆盖 `/orders/:id`），与导航语义一致。
3. 经验教训：Tailwind v3 与 v4 的 important 语法不同（v3 前缀 `!` / v4 后缀 `!`），混用会导致类静默失效，需以项目实际版本为准。
