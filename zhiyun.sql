/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80046 (8.0.46)
 Source Host           : localhost:3306
 Source Schema         : zhiyun

 Target Server Type    : MySQL
 Target Server Version : 80046 (8.0.46)
 File Encoding         : 65001

 Date: 07/10/2026 16:40:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for addresses
-- ----------------------------
DROP TABLE IF EXISTS `addresses`;
CREATE TABLE `addresses`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `city` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `district` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_default` bit(1) NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `province` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK1fa36y2oqhao3wgg2rw1pi459`(`user_id` ASC) USING BTREE,
  CONSTRAINT `FK1fa36y2oqhao3wgg2rw1pi459` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of addresses
-- ----------------------------
INSERT INTO `addresses` VALUES ('cmts59os75yTpHyzqptkkaQJ', '杭州市', '2026-09-08 12:03:20.887000', '天目山路织云里 8 幢 1201 室', '西湖区', b'1', '沈知微', '13800006666', '浙江省', 'cmts59ogzCppiSfx7fHWfzqL');

-- ----------------------------
-- Table structure for cart_items
-- ----------------------------
DROP TABLE IF EXISTS `cart_items`;
CREATE TABLE `cart_items`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `product_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `qty` int NOT NULL,
  `session_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `user_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_cart_product_user`(`product_id` ASC, `user_id` ASC) USING BTREE,
  UNIQUE INDEX `uk_cart_product_session`(`product_id` ASC, `session_id` ASC) USING BTREE,
  INDEX `FKfi06hnfi6os4n219jxwyw30g2`(`session_id` ASC) USING BTREE,
  INDEX `FK709eickf3kc0dujx3ub9i7btf`(`user_id` ASC) USING BTREE,
  CONSTRAINT `FK1re40cjegsfvw58xrkdp6bac6` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK709eickf3kc0dujx3ub9i7btf` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKfi06hnfi6os4n219jxwyw30g2` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart_items
-- ----------------------------
INSERT INTO `cart_items` VALUES ('cmttgje4svJnDB2FzB8Fvubc', '2026-09-09 10:06:35.596000', 'cmts59odc8pHkdcUZqo0kgFO', 4, NULL, 'cmttgje3i8vetTGMn8FrZjY4');
INSERT INTO `cart_items` VALUES ('cmuxs5bwyOJ7WliXxciER2VR', '2026-10-07 15:22:21.970000', 'cmttjtaqqX0a0a6P081E7WkW', 2, 'cmuxs5bwibRpfRmcbetNmc9V', NULL);

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name_en` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `slug` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort` int NOT NULL,
  `tagline` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UKoul14ho7bctbefv8jywp5v3i2`(`slug` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES ('cmts59oa7vLEFbUzgyRef02p', '被芯', 'Duvets & Comforters', 'duvets', 1, '云感深睡，四季安然');
INSERT INTO `categories` VALUES ('cmts59ob7ABu6nw14q4tzfBq', '枕芯', 'Pillows', 'pillows', 2, '承托之道，一夜安眠');
INSERT INTO `categories` VALUES ('cmts59obdh9rjtHmXOUWg1wU', '床品套件', 'Bedding Sets', 'bedding-sets', 3, '肌肤的第二层触感');
INSERT INTO `categories` VALUES ('cmts59obiyxgwLiF0WWBQcGW', '夏凉系列', 'Summer Series', 'summer', 4, '清风入梦，凉而不冰');
INSERT INTO `categories` VALUES ('cmts59oblOt8HyGkwqZH36QX', '礼盒系列', 'Gift Boxes', 'gifts', 5, '以东方之礼，赠重要之人');

-- ----------------------------
-- Table structure for leads
-- ----------------------------
DROP TABLE IF EXISTS `leads`;
CREATE TABLE `leads`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of leads
-- ----------------------------
INSERT INTO `leads` VALUES ('cmts59otqhf4HAGz0fvvAFc4', '2026-09-08 12:03:20.942000', '陈立寒', '意向杭州西湖区门店，面积约 80㎡，预算 30–50 万', '13900001111', 'NEW', 'FRANCHISE');
INSERT INTO `leads` VALUES ('cmts59otuJc9rvnZagGGyoY0', '2026-09-08 12:03:20.946000', '林晓鸥', '公司年会采购 40 套枕芯，希望一个月内交付', '13700002222', 'CONTACTED', 'GROUP_BUY');
INSERT INTO `leads` VALUES ('cmts59otyQHoZfCbrEQPhDz1', '2026-09-08 12:03:20.950000', '郑屿舟', '拟洽谈酒店渠道供应链合作', '13600003333', 'CLOSED', 'COOPERATION');
INSERT INTO `leads` VALUES ('cmuqqf1gbWmkvb94Z2gNXVdh', '2026-10-02 16:59:32.507000', '限流测试-可删除', '接口限流功能验证数据，可忽略', '13800000000', 'NEW', 'COOPERATION');
INSERT INTO `leads` VALUES ('cmuqqf1i8nUOXRb97VdT9vBv', '2026-10-02 16:59:32.576000', '限流测试-可删除', '接口限流功能验证数据，可忽略', '13800000000', 'NEW', 'COOPERATION');
INSERT INTO `leads` VALUES ('cmuqqf1kxN1X6k8gPvdB1Fvk', '2026-10-02 16:59:32.673000', '限流测试-可删除', '接口限流功能验证数据，可忽略', '13800000000', 'NEW', 'COOPERATION');
INSERT INTO `leads` VALUES ('cmuqqf1o37BSJ5FCEN9SuqTW', '2026-10-02 16:59:32.787000', '限流测试-可删除', '接口限流功能验证数据，可忽略', '13800000000', 'NEW', 'COOPERATION');
INSERT INTO `leads` VALUES ('cmuqqf1rjwDFY5MuLz2WA14K', '2026-10-02 16:59:32.911000', '限流测试-可删除', '接口限流功能验证数据，可忽略', '13800000000', 'NEW', 'COOPERATION');
INSERT INTO `leads` VALUES ('cmuxs3ol0Ujns2ByJFuQEvdO', '2026-10-07 15:21:05.076000', '联调测试', '小程序链路验证', '13800001111', 'NEW', 'FRANCHISE');
INSERT INTO `leads` VALUES ('cmuxs4ltg1LMKMsEbmJcJtXx', '2026-10-07 15:21:48.148000', '联调测试', '小程序链路验证', '13800001111', 'NEW', 'FRANCHISE');

-- ----------------------------
-- Table structure for news
-- ----------------------------
DROP TABLE IF EXISTS `news`;
CREATE TABLE `news`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `category` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `excerpt` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `featured` bit(1) NOT NULL,
  `published` bit(1) NOT NULL,
  `published_at` datetime(6) NULL DEFAULT NULL,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of news
-- ----------------------------
INSERT INTO `news` VALUES ('cmuscl18x3QOsX4EgPUmG63X', '新品发布', '延续与前 GUCCI 印花设计总监的联名合作，第二季以《睡莲·黄昏》为灵感，新增四组暮金色号与十六色渐变直喷工艺，全球限量 3,000 套，每套附艺术家签名编号。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。', '/images/heroes/hero-3.jpg', '2026-08-28 00:00:00.000000', '延续与前 GUCCI 印花设计总监的联名合作，第二季以《睡莲·黄昏》为灵感，新增四组暮金色号与十六色渐变直喷工艺，全球限量 3,000 套，每套附艺术家签名编号。', b'1', b'1', '2026-08-28 00:00:00.000000', '「莫奈花园」第二季上市：把睡莲的黄昏，织进一套四件套');
INSERT INTO `news` VALUES ('cmuscl1axlk4uqqFMVzDHF9v', '品牌新闻', '双方将在未来三年推出四季联名系列，并联合设立「东方织造印花实验室」。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。', NULL, '2026-08-10 00:00:00.000000', '双方将在未来三年推出四季联名系列，并联合设立「东方织造印花实验室」。', b'0', b'1', '2026-08-10 00:00:00.000000', '织云与前 GUCCI 印花设计总监完成三年续约');
INSERT INTO `news` VALUES ('cmuscl1bbN2pwlXRUJD1gZd1', '媒体报道', '评审团评价：「云绒」系列以 95 白鹅绒与 27 项原材检测，重新定义了国产高端被芯的标尺。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。', NULL, '2026-07-20 00:00:00.000000', '评审团评价：「云绒」系列以 95 白鹅绒与 27 项原材检测，重新定义了国产高端被芯的标尺。', b'0', b'1', '2026-07-20 00:00:00.000000', '《时尚家居》年度榜单：织云蝉联「年度鹅绒被」');
INSERT INTO `news` VALUES ('cmuscl1bnfzqNPvDAxeZHDRf', '活动回顾', '织云联合睡眠研究机构发布《城市深睡白皮书》，并预告「深睡 2.0」系列。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。', NULL, '2026-06-18 00:00:00.000000', '织云联合睡眠研究机构发布《城市深睡白皮书》，并预告「深睡 2.0」系列。', b'0', b'1', '2026-06-18 00:00:00.000000', '世界睡眠日·深睡论坛在杭州西子湖畔举办');
INSERT INTO `news` VALUES ('cmuscl1byYVhD3C587rrLgcm', '品牌新闻', '新店以「东方织造美术馆」为概念，陈列 38 年来 12 件典藏织品。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。', NULL, '2026-05-30 00:00:00.000000', '新店以「东方织造美术馆」为概念，陈列 38 年来 12 件典藏织品。', b'0', b'1', '2026-05-30 00:00:00.000000', '全国第 1,200 家门店落地成都 IFS');
INSERT INTO `news` VALUES ('cmuscl1c7mM0NWDREru2G7Zf', '新品发布', '全新兰精天丝 500 织法，接触瞬凉 1.8℃，凉而不冰。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。', NULL, '2026-04-12 00:00:00.000000', '全新兰精天丝 500 织法，接触瞬凉 1.8℃，凉而不冰。', b'0', b'1', '2026-04-12 00:00:00.000000', '「青岚」天丝夏凉系列全新升级');
INSERT INTO `news` VALUES ('cmuscl1cjDTNBbIAazX5Y3ar', '媒体报道', '镜头深入织云工坊，记录一道被芯从绒朵到成品的完整旅程。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。', NULL, '2026-03-08 00:00:00.000000', '镜头深入织云工坊，记录一道被芯从绒朵到成品的完整旅程。', b'0', b'1', '2026-03-08 00:00:00.000000', '央视《大国匠心》专题记录：43 道工序的织造');
INSERT INTO `news` VALUES ('cmuscl1csuvPhUhXcxtHYSHR', '品牌新闻', '原材可追溯率提升至 86%，循环再生计划全年回收旧被 4.2 万床。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。', NULL, '2026-01-15 00:00:00.000000', '原材可追溯率提升至 86%，循环再生计划全年回收旧被 4.2 万床。', b'0', b'1', '2026-01-15 00:00:00.000000', '织云发布《2025 可持续发展报告》');

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `image_snap` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `name_snap` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `price_fen` int NOT NULL,
  `product_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `qty` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FKbioxgbv59vetrxe0ejfubep1w`(`order_id` ASC) USING BTREE,
  INDEX `FKocimc7dtr037rh4ls4l95nlfi`(`product_id` ASC) USING BTREE,
  CONSTRAINT `FKbioxgbv59vetrxe0ejfubep1w` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKocimc7dtr037rh4ls4l95nlfi` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_items
