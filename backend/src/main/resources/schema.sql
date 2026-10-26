-- =====================================================================
-- 织云 ZHIYUN LIVING - MySQL 建表脚本（参考用）
-- 推荐方式：直接启动 Spring Boot 后端，Hibernate 会自动建表
-- 此脚本用于手动建表 / 数据库迁移 / DBA 审阅
-- 数据库：ST_KELLIY (CREATE DATABASE IF NOT EXISTS ST_KELLIY)
-- 字符集：utf8mb4
-- =====================================================================

CREATE DATABASE IF NOT EXISTS ST_KELLIY DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ST_KELLIY;

-- ---------------------------------------------------------------------
-- 用户表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id            VARCHAR(30)  NOT NULL,
    email         VARCHAR(128) NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    name          VARCHAR(64),
    phone         VARCHAR(32),
    role          VARCHAR(16)  NOT NULL DEFAULT 'CUSTOMER',
    created_at    DATETIME     NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 会话表（Session Cookie 登录态）
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sessions (
    id         VARCHAR(30) NOT NULL,
    token      VARCHAR(64) NOT NULL,
    user_id    VARCHAR(30),
    created_at DATETIME    NOT NULL,
    expires_at DATETIME    NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_sessions_token (token),
    KEY idx_sessions_user (user_id),
    CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 商品分类
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
    id       VARCHAR(30)  NOT NULL,
    slug     VARCHAR(64)  NOT NULL,
    name     VARCHAR(64)  NOT NULL,
    name_en  VARCHAR(128) NOT NULL,
    tagline  VARCHAR(128),
    sort     INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_categories_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 商品
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
    id             VARCHAR(30)  NOT NULL,
    slug           VARCHAR(64)  NOT NULL,
    name           VARCHAR(128) NOT NULL,
    subtitle       VARCHAR(160),
    description    TEXT         NOT NULL,
    story          TEXT,
    price_fen      INT          NOT NULL,
    compare_at_fen INT,
    images         TEXT         NOT NULL,
    material       TEXT,
    specs          TEXT,
    featured       BOOLEAN      NOT NULL DEFAULT FALSE,
    status         VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE',
    stock          INT          NOT NULL DEFAULT 999,
    sales          INT          NOT NULL DEFAULT 0,
    category_id    VARCHAR(30)  NOT NULL,
    created_at     DATETIME     NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_products_slug (slug),
    KEY idx_products_category (category_id),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 购物车条目（可归属于登录用户或游客 session）
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cart_items (
    id         VARCHAR(30) NOT NULL,
    qty        INT          NOT NULL DEFAULT 1,
    product_id VARCHAR(30) NOT NULL,
    user_id    VARCHAR(30),
    session_id VARCHAR(30),
    created_at DATETIME    NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_cart_product_user (product_id, user_id),
    UNIQUE KEY uk_cart_product_session (product_id, session_id),
    KEY idx_cart_user (user_id),
    KEY idx_cart_session (session_id),
    CONSTRAINT fk_cart_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_user    FOREIGN KEY (user_id)    REFERENCES users (id)     ON DELETE CASCADE,
    CONSTRAINT fk_cart_session FOREIGN KEY (session_id) REFERENCES sessions (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 收货地址
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS addresses (
    id         VARCHAR(30) NOT NULL,
    user_id    VARCHAR(30) NOT NULL,
    name       VARCHAR(64) NOT NULL,
    phone      VARCHAR(32) NOT NULL,
    province   VARCHAR(64) NOT NULL,
    city       VARCHAR(64) NOT NULL,
    district   VARCHAR(64),
    detail     VARCHAR(255) NOT NULL,
    is_default BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at DATETIME     NOT NULL,
    PRIMARY KEY (id),
    KEY idx_addresses_user (user_id),
    CONSTRAINT fk_addresses_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 订单
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
    id           VARCHAR(30) NOT NULL,
    order_no     VARCHAR(32) NOT NULL,
    status       VARCHAR(24) NOT NULL DEFAULT 'PENDING_PAYMENT',
    total_fen    INT          NOT NULL,
    user_id      VARCHAR(30) NOT NULL,
    address_json TEXT         NOT NULL,
    pay_method   VARCHAR(16),
    created_at   DATETIME     NOT NULL,
    paid_at      DATETIME,
    PRIMARY KEY (id),
    UNIQUE KEY uk_orders_no (order_no),
    KEY idx_orders_user (user_id),
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 订单条目
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS order_items (
    id         VARCHAR(30) NOT NULL,
    order_id   VARCHAR(30) NOT NULL,
    product_id VARCHAR(30) NOT NULL,
    name_snap  VARCHAR(128) NOT NULL,
    image_snap VARCHAR(255),
    price_fen  INT          NOT NULL,
    qty        INT          NOT NULL,
    PRIMARY KEY (id),
    KEY idx_order_items_order (order_id),
    KEY idx_order_items_product (product_id),
    CONSTRAINT fk_oi_order   FOREIGN KEY (order_id)   REFERENCES orders (id)   ON DELETE CASCADE,
    CONSTRAINT fk_oi_product FOREIGN KEY (product_id) REFERENCES products (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 评价
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reviews (
    id         VARCHAR(30) NOT NULL,
    user_id    VARCHAR(30) NOT NULL,
    product_id VARCHAR(30) NOT NULL,
    rating     INT          NOT NULL,
    content    TEXT         NOT NULL,
    created_at DATETIME     NOT NULL,
    PRIMARY KEY (id),
    KEY idx_reviews_user (user_id),
    KEY idx_reviews_product (product_id),
    CONSTRAINT fk_reviews_user    FOREIGN KEY (user_id)    REFERENCES users (id),
    CONSTRAINT fk_reviews_product FOREIGN KEY (product_id) REFERENCES products (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 商机线索
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS leads (
    id         VARCHAR(30) NOT NULL,
    type       VARCHAR(16) NOT NULL,
    name       VARCHAR(64) NOT NULL,
    phone      VARCHAR(32) NOT NULL,
    note       TEXT,
    status     VARCHAR(16) NOT NULL DEFAULT 'NEW',
    created_at DATETIME    NOT NULL,
    PRIMARY KEY (id),
    KEY idx_leads_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
