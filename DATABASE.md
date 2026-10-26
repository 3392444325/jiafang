# 织云 ZHIYUN — 数据库说明文档

> 数据库：MySQL 8（默认库名 `zhiyun`，连接配置见 `DEPLOY.md` 与 `backend\application-local.yml`）
> 表结构由后端 JPA（Hibernate）`ddl-auto: update` 在应用启动时**自动创建/更新**，
> 无需手工执行 SQL 脚本。本文档与 `backend\src\main\java\com\zhiyun\entity\` 下的实体类一一对应。

## 一、总体说明



| 约定 | 说明 |
| --- | --- |
| 主键 `id` | 所有表主键为 30 位以内的字符串（Cuid 算法生成，应用层生成，非自增） |
| 金额字段 | 一律以**分**为单位存整数（`*_fen`），如 `219900` = ¥2199.00，避免浮点误差 |
| 时间字段 | `*_at`，DATETIME（东八区） |
| 外键 | 通过 `@ManyToOne` 声明关联（如 `orders.user_id` → `users.id`），删除用户时级联清理其地址/订单/购物车/会话/评价 |
| 字符集 | utf8mb4 |

## 二、表关系总览（ER）

```
users ─┬─< addresses            （1个用户多个收货地址）
       ├─< orders ──< order_items >── products
       ├─< cart_items >── products     （游客购物车挂在 sessions 下）
       ├─< sessions ──< cart_items
       └─< reviews >── products