-- ----------------------------
INSERT INTO `order_items` VALUES ('cmts59ot94oFFnovRYZOERO6', '/images/products/p01.jpg', '「云绒」95白鹅绒被', 'cmts59ot5CfHtFgrayZlAKF7', 299900, 'cmts59oc2El3OVZEX5rsoXkl', 1);
INSERT INTO `order_items` VALUES ('cmts59otdxF4DlcNHTuK3E0u', '/images/products/p04.jpg', '「云朵」零压枕', 'cmts59ot5CfHtFgrayZlAKF7', 39900, 'cmts59ocgmIQavgFpqOxBEMA', 1);
INSERT INTO `order_items` VALUES ('cmts59otmLKNxdcs4lIHEd4Y', '/images/products/p05.jpg', '「暮金」60支长绒棉四件套', 'cmts59oticOSWAoQJ8pAaAQ9', 129900, 'cmts59ockPbo4qDvLM2SAIjS', 1);
INSERT INTO `order_items` VALUES ('cmtthh9yx2145RlhwyXhrWA7', '/images/products/p12.jpg', '「暖山」澳洲羊毛冬被', 'cmtthh9yvgHmJwZUFyatHxbG', 249900, 'cmts59odc8pHkdcUZqo0kgFO', 2);
INSERT INTO `order_items` VALUES ('cmtthha4b6tbIDMrCN7DnaLA', '/images/products/p12.jpg', '「暖山」澳洲羊毛冬被', 'cmtthha4akTYV7g1UiCfn0uh', 249900, 'cmts59odc8pHkdcUZqo0kgFO', 1);
INSERT INTO `order_items` VALUES ('cmttjukagh1DUIvTdsi9Tdy9', '/images/products/p01.jpg', '高级床垫', 'cmttjuka5rb5fw3FjZWBw6G9', 2888800, 'cmttjtaqqX0a0a6P081E7WkW', 1);
INSERT INTO `order_items` VALUES ('cmuxscvnu2by6bTcyNvOnCIK', '/images/products/p01.jpg', '高级床垫', 'cmuxscvntxGuEFqYrTrBfIbD', 2888800, 'cmttjtaqqX0a0a6P081E7WkW', 2);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `paid_at` datetime(6) NULL DEFAULT NULL,
  `pay_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `total_fen` int NOT NULL,
  `user_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cancel_requested` bit(1) NOT NULL,
  `cancel_requested_at` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UKg8pohnngqi5x1nask7nff2u7w`(`order_no` ASC) USING BTREE,
  INDEX `FK32ql8ubntj5uh44ph9659tiih`(`user_id` ASC) USING BTREE,
  CONSTRAINT `FK32ql8ubntj5uh44ph9659tiih` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES ('cmts59ot5CfHtFgrayZlAKF7', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-06 12:03:20.920000', 'ZY20260905-238801', '2026-09-06 12:03:20.920000', 'WECHAT', 'PAID', 339800, 'cmts59ogzCppiSfx7fHWfzqL', b'0', NULL);
INSERT INTO `orders` VALUES ('cmts59oticOSWAoQJ8pAaAQ9', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-08 12:03:20.934000', 'ZY20260906-410927', NULL, NULL, 'PENDING_PAYMENT', 129900, 'cmts59ogzCppiSfx7fHWfzqL', b'0', NULL);
INSERT INTO `orders` VALUES ('cmtsaalchoiKoMBgtPQslM7I', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-08 14:24:01.169000', 'ZY20260908-861146', '2026-09-08 14:24:03.918000', 'WECHAT', 'PAID', 49900, 'cmts59ogzCppiSfx7fHWfzqL', b'0', NULL);
INSERT INTO `orders` VALUES ('cmtsiodyffd9fc8FQ6y5cFuq', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-08 18:18:41.703000', 'ZY20260908-300785', '2026-09-08 18:18:49.035000', 'WECHAT', 'PAID', 388000, 'cmts59ogzCppiSfx7fHWfzqL', b'0', NULL);
INSERT INTO `orders` VALUES ('cmtsiz9xlrsAVJpoPgKpoDDb', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-08 18:27:09.705000', 'ZY20260908-891698', '2026-09-08 18:27:22.264000', 'WECHAT', 'PAID', 49900, 'cmts59ogzCppiSfx7fHWfzqL', b'0', NULL);
INSERT INTO `orders` VALUES ('cmttfunlvAN5OoAbstIwujNE', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-09 09:47:21.480000', 'ZY20260909094721453-001-9401', '2026-09-09 09:47:25.617000', 'WECHAT', 'PAID', 299900, 'cmts59ogzCppiSfx7fHWfzqL', b'0', NULL);
INSERT INTO `orders` VALUES ('cmttgm3r4PqTrACPIOIDlspG', '{\"name\":\"??\",\"phone\":\"13800000000\",\"region\":\"??? ???\",\"detail\":\"????1?\"}', '2026-09-09 10:08:42.112000', 'ZY20260909100842108-001-5703', NULL, NULL, 'CANCELLED', 499800, 'cmttgm3pg018DhXDD3J2RU7N', b'0', NULL);
INSERT INTO `orders` VALUES ('cmttgm3urqyKRK2pAQUXvYZg', '{\"name\":\"??\",\"phone\":\"13800000000\",\"region\":\"??? ???\",\"detail\":\"????1?\"}', '2026-09-09 10:08:42.243000', 'ZY20260909100842243-002-8940', '2026-09-09 10:08:42.263000', 'WECHAT', 'CANCELLED', 249900, 'cmttgm3pg018DhXDD3J2RU7N', b'0', NULL);
INSERT INTO `orders` VALUES ('cmttgm41rqSdghl44GrMeo52', '{\"name\":\"??\",\"phone\":\"13800000000\",\"region\":\"??? ???\",\"detail\":\"????1?\"}', '2026-09-09 10:08:42.495000', 'ZY20260909100842494-003-4703', '2026-09-09 10:08:42.513000', 'ALIPAY', 'PAID', 249900, 'cmttgm3pg018DhXDD3J2RU7N', b'0', NULL);
INSERT INTO `orders` VALUES ('cmttgrvbhCo1TD6ahpWk2gML', '{\"name\":\"dbg\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}', '2026-09-09 10:13:11.118000', 'ZY20260909101311114-001-2758', NULL, NULL, 'CANCELLED', 249900, 'cmttgrv5pmc6AjEjVPRNYLwt', b'0', NULL);
INSERT INTO `orders` VALUES ('cmttgyhdz7BubbTTc2Zb1fjH', '{\"name\":\"dbg2\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}', '2026-09-09 10:18:19.656000', 'ZY20260909101819648-001-3874', NULL, NULL, 'CANCELLED', 499800, 'cmttgyh6tirigxVYeWdepe7R', b'0', NULL);
INSERT INTO `orders` VALUES ('cmttgyhjm02fL8hVUUzQ3rW2', '{\"name\":\"dbg2\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}', '2026-09-09 10:18:19.858000', 'ZY20260909101819856-002-7272', '2026-09-09 10:18:19.906000', 'WECHAT', 'CANCELLED', 249900, 'cmttgyh6tirigxVYeWdepe7R', b'0', NULL);
INSERT INTO `orders` VALUES ('cmtth9kfkXFMGOGSNGHQhI6x', '{\"name\":\"dbg3\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}', '2026-09-09 10:26:56.816000', 'ZY20260909102656813-001-2836', NULL, NULL, 'CANCELLED', 499800, 'cmtth9k80Q3AWxEBpYIFXXoG', b'0', NULL);
INSERT INTO `orders` VALUES ('cmtthh9yvgHmJwZUFyatHxbG', '{\"name\":\"final\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}', '2026-09-09 10:32:56.503000', 'ZY20260909103256498-001-3111', NULL, NULL, 'CANCELLED', 499800, 'cmtthh9rtnfWfOK55CnZvq83', b'0', NULL);
INSERT INTO `orders` VALUES ('cmtthha4akTYV7g1UiCfn0uh', '{\"name\":\"final\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}', '2026-09-09 10:32:56.699000', 'ZY20260909103256698-002-9912', '2026-09-09 10:32:56.736000', 'WECHAT', 'CANCELLED', 249900, 'cmtthh9rtnfWfOK55CnZvq83', b'0', NULL);
INSERT INTO `orders` VALUES ('cmttjuka5rb5fw3FjZWBw6G9', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-09 11:39:15.635000', 'ZY20260909113915599-001-7209', '2026-09-09 11:39:21.744000', 'WECHAT', 'PAID', 2888800, 'cmts59ogzCppiSfx7fHWfzqL', b'0', NULL);
INSERT INTO `orders` VALUES ('cmuxscvntxGuEFqYrTrBfIbD', '{\"name\":\"沈知微\",\"phone\":\"13800001111\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"测试路 1 号\"}', '2026-10-07 15:28:14.153000', 'ZY20261007152814150-001-5107', '2026-10-07 15:28:14.233000', 'WECHAT', 'PAID', 5777600, 'cmts59ogzCppiSfx7fHWfzqL', b'0', NULL);

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `category_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `compare_at_fen` int NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `featured` bit(1) NOT NULL,
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `material` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `price_fen` int NOT NULL,
  `sales` int NOT NULL,
  `slug` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `specs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `stock` int NOT NULL,
  `story` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `subtitle` varchar(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UKostq1ec3toafnjok09y9l7dox`(`slug` ASC) USING BTREE,
  INDEX `FKog2rp4qthbtt2lfyhfo32lsw9`(`category_id` ASC) USING BTREE,
  CONSTRAINT `FKog2rp4qthbtt2lfyhfo32lsw9` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES ('cmts59oc2El3OVZEX5rsoXkl', 'cmts59oa7vLEFbUzgyRef02p', 368000, '2026-09-08 12:03:20.306000', '甄选北纬45°黄金绒带95%白鹅绒，蓬松度800+，如云朵般轻盈包裹。100支全棉防绒面料，静音柔滑，锁温透气兼得。', b'1', '[\"/images/products/p01.jpg\",\"/images/scenes/scene-2.jpg\",\"/images/products/p06.jpg\"]', '填充：95%白鹅绒；面料：100支全棉防绒布', '「云绒」95白鹅绒被', 299900, 1287, 'cloud-goose-down-duvet', '[{\"value\":\"95% 白鹅绒（蓬松度 800+）\",\"label\":\"填充物\"},{\"value\":\"100支全棉防绒面料\",\"label\":\"面料\"},{\"value\":\"冬款约 1100g / 200×230cm\",\"label\":\"克重\"},{\"value\":\"立衬分区 · 五重防钻绒\",\"label\":\"工艺\"}]', 'ACTIVE', 199, '一朵云的重量，约等于一夜安眠。织云走遍东北与西伯利亚绒源地，只为找到那束绒朵饱满、干净无杂的白鹅绒——以28年羽绒工艺，织就这张值得托付终身的被。', '95% 白鹅绒 · 100支防绒棉面料');
INSERT INTO `products` VALUES ('cmts59oc9DjCflo2ehWqwkw5', 'cmts59oa7vLEFbUzgyRef02p', NULL, '2026-09-08 12:03:20.313000', '选用江浙优质蚕区100%桑蚕丝长丝，绵韧贴身、轻盈透气。传统手工定位工艺，丝胎经年不移位，四季皆宜。', b'1', '[\"/images/products/p02.jpg\",\"/images/scenes/scene-1.jpg\"]', '填充：100% 桑蚕丝长丝；面料：60支天丝棉', '「云丝」桑蚕丝长丝被', 388000, 863, 'silk-mulberry-duvet', '[{\"value\":\"100% 桑蚕丝长丝\",\"label\":\"填充物\"},{\"value\":\"60支天丝棉混纺\",\"label\":\"面料\"},{\"value\":\"手工定位 · 丝胎免翻新\",\"label\":\"工艺\"},{\"value\":\"约 2000g / 200×230cm\",\"label\":\"净重\"}]', 'ACTIVE', 149, '一颗茧，可抽丝千米。织云只取一级桑蚕丝长丝，沿袭江南蚕坊手工拉制定位古法——让千年的温柔，落在你枕畔。', '100% 桑蚕丝长丝 · 手工定位');
INSERT INTO `products` VALUES ('cmts59ocdiQElOBzjOF1aMhJ', 'cmts59ob7ABu6nw14q4tzfBq', 59900, '2026-09-08 12:03:20.317000', '三区立体承托设计，仰睡侧睡各得其所；内芯融合托玛琳矿物颗粒，温感自热，促进颈部微循环，抗菌防螨率99%。', b'1', '[\"/images/products/p03.jpg\",\"/images/products/p04.jpg\"]', '内芯：托玛琳复合颗粒 + 高弹纤维；面料：60支抗菌针织棉', '「深睡」托玛琳抗菌枕', 49900, 2303, 'deep-sleep-pillow', '[{\"value\":\"三区承托（侧睡/仰睡/颈椎承托）\",\"label\":\"结构\"},{\"value\":\"温感自热 · 99%抗菌防螨\",\"label\":\"功能\"},{\"value\":\"48×74cm\",\"label\":\"尺寸\"},{\"value\":\"德国红点设计奖获奖系列\",\"label\":\"认证\"}]', 'ACTIVE', 498, '好枕头，是颈椎的年假。织云联合睡眠实验室，历经217次人体工学测试——只为让你入睡的第一分钟，就开始深睡。', '分区承托 · 温感自热');
INSERT INTO `products` VALUES ('cmts59ocgmIQavgFpqOxBEMA', 'cmts59ob7ABu6nw14q4tzfBq', NULL, '2026-09-08 12:03:20.320000', '5秒慢回弹记忆棉，随头颈曲线温柔包裹，压力分散零死角。外层天珠棉面料，亲肤可机洗。', b'0', '[\"/images/products/p04.jpg\",\"/images/scenes/scene-3.jpg\"]', '内芯：高密度慢回弹记忆棉；面料：天珠棉', '「云朵」零压枕', 39900, 3105, 'zero-pressure-pillow', '[{\"value\":\"高密度慢回弹记忆棉\",\"label\":\"内芯\"},{\"value\":\"5 秒慢回弹\",\"label\":\"回弹\"},{\"value\":\"50×30cm 波浪双高\",\"label\":\"尺寸\"},{\"value\":\"可拆洗天珠棉外套\",\"label\":\"外套\"}]', 'ACTIVE', 500, '把头交给一朵云。零压，不是没有支撑，而是每一寸都被恰好接住。', '慢回弹记忆棉 · 云感零压');
INSERT INTO `products` VALUES ('cmts59ockPbo4qDvLM2SAIjS', 'cmts59obdh9rjtHmXOUWg1wU', 159900, '2026-09-08 12:03:20.324000', '60支新疆长绒棉，缎纹织造，触感如丝。暮金色调取自黄昏最后一缕光，活性印染，久洗如新。', b'1', '[\"/images/products/p05.jpg\",\"/images/scenes/scene-1.jpg\",\"/images/scenes/scene-4.jpg\"]', '面料：60支新疆长绒棉缎纹', '「暮金」60支长绒棉四件套', 129900, 1789, 'mu-jin-60s-set', '[{\"value\":\"60支新疆长绒棉 · 贡缎缎纹\",\"label\":\"面料\"},{\"value\":\"活性印染 · 环保固色\",\"label\":\"工艺\"},{\"value\":\"被套×1 床单×1 枕套×2\",\"label\":\"配置\"},{\"value\":\"适用 200×230cm 被芯\",\"label\":\"尺寸\"}]', 'ACTIVE', 300, '暮色四合时，最想回到的地方。以日落时分的天光为灵感，把一天的疲惫，温柔收进这一床暮金里。', '60支新疆长绒棉 · 活性印染');
INSERT INTO `products` VALUES ('cmts59oco3zV9JW10doPx2kz', 'cmts59obdh9rjtHmXOUWg1wU', NULL, '2026-09-08 12:03:20.328000', '100支贡缎素织，经纬密度冠绝同业，光如月色流转。无印染添加，本色即高级。', b'0', '[\"/images/products/p06.jpg\",\"/images/scenes/scene-2.jpg\"]', '面料：100支精梳棉贡缎', '「月白」100支贡缎四件套', 189900, 756, 'yue-bai-100s-set', '[{\"value\":\"100支精梳长绒棉贡缎\",\"label\":\"面料\"},{\"value\":\"素织免染 · 本色呈现\",\"label\":\"工艺\"},{\"value\":\"被套×1 床单×1 枕套×2\",\"label\":\"配置\"},{\"value\":\"缎面月光光泽\",\"label\":\"光泽\"}]', 'ACTIVE', 200, '月白，是中国人最含蓄的奢华。不着一色，自有万色——织得进月光，也睡得下星河。', '100支贡缎 · 素色美学');
INSERT INTO `products` VALUES ('cmts59octYhikfhk2jJB5qEt', 'cmts59obiyxgwLiF0WWBQcGW', 109900, '2026-09-08 12:03:20.333000', '奥地利兰精天丝纤维，Q-max凉感系数0.36，触肤瞬凉2-3℃。轻盈如岚，吸湿透气，空调房与闷热夜的两全法。', b'1', '[\"/images/products/p07.jpg\",\"/images/scenes/scene-5.jpg\"]', '面料：100% 兰精天丝；填充：凉感纤维', '「青岚」天丝凉感夏被', 89900, 4021, 'tencel-cool-quilt', '[{\"value\":\"Q-max ≥ 0.36（A类优等）\",\"label\":\"凉感值\"},{\"value\":\"100% 奥地利兰精天丝\",\"label\":\"面料\"},{\"value\":\"约 800g / 200×230cm\",\"label\":\"净重\"},{\"value\":\"可机洗 · 免翻晒\",\"label\":\"洗涤\"}]', 'ACTIVE', 600, '夏夜的凉，应当像山间青岚——拂面而不浸骨。以森林之势取材，归还森林以敬意。', '兰精天丝 · 接触瞬凉');
INSERT INTO `products` VALUES ('cmts59ocwU3Hqy6blYqBK1zA', 'cmts59ob7ABu6nw14q4tzfBq', NULL, '2026-09-08 12:03:20.336000', '国家A类母婴安全标准，物理防螨无化学添加。分龄高度设计，守护3-12岁每一个成长期的颈椎。', b'0', '[\"/images/products/p08.jpg\",\"/images/scenes/scene-3.jpg\"]', '内芯：抗菌中空纤维；面料：A类精梳棉', '「稚梦」儿童抗菌防螨枕', 29900, 1544, 'kids-anti-mite-pillow', '[{\"value\":\"GB 18401 A类母婴级\",\"label\":\"标准\"},{\"value\":\"物理防螨 · 无化学助剂\",\"label\":\"防螨\"},{\"value\":\"3-6岁 / 7-12岁 双档高度\",\"label\":\"分龄\"},{\"value\":\"40×60cm\",\"label\":\"尺寸\"}]', 'ACTIVE', 400, '孩子的睡眠里，藏着长高的秘密。像守护第一颗乳牙一样，守护他的第一只枕头。', 'A类母婴级 · 分龄承托');
INSERT INTO `products` VALUES ('cmts59oczwg86eZ5WSJlBLib', 'cmts59oblOt8HyGkwqZH36QX', 699900, '2026-09-08 12:03:20.339000', '取意「锦瑟无端五十弦」，十件套涵盖鹅绒被、贡缎套件、蚕丝枕与新婚对枕。苏绣缠枝莲纹，一针一线皆是祝福。', b'1', '[\"/images/products/p09.jpg\",\"/images/scenes/scene-4.jpg\",\"/images/products/p02.jpg\"]', '组合：鹅绒被+贡缎四件套+蚕丝对枕等十件', '「锦瑟和鸣」新婚十件套礼盒', 599900, 328, 'wedding-gift-box', '[{\"value\":\"十件套（详见商品参数页）\",\"label\":\"套内\"},{\"value\":\"苏绣缠枝莲纹 · 手工盘金\",\"label\":\"工艺\"},{\"value\":\"织云专属漆器礼盒 · 提袋\",\"label\":\"礼盒\"},{\"value\":\"免费礼品包装 · 可定制贺卡\",\"label\":\"服务\"}]', 'ACTIVE', 80, '琴瑟在御，莫不静好。织云婚嫁系列与苏州绣娘合作，把「白头偕老」四个字，绣进了往后每一个晨昏。', '婚嫁臻礼 · 苏绣纹样');
INSERT INTO `products` VALUES ('cmts59od4ykD3RDe9hFtz6NA', 'cmts59obdh9rjtHmXOUWg1wU', NULL, '2026-09-08 12:03:20.344000', '与前GUCCI印花设计总监联名，以莫奈《睡莲》为底本，数码直喷十六色渐变印花，把吉维尼花园搬进卧室。', b'1', '[\"/images/products/p10.jpg\",\"/images/scenes/scene-5.jpg\"]', '面料：80支长绒棉数码印花', '「莫奈花园」大师联名四件套', 219900, 967, 'monet-garden-set', '[{\"value\":\"前GUCCI印花设计总监工作室\",\"label\":\"联名\"},{\"value\":\"16色数码直喷 · 渐变无级\",\"label\":\"印花\"},{\"value\":\"80支长绒棉斜纹\",\"label\":\"面料\"},{\"value\":\"被套×1 床单×1 枕套×2\",\"label\":\"配置\"}]', 'ACTIVE', 200, '当莫奈的睡莲在枕畔泛起柔光，梦也有了颜色。艺术不必悬挂于墙——它可以被盖在身上。', '印象派印花 · 艺术家纺');
INSERT INTO `products` VALUES ('cmts59od9ChMpaOTDQs1GnLA', 'cmts59obdh9rjtHmXOUWg1wU', NULL, '2026-09-08 12:03:20.349000', '欧洲雨露麻，天然褶皱纹理与哑光质感，越洗越柔软。中性大地色系，任意床品皆可相融。', b'0', '[\"/images/products/p11.jpg\",\"/images/scenes/scene-1.jpg\"]', '面料：100% 欧洲雨露麻', '「原野」亚麻枕套对枕', 39900, 688, 'linen-pillowcase-pair', '[{\"value\":\"100% 欧洲雨露麻（4.2支）\",\"label\":\"面料\"},{\"value\":\"48×74cm 对装\",\"label\":\"规格\"},{\"value\":\"天然褶皱 · 哑光肌理\",\"label\":\"风格\"},{\"value\":\"可机洗 · 越洗越柔\",\"label\":\"洗涤\"}]', 'ACTIVE', 300, '亚麻是布料里的原野风。它不讨好肌肤，却让肌肤记得自由。', '雨露麻 · 天然肌理');
INSERT INTO `products` VALUES ('cmts59odc8pHkdcUZqo0kgFO', 'cmts59oa7vLEFbUzgyRef02p', 289900, '2026-09-08 12:03:20.352000', '澳洲美利奴细支羊毛，天然卷曲锁住静止空气，恒温锁暖不闷汗。羊毛脂亲肤，湿气管理能力是棉的2倍。', b'0', '[\"/images/products/p12.jpg\",\"/images/scenes/scene-6.jpg\"]', '填充：100% 澳洲美利奴羊毛；面料：全棉防羽布', '「暖山」澳洲羊毛冬被', 249900, 552, 'wool-winter-duvet', '[{\"value\":\"100% 澳洲美利奴羊毛\",\"label\":\"填充物\"},{\"value\":\"恒温锁暖 · 吸湿排汗\",\"label\":\"功能\"},{\"value\":\"约 1600g / 200×230cm\",\"label\":\"克重\"},{\"value\":\"Woolmark 国际羊毛局认证\",\"label\":\"认证\"}]', 'ACTIVE', 140, '山有暖意，被有羊毛。最古老的御寒智慧，配得上最现代的一夜好眠。', '澳洲美利奴羊毛 · 恒温锁暖');
INSERT INTO `products` VALUES ('cmttjtaqqX0a0a6P081E7WkW', 'cmts59obdh9rjtHmXOUWg1wU', NULL, '2026-09-09 11:38:16.610000', '极致柔软，安心睡眠', b'0', '[\"/images/products/p01.jpg\"]', NULL, '高级床垫', 2888800, 3, 'zy-mttjtaql', NULL, 'ACTIVE', 886, NULL, NULL);
INSERT INTO `products` VALUES ('cmuqokknsqeVtCgvCsH9iAm6', 'cmts59oa7vLEFbUzgyRef02p', NULL, '2026-10-02 16:07:51.448000', '端到端测试商品', b'0', '[\"/images/products/p02.jpg\"]', NULL, 'E2E测试商品', 129900, 0, 'zy-muqokkno', NULL, 'OFF', 50, NULL, '测试副标题');

-- ----------------------------
-- Table structure for reviews
-- ----------------------------
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `product_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `rating` int NOT NULL,
  `user_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FKpl51cejpw4gy5swfar8br9ngi`(`product_id` ASC) USING BTREE,
  INDEX `FKcgy7qjc1r99dp117y9en6lxye`(`user_id` ASC) USING BTREE,
  CONSTRAINT `FKcgy7qjc1r99dp117y9en6lxye` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKpl51cejpw4gy5swfar8br9ngi` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reviews
-- ----------------------------
INSERT INTO `reviews` VALUES ('cmts59osbAU8lTLmzCTA5IfK', '像睡进一朵云里。北方的冬天暖气很足，这床被居然完全不闷，蓬松度名不虚传。', '2026-09-08 12:03:20.891000', 'cmts59oc2El3OVZEX5rsoXkl', 5, 'cmts59oitsiceH9H1rDsdqgY');
INSERT INTO `reviews` VALUES ('cmts59osef8WVC5SNGTSGiyy', '给父母买的，二老说比国外买的某大牌还要暖和轻盈，客服也很耐心。', '2026-09-08 12:03:20.895000', 'cmts59oc2El3OVZEX5rsoXkl', 5, 'cmts59okopM4ElR6j1g27Zkd');
INSERT INTO `reviews` VALUES ('cmts59osjMX0KZhwVQZThbPn', '蚕丝被贴身的那种柔软很难形容，就是睡下去不想起来。包装也极有质感，送礼体面。', '2026-09-08 12:03:20.899000', 'cmts59oc9DjCflo2ehWqwkw5', 5, 'cmts59omhcWgCgTKZhOpb8jx');
INSERT INTO `reviews` VALUES ('cmts59osmIYLlPGTQKLdFU93', '颈椎承托区的设计确实到位，温感微微发热很舒服，唯一希望出个更矮的款。', '2026-09-08 12:03:20.902000', 'cmts59ocdiQElOBzjOF1aMhJ', 4, 'cmts59oo9ZfiQh8020oH2Kk9');
INSERT INTO `reviews` VALUES ('cmts59ospmdeqqDkZQfS4YzU', '慢回弹真的零压，侧睡肩膀不酸了。已经回购第二只给男朋友。', '2026-09-08 12:03:20.905000', 'cmts59ocgmIQavgFpqOxBEMA', 5, 'cmts59oitsiceH9H1rDsdqgY');
INSERT INTO `reviews` VALUES ('cmts59ostAs2cFWzSjKRS2pJ', '暮金色比图片更温柔，缎纹的垂坠感一铺上床整个卧室都高级了。', '2026-09-08 12:03:20.909000', 'cmts59ockPbo4qDvLM2SAIjS', 5, 'cmts59oq3ZimlnszOBCafEft');
INSERT INTO `reviews` VALUES ('cmts59osvDEr29eroGlDKMxO', '印花渐变太美了，没有任何色差和异味，朋友以为是美术馆的联名。', '2026-09-08 12:03:20.911000', 'cmts59od4ykD3RDe9hFtz6NA', 5, 'cmts59os1DZyrhgMKeLxiHhx');
INSERT INTO `reviews` VALUES ('cmts59oszjBpBR9M86TKfQ1L', '闺蜜结婚送的，苏绣礼盒一打开全场惊叹，绣工确实是大师级。', '2026-09-08 12:03:20.915000', 'cmts59oczwg86eZ5WSJlBLib', 5, 'cmts59okopM4ElR6j1g27Zkd');
INSERT INTO `reviews` VALUES ('cmuxs5cdfuvuN9SPmFGGkBLj', '小程序联调链路验证评价', '2026-10-07 15:22:22.563000', 'cmttjtaqqX0a0a6P081E7WkW', 5, 'cmts59ogzCppiSfx7fHWfzqL');

-- ----------------------------
-- Table structure for sessions
-- ----------------------------
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UKnr21vuswfbmr91q57xdbnou5f`(`token` ASC) USING BTREE,
  INDEX `FKruie73rneumyyd1bgo6qw8vjt`(`user_id` ASC) USING BTREE,
  CONSTRAINT `FKruie73rneumyyd1bgo6qw8vjt` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sessions
-- ----------------------------
INSERT INTO `sessions` VALUES ('cmts5q4typFPaZPUPNPNCnUi', '2026-09-08 12:16:08.182000', '2026-10-08 12:16:08.182000', '4ff39b1d3752499785fe1e1913dbc431c150fb3e2f16f0a8', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmts5qdz1yVdM3m6amRypw2p', '2026-09-08 12:16:20.029000', '2026-10-08 12:16:20.029000', '168057bd11f55b8fd3f0e4b13b0ff3ff59c57ff5f05713ed', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmttgiic22A4HfIha1CSgEr6', '2026-09-09 10:05:54.386000', '2026-10-09 10:05:54.381000', '32d5dea8d22523109f5fbac8b5e4e79875688ca5d4987881', 'cmts59ogzCppiSfx7fHWfzqL');
INSERT INTO `sessions` VALUES ('cmttgje3j2fHCwufLY6iENtE', '2026-09-09 10:06:35.551000', '2026-10-09 10:06:35.551000', 'f2a977fe009434cd9fb1aeb27dffbc8668af48dcb6e082d7', 'cmttgje3i8vetTGMn8FrZjY4');
INSERT INTO `sessions` VALUES ('cmttgjebaOblj5MNrpAxhsiQ', '2026-09-09 10:06:35.830000', '2026-10-09 10:06:35.830000', '92db1c4209b1c0027ed6bf15c0e8b4aab1f128152494c207', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmttgkx9mL6edHIpGCglvF4C', '2026-09-09 10:07:47.050000', '2026-10-09 10:07:47.050000', '20d02db65b7c7692a17d8cf8d23f4a84978fec3adcb43147', 'cmttgkx9axMqB2cWS3e0Zkt6');
INSERT INTO `sessions` VALUES ('cmttgkxcoDB1HHj9UgQQA9WZ', '2026-09-09 10:07:47.160000', '2026-10-09 10:07:47.160000', 'd87a767d11941027270e840af0b9d2985407fd9100737228', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmttgm3phJLTLr3CtTNib6bT', '2026-09-09 10:08:42.053000', '2026-10-09 10:08:42.053000', '614cd5dd077dfce60462653088dc38c786c1b744903d36c3', 'cmttgm3pg018DhXDD3J2RU7N');
INSERT INTO `sessions` VALUES ('cmttgm3z5JUSu7XBPULj3vAd', '2026-09-09 10:08:42.401000', '2026-10-09 10:08:42.400000', 'ea6205a5e430a4b59e7470fdb079b3cee41a4002e6591d76', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmttgrv64jssVU9GP2ERG8fN', '2026-09-09 10:13:10.924000', '2026-10-09 10:13:10.923000', '7456eb0651bc1a1955dca0f004fef37dbe85bdc87417fe7b', 'cmttgrv5pmc6AjEjVPRNYLwt');
INSERT INTO `sessions` VALUES ('cmttgyh79UuHukVBYn40xmWI', '2026-09-09 10:18:19.413000', '2026-10-09 10:18:19.412000', '51dc10dcbc7ca7192a1a3dc16041fec9f28cdecb2bf7bf7e', 'cmttgyh6tirigxVYeWdepe7R');
INSERT INTO `sessions` VALUES ('cmttgyhoo17YXDh5yZHDH8tv', '2026-09-09 10:18:20.041000', '2026-10-09 10:18:20.040000', '20c3d3e61f84a1c325870ff16bb17eef6f5d9ddec4e4f740', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmtth9k8dudetITRJK4cwOhx', '2026-09-09 10:26:56.557000', '2026-10-09 10:26:56.556000', '23b13c132c1da84183c67c8b24d17a475c0b0aba58f04ae6', 'cmtth9k80Q3AWxEBpYIFXXoG');
INSERT INTO `sessions` VALUES ('cmtthh9sfUMfJiyFy87hMX67', '2026-09-09 10:32:56.271000', '2026-10-09 10:32:56.270000', '096b0d715db6943a0ce1b6ef9e47c591bf8f4c633cc561d2', 'cmtthh9rtnfWfOK55CnZvq83');
INSERT INTO `sessions` VALUES ('cmtthha9p5ayMd5nWnUaoFYl', '2026-09-09 10:32:56.893000', '2026-10-09 10:32:56.893000', '611457ef63994306035f624f3358266092caace435c7bfb7', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmttj4wbqBQtABFLiIVm4LpB', '2026-09-09 11:19:18.182000', '2026-10-09 11:19:18.181000', 'd6f417fee0f4c9e7f8860ed2eccf31dd8848ef9f6b80d92d', 'cmttj4wbp01K9WrobErsFWfO');
INSERT INTO `sessions` VALUES ('cmttj4wfikTajejK8uhotSXf', '2026-09-09 11:19:18.318000', '2026-10-09 11:19:18.318000', '465b4e1020517ea11160d7b6f044efa08467850bf42d6fff', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqoglwribfsBtheZL2gAIo', '2026-10-02 16:04:46.443000', '2026-11-01 16:04:46.438000', '82fa6758df9783de8e522c3256d653ee64731d8399a5bace', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqogwg3qJF7g98J7opR0aw', '2026-10-02 16:05:00.099000', '2026-11-01 16:05:00.099000', '5d556f699f3d2c4de6cc46b118a74ef270c350cd052d8a52', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqoh8fhfcU5VcVVGwSk6il', '2026-10-02 16:05:15.629000', '2026-11-01 16:05:15.629000', '473af1aa1c30bd1ba28b273564a6b6526f5cecabe5757167', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqoie29zQKkPmrkeytXWWz', '2026-10-02 16:06:09.585000', '2026-11-01 16:06:09.585000', '557527c721cc30b3cef37b28bb9c147dcf26b1cbe1ac93c8', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqokkasz4xZsdqGFtAkTVz', '2026-10-02 16:07:50.980000', '2026-11-01 16:07:50.976000', 'b30b10dc880f0f7df38cb7f7f9f8aa36329475272b74e25e', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqomq4r8s3D59X7c41O55W', '2026-10-02 16:09:31.851000', '2026-11-01 16:09:31.850000', '66a4a5c0ba6338d8cc357ecf4be0431eae38cc1e63121824', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqonn7pT8xyKsC1FsqWNAn', '2026-10-02 16:10:14.725000', '2026-11-01 16:10:14.725000', '8e80f042cccf3ca6a5ccd90c0ad0704ef5f3fb0b35bfe83c', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqoszj5Az63y8H5E0DhB9H', '2026-10-02 16:14:23.969000', '2026-11-01 16:14:23.969000', '7bf37a95ab137bf5ab397b102d3ee4f6198932c053510328', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqq1fx9AGkodVf5t2B2F8j', '2026-10-02 16:48:58.078000', '2026-11-01 16:48:58.071000', '68ad74625c53146916c64499d77ed99594a7e984824705eb', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqqdwhffJf5GLXePJ4gBsE', '2026-10-02 16:58:39.411000', '2026-11-01 16:58:39.407000', '903cd7bfea667855e52d4e21fe71190823594bf201f721fe', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqqepa8YtTS28dTicajZeD', '2026-10-02 16:59:16.736000', '2026-11-01 16:59:16.736000', '5d42cd4b38f38b0cf2437cc7424161554635295a25a92ab9', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuqqepvhM4fMX8bEQm4d4Bn', '2026-10-02 16:59:17.502000', '2026-11-01 16:59:17.501000', '958aefd958a0d6ef9c290af4f38809e3d935030ec3a790da', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuscl218HBTzZ2wbiYNh94W', '2026-10-03 20:07:50.924000', '2026-11-02 20:07:50.922000', '2117cf33e75414f68193b6ef607793ebbedb6c796c1a0421', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmusclo8xdK34w95WdorTEKW', '2026-10-03 20:08:19.713000', '2026-11-02 20:08:19.713000', '53db9c32b6a7d523581941acc0a8301868de273dbcde37e6', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuscmkgyHfJumst9SOH1ed4', '2026-10-03 20:09:01.474000', '2026-11-02 20:09:01.474000', 'baf9f7655a574b8a5954027f4d00f522751ca62574329376', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmutddgkuevbnHYbaXhec4jN', '2026-10-04 13:17:42.318000', '2026-11-03 13:17:42.308000', '3bce961a0905f846c61bd329d4f3764dfce2e5f65fae5936', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuxpzjl8L0C8bPlmHOusE6V', '2026-10-07 14:21:52.748000', '2026-11-06 14:21:52.737000', 'c0d4de14f60faac7828f2e886ca1849c896d02a1d3932adb', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmuxs3o2lryQc8BVUFqJfHpH', '2026-10-07 15:21:04.413000', '2026-11-06 15:21:04.409000', '0672f9039f282fe9b7d5700fef6afe0cc34e0a235821a8df', 'cmts59ogzCppiSfx7fHWfzqL');
INSERT INTO `sessions` VALUES ('cmuxs4le65UTsZheGO8i56Vl', '2026-10-07 15:21:47.600000', '2026-11-06 15:21:47.598000', 'b8f927cb023cb58aafb4d8a7499ae12c11280d5158cd3492', 'cmts59ogzCppiSfx7fHWfzqL');
INSERT INTO `sessions` VALUES ('cmuxs5bwibRpfRmcbetNmc9V', '2026-10-07 15:22:21.955000', '2026-11-06 15:22:21.954000', 'ccaa9da22746e560af3e7ef380b061fc27583fa6223c6f4a', NULL);
INSERT INTO `sessions` VALUES ('cmuxs5c2mUrfcgNJuvokQJlj', '2026-10-07 15:22:22.175000', '2026-11-06 15:22:22.174000', '413dc8ea8fd8bf9ac371b8556bd012a4c64258ca23062290', 'cmts59ogzCppiSfx7fHWfzqL');
INSERT INTO `sessions` VALUES ('cmuxs60nhfJnp4wwlpyaoWcO', '2026-10-07 15:22:54.029000', '2026-11-06 15:22:54.029000', 'c8ad5c301a55e5a33f0d69d3d764716bd9018f9c4c3bffc3', 'cmts59ogzCppiSfx7fHWfzqL');
INSERT INTO `sessions` VALUES ('cmuxs7gt0TZB1kNZCbZCnM9b', '2026-10-07 15:24:01.620000', '2026-11-06 15:24:01.620000', 'bd6b411e1d9ea2575be3b2dea48e19dfe828735fdca6ee50', 'cmts59ogzCppiSfx7fHWfzqL');
INSERT INTO `sessions` VALUES ('cmuxscvibSwiWXKzDNsaZUzK', '2026-10-07 15:28:13.955000', '2026-11-06 15:28:13.955000', '670272c96a5c9d529dd21f3c2640e0ba3f7a655347e0c4c5', 'cmts59ogzCppiSfx7fHWfzqL');

-- ----------------------------
-- Table structure for site_content
-- ----------------------------
DROP TABLE IF EXISTS `site_content`;
CREATE TABLE `site_content`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK2ve1ysexh1fqquvs0k1ljaldj`(`content_key` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of site_content
-- ----------------------------
INSERT INTO `site_content` VALUES ('cmuqoiea4z509ZzZ3i2ZQg1t', '{\"slides\":[{\"src\":\"/images/heroes/hero-1.jpg\",\"eyebrow\":\"ZHIYUN LIVING · Since 1988\",\"title\":\"以东方织造，\\n致一世安眠\",\"sub\":\"三十八年，三代织人，一件事：把「睡个好觉」，做成值得传家的东西。\",\"href\":\"/story\",\"cta\":\"走进品牌\"},{\"src\":\"/images/heroes/hero-2.jpg\",\"eyebrow\":\"Craftsmanship · 匠心\",\"title\":\"不赶时间，只赶手艺\",\"sub\":\"绒朵、长丝与贡缎——95% 的预算花在看不见的地方。27 项原材检测，43 道出厂工序。\",\"href\":\"/story\",\"cta\":\"了解匠心\"},{\"src\":\"/images/heroes/hero-3.jpg\",\"eyebrow\":\"Master Collaboration · 大师联名\",\"title\":\"当莫奈的睡莲，\\n开在枕畔\",\"sub\":\"与前GUCCI印花设计总监联名，十六色渐变直喷——艺术家纺，自此有了模样。\",\"href\":\"/shop\",\"cta\":\"走进官方商城\"}]}', 'home.hero', '2026-10-02 16:20:20.390000');
INSERT INTO `site_content` VALUES ('cmuqoieadIiVyz21NIlSBxV4', '{\"img\":\"/images/heroes/hero-2.jpg\",\"eyebrow\":\"Zhiyun Official Store\",\"title\":\"秋季焕新 · 官方商城\",\"sub\":\"全场满 ¥1,299 减 ¥150 · 顺丰包邮 · 30 天无忧退换\\n新会员注册即赠 ¥100 礼遇\"}', 'shop.hero', '2026-10-02 16:20:20.399000');
INSERT INTO `site_content` VALUES ('cmuqomqhgFaXYL8wDrnPYN0V', '{\"eyebrow\":\"Philosophy\",\"title\":\"织云，织的是时间\",\"desc\":\"从一颗茧、一束绒到一寸缎，织云坚持最古老的方式：不赶时间，只赶手艺。我们把「睡个好觉」这件事，做成了值得传家的东西。\"}', 'home.philosophy', '2026-10-02 16:20:20.394000');
INSERT INTO `site_content` VALUES ('cmuqomqhoDksZu2I8yuvdoHc', '{\"image\":\"\",\"title\":\"当莫奈的睡莲，\\n开在枕畔。\",\"desc\":\"与前 GUCCI 印花设计总监联手的艺术家纺系列——十六色渐变直喷工艺，将《睡莲》的光影移植到 100 支贡缎之上。\"}', 'home.collab', '2026-10-02 16:20:20.397000');
INSERT INTO `site_content` VALUES ('cmuqomqi4UgQHdW5Y2LbGffK', '{\"img\":\"/images/scenes/scene-2.jpg\",\"eyebrow\":\"Newsroom\",\"title\":\"品牌动态\",\"sub\":\"织云的每一步，都与你有关——新品发布、品牌荣誉与来自一线的故事。\"}', 'news.hero', '2026-10-02 16:20:20.401000');
INSERT INTO `site_content` VALUES ('cmuscmkjzK3FnhoiZB6dUbnC', '{\"img\":\"/images/scenes/scene-6.jpg\",\"eyebrow\":\"Our Story · Since 1988\",\"title\":\"以东方织造，\\n致一世安眠。\",\"sub\":\"三十八年，三代织人，一件事：把「睡个好觉」做成传家的东西。\"}', 'story.hero', '2026-10-03 20:09:01.581000');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `password_hash` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `role` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK6dotkott2kjsp8vw4d0m25fb7`(`email` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('cmts59of5azF8MsLGoB44zw4', '2026-09-08 12:03:20.417000', 'admin@zhiyun.cn', '织云管理员', '$2a$10$t3FwgrPwk01WCTR8/6Qg..d954zFrqQKnniNWS8apIgzhwspmTuBS', NULL, 'ADMIN');
INSERT INTO `users` VALUES ('cmts59ogzCppiSfx7fHWfzqL', '2026-09-08 12:03:20.483000', 'demo@zhiyun.cn', '沈知微', '$2a$10$RMn38Lrwnm13hR2QuoJHGuA8qDcjny.LL.Ac7dBmEtyzaJ1lDQYSm', '13800006666', 'CUSTOMER');
INSERT INTO `users` VALUES ('cmts59oitsiceH9H1rDsdqgY', '2026-09-08 12:03:20.549000', 'linww@example.com', '林晚晚', '$2a$10$tX625TjkvcSnIighl3yjVeGqvovBn0zZh3Xz1T9Gk/9L30ONbLyp2', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmts59okopM4ElR6j1g27Zkd', '2026-09-08 12:03:20.616000', '123456', '陈屿', '123456', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmts59omhcWgCgTKZhOpb8jx', '2026-09-08 12:03:20.681000', 'suhe@example.com', '苏合', '$2a$10$nCa/2lnnURH6WXoNTY8OG.gWdUgpN4KNslUy/42tyJjP6/34LxIty', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmts59oo9ZfiQh8020oH2Kk9', '2026-09-08 12:03:20.747000', 'gubc@example.com', '顾北辰', '$2a$10$7uquErLWtdhfgWTXpZsuy.cB8cmpaUpNIM0e3HkCJa5jNIBmsQoRm', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmts59oq3ZimlnszOBCafEft', '2026-09-08 12:03:20.812000', 'baijin@example.com', '白槿', '$2a$10$oKsWriQkNKrseDUUOAXmKOYU.kMjLD2gsJ5f53vQ8X1k5w7YJAx8.', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmts59os1DZyrhgMKeLxiHhx', '2026-09-08 12:03:20.881000', 'jiangli@example.com', '江离', '$2a$10$lAHb/rTuIHrSUPGG3z0vxORrFSoUwyJk1vf09K8aTxR8gWFUDGWtO', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmttgje3i8vetTGMn8FrZjY4', '2026-09-09 10:06:35.551000', 't639245451954635258@test.cn', '????', '$2a$10$HCzpuSYIPk38plug3YlaLeEPjFLMJA1yhWwQECX1./3omYCLe1LVC', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmttgkx9axMqB2cWS3e0Zkt6', '2026-09-09 10:07:47.038000', 't2639245452669501888@test.cn', '??2', '$2a$10$unxjFjAU7AhzTu.rGbc9deVeliky98UYe6jL2R71SGxM3dD4fsOKG', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmttgm3pg018DhXDD3J2RU7N', '2026-09-09 10:08:42.052000', 't639245453219699046@test.cn', '????', '$2a$10$eqYxSnxcI5zDf1n44QCYI.LeUfkgZLq/7ciKkvzjQ7IIhN4I31NGm', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmttgrv5pmc6AjEjVPRNYLwt', '2026-09-09 10:13:10.910000', 't639245455907783431@test.cn', 'dbg', '$2a$10$DPOLJDHLYZkVzcYvDFfoWu2ux/9m9IKfLI5hHvumwyTkFuuIOCFfu', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmttgyh6tirigxVYeWdepe7R', '2026-09-09 10:18:19.397000', 't639245458991769827@test.cn', 'dbg2', '$2a$10$yb050BbL7psoGKjQ.xcjD.RkuS7FyiqssXAfZsKcy.oDTfTsKFUzu', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmtth9k80Q3AWxEBpYIFXXoG', '2026-09-09 10:26:56.545000', 't639245464162750696@test.cn', 'dbg3', '$2a$10$BSICr3BEWmrUb1pK99uCL.zhsq83Yzp.Eth.wqg9C3YYLDc4Z40hq', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmtthh9rtnfWfOK55CnZvq83', '2026-09-09 10:32:56.249000', 't639245467760859678@test.cn', 'final', '$2a$10$DyMlcXMF2x24lFM.kRMw1e/4wG5Bbh7ryZeilXcTSMQV22yKNwqYC', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmttj4w6qQWifWuLVgYkEtlk', '2026-09-09 11:19:18.002000', 'ua639245495577674972@t.cn', '??A', '$2a$10$BZy73M1hs03xWaAC3A44OODWt6g6VLC/.nkUU7gPDxA9I.kii21g.', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmttj4wbp01K9WrobErsFWfO', '2026-09-09 11:19:18.181000', 'ub639245495577674972@t.cn', '??B', '$2a$10$fstYUdC6MNmYahONzxQNYOSvNioBsSYcQ51Q7U20CG7tyAbCAlCpa', NULL, 'CUSTOMER');

SET FOREIGN_KEY_CHECKS = 1;