categories ──< products
leads       （独立表，销售线索）
```

- **users**：注册会员与管理员
- **sessions**：登录会话 / 游客会话（购物车归属依据）
- **categories / products**：商品分类与商品
- **cart_items**：购物车条目（登录用户或游客二选一归属）
- **orders / order_items**：订单及订单明细（明细保存下单时的商品快照）
- **addresses**：收货地址簿
- **reviews**：商品评价（限已购买用户，每商品限一次）
- **leads**：官网留资线索（加盟/合作等表单）

## 三、各表各字段详解

###

| 表 | 用途 |
|---|---|
| `users` | 注册会员与管理员（BCrypt 密码哈希） |
| `sessions` | 登录会话/游客会话（Cookie 令牌，30 天有效期） |
| `categories` | 商品分类（中英文名、宣传语、排序） |
| `products` | 商品（价格分、库存、销量、JSON 图片/规格、上下架状态） |
| `cart_items` | 购物车条目（用户/游客双归属，两条唯一约束防重） |
| `addresses` | 收货地址簿（默认地址机制） |
| `orders` | 订单（订单号、状态机、金额、收货信息 JSON 快照） |
| `order_items` | 订单明细（商品名/图/价**快照**，防历史订单被商品修改影响） |
| `reviews` | 商品评价（1~5 星，每用户每商品限一次） |
| `leads` | 留资线索（加盟/团购/合作表单，跟进状态） |

### 1. `users` — 用户表

注册会员与后台管理员账号。密码只存 BCrypt 哈希，不存明文。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| id | varchar(30) | PK | 用户唯一标识（Cuid） |
| email | varchar(128) | UNIQUE, NOT NULL | 登录邮箱（存储前统一转小写） |
| password_hash | varchar(100) | NOT NULL | BCrypt 加密的密码哈希（cost=10） |
| name | varchar(64) | NULL | 用户昵称，如"沈知微" |
| phone | varchar(32) | NULL | 手机号，选填 |
| role | varchar(16) | NOT NULL，默认 `CUSTOMER` | 角色：`CUSTOMER` 顾客 / `ADMIN` 管理员（管理员可访问 /admin 后台） |
| created_at | datetime | NOT NULL | 注册时间 |

### 2. `sessions` — 会话表

登录会话与游客（未登录）购物车会话。浏览器 Cookie `zy_session` 存的就是 `token`。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| id | varchar(30) | PK | 会话唯一标识（购物车通过 `session_id` 关联它） |
| token | varchar(64) | UNIQUE, NOT NULL | 48 位十六进制随机令牌，写入 httpOnly Cookie |
| user_id | varchar(30) | NULL, FK→users.id | **NULL 表示游客会话**；登录/注册后创建的会话填用户 id |
| created_at | datetime | NOT NULL | 创建时间 |
| expires_at | datetime | NOT NULL | 过期时间（创建后 +30 天）；过期会话由后端定时任务每 6 小时自动清理 |

### 3. `categories` — 商品分类表

商城商品分类（被芯、枕芯、床品套件、夏凉、礼盒）。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| id | varchar(30) | PK | 分类唯一标识 |
| slug | varchar(64) | UNIQUE, NOT NULL | URL 标识，如 `duvets`、`gifts` |
| name | varchar(64) | NOT NULL | 中文名，如"被芯" |
| name_en | varchar(128) | NOT NULL | 英文名，如 "Duvets & Comforters" |
| tagline | varchar(128) | NULL | 宣传语，如"云感深睡，四季安然" |
| sort | int | NOT NULL，默认 0 | 展示排序号，越小越靠前 |

### 4. `products` — 商品表

商城在售商品（含价格、库存、图文详情）。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| id | varchar(30) | PK | 商品唯一标识 |
| slug | varchar(64) | UNIQUE, NOT NULL | URL 标识，如 `monet-garden-set`；后台新建商品自动生成 `zy-时间戳36进制` |
| name | varchar(128) | NOT NULL | 商品名 |
| subtitle | varchar(160) | NULL | 副标题（卖点短句） |
| description | TEXT | NOT NULL | 商品描述正文 |
| story | TEXT | NULL | 品牌故事/设计故事段落 |
| price_fen | int | NOT NULL | 现售价（分），如 219900 = ¥2199.00 |
| compare_at_fen | int | NULL | 划线原价（分）；**有值时前台显示"限时礼遇"角标**，NULL 表示无划线价 |
| images | TEXT | NOT NULL | 图片列表，**JSON 数组字符串**，如 `["/images/products/p01.jpg", ...]` |
| material | TEXT | NULL | 材质说明一行文字 |
| specs | TEXT | NULL | 规格参数，**JSON 数组字符串**，元素为 `{label, value}` 对象 |
| featured | tinyint(1) | NOT NULL，默认 false | 是否首页精选推荐 |
| status | varchar(16) | NOT NULL，默认 `ACTIVE` | 状态：`ACTIVE` 上架 / `OFF` 下架（后台"商品开关"切换） |
| stock | int | NOT NULL，默认 999 | 库存数量；下单条件扣减，取消订单回补 |
| sales | int | NOT NULL，默认 0 | 累计销量；下单增加，取消订单回补（不低于 0） |
| category_id | varchar(30) | NOT NULL, FK→categories.id | 所属分类 |
| created_at | datetime | NOT NULL | 创建时间（后台商品列表按此倒序） |

### 5. `cart_items` — 购物车条目表

每个条目 = 某人（用户或游客）对某商品的一次加购。**同一商品同一归属只允许一条记录**（两条唯一约束保证），重复加购合并为数量累加。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| id | varchar(30) | PK | 条目唯一标识 |
| qty | int | NOT NULL，默认 1 | 加购数量（后端限制 1~99） |
| product_id | varchar(30) | NOT NULL, FK→products.id | 加购的商品 |
| user_id | varchar(30) | NULL, FK→users.id | 归属用户；**游客条目为 NULL** |
| session_id | varchar(30) | NULL, FK→sessions.id | 归属游客会话；**登录用户条目为 NULL**；登录/注册时自动把游客条目合并到用户名下并清空此字段 |
| created_at | datetime | NOT NULL | 加入时间（列表按此倒序） |

唯一约束：`uk_cart_product_user(product_id, user_id)`、`uk_cart_product_session(product_id, session_id)`。
用户下单成功后，其名下全部条目被删除。

### 6. `addresses` — 收货地址表

用户的收货地址簿。结算页可勾选"保存为地址"自动写入。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| id | varchar(30) | PK | 地址唯一标识 |
| user_id | varchar(30) | NOT NULL, FK→users.id | 所属用户 |
| name | varchar(64) | NOT NULL | 收件人姓名 |
| phone | varchar(32) | NOT NULL | 联系电话 |
| province | varchar(32) | NOT NULL | 省，如"浙江省" |
| city | varchar(32) | NOT NULL | 市，如"杭州市" |
| district | varchar(32) | NULL | 区/县，选填 |
| detail | varchar(255) | NOT NULL | 详细地址，如"xx路xx号xx小区" |
| is_default | tinyint(1) | NOT NULL，默认 false | 是否默认地址；每个用户至多一条默认（删除默认地址时自动顺延） |
| created_at | datetime | NOT NULL | 创建时间 |

### 7. `orders` — 订单表

用户提交结算后生成，记录订单号、状态、金额、收货信息快照。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| id | varchar(30) | PK | 订单唯一标识（对外 URL 使用，如 /orders/{id}） |
| order_no | varchar(32) | UNIQUE, NOT NULL | 订单号，格式 `ZY20260909142530123-456-1234`（ZY+毫秒时间戳+序列+随机），用于展示与客服检索 |
| status | varchar(24) | NOT NULL，默认 `PENDING_PAYMENT` | 订单状态，见下方状态机 |
| total_fen | int | NOT NULL | 订单总金额（分）= 全部明细 price_fen × qty 之和 |
| user_id | varchar(30) | NOT NULL, FK→users.id | 下单用户（只有登录用户能下单） |
| address_json | TEXT | NOT NULL | 收货信息**快照**，JSON：`{"name","phone","region","detail"}`（下单时刻的地址，之后改地址簿不影响订单） |
| pay_method | varchar(16) | NULL | 支付方式：`WECHAT` 微信 / `ALIPAY` 支付宝 / `CARD` 银行卡（模拟支付） |
| created_at | datetime | NOT NULL | 下单时间 |
| paid_at | datetime | NULL | 支付时间；未支付为 NULL |

**订单状态机**（管理端与支付接口均受此约束，防非法流转）：

```
PENDING_PAYMENT 待付款 ──支付/管理员确认──> PAID 已付款 ──发货──> SHIPPED 已发货 ──收货──> COMPLETED 已完成
        │
        └──取消──> CANCELLED 已取消（回补商品库存与销量）
PAID 也可直接取消（回补库存）；CANCELLED 为终态，不可再流转。
```

### 8. `order_items` — 订单明细表

订单中的每一行商品。**保存下单时刻的商品名/图片/价格快照**，商品之后改名、改价、下架均不影响历史订单。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| id | varchar(30) | PK | 明细唯一标识 |
| order_id | varchar(30) | NOT NULL, FK→orders.id | 所属订单（删除订单时级联删除明细） |
| product_id | varchar(30) | NOT NULL, FK→products.id | 商品 id（用于取消订单回补库存；商品本身可被下架） |
| name_snap | varchar(128) | NOT NULL | 商品名快照（下单时刻） |
| image_snap | varchar(255) | NULL | 首图快照（下单时刻第一张图） |
| price_fen | int | NOT NULL | 成交单价快照（分） |
| qty | int | NOT NULL | 购买数量 |

### 9. `reviews` — 商品评价表

购买过的用户对商品的评价。同一用户对同一商品**只能评价一次**，评分 1~5 星，内容 4~500 字。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| id | varchar(30) | PK | 评价唯一标识 |
| user_id | varchar(30) | NOT NULL, FK→users.id | 评价人 |
| product_id | varchar(30) | NOT NULL, FK→products.id | 被评价的商品 |
| rating | int | NOT NULL | 星级 1~5 |
| content | TEXT | NOT NULL | 评价内容 |
| created_at | datetime | NOT NULL | 评价时间 |

管理员可在后台删除任意评价。

### 10. `leads` — 留资线索表

官网"加盟合作/批发团购"等表单提交的销售线索，供管理员跟进。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| id | varchar(30) | PK | 线索唯一标识 |
| type | varchar(16) | NOT NULL | 线索类型：`FRANCHISE` 招商加盟 / `GROUP_BUY` 团购定制 / `COOPERATION` 商务合作（后端校验，非法值默认为 `COOPERATION`） |
| name | varchar(64) | NOT NULL | 联系人姓名 |
| phone | varchar(32) | NOT NULL | 联系电话 |
| note | TEXT | NULL | 客户留言内容 |
| status | varchar(16) | NOT NULL，默认 `NEW` | 跟进状态：`NEW` 未处理 / `CONTACTED` 已联系 / `CLOSED` 已关闭 |
| created_at | datetime | NOT NULL | 提交时间 |

## 四、种子数据与默认账号

应用首次启动（`categories` 表为空时）自动写入演示数据（见
`backend\src\main\java\com\zhiyun\config\DataInitializer.java`）：

- 5 个分类、12 件商品、若干评价与线索
- 默认管理员：`admin@zhiyun.cn` / `admin123456`（**上线前务必修改密码！**）
- 演示顾客：`demo@zhiyun.cn` / `demo123456`

## 五、运维注意事项

1. **不要手工改表结构**：以实体类为准，改表请改 Entity 后由 `ddl-auto: update` 对齐。
2. **备份**：`mysqldump -u 用户名 -p zhiyun > backup_日期.sql`，建议部署每日定时任务。
3. **订单金额**：如需调整价格，直接改 `products.price_fen`，历史订单金额不受影响（快照机制）。
4. **sessions 表**：过期会话每 6 小时被定时任务自动清理，无需人工干预。
5. **库存为 0 的商品**仍会展示，但无法加购/下单（下单时校验库存）。
