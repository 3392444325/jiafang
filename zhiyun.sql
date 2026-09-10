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

 Date: 09/09/2026 08:45:13
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
INSERT INTO `cart_items` VALUES ('cmtsa7m1nnPN1O9jM9PJ1e9U', '2026-09-08 14:21:42.107000', 'cmts59odc8pHkdcUZqo0kgFO', 3, NULL, 'cmts59of5azF8MsLGoB44zw4');

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
INSERT INTO `order_items` VALUES ('cmts59ot94oFFnovRYZOERO6', '/images/products/p01.svg', '「云绒」95白鹅绒被', 'cmts59ot5CfHtFgrayZlAKF7', 299900, 'cmts59oc2El3OVZEX5rsoXkl', 1);
INSERT INTO `order_items` VALUES ('cmts59otdxF4DlcNHTuK3E0u', '/images/products/p04.svg', '「云朵」零压枕', 'cmts59ot5CfHtFgrayZlAKF7', 39900, 'cmts59ocgmIQavgFpqOxBEMA', 1);
INSERT INTO `order_items` VALUES ('cmts59otmLKNxdcs4lIHEd4Y', '/images/products/p05.svg', '「暮金」60支长绒棉四件套', 'cmts59oticOSWAoQJ8pAaAQ9', 129900, 'cmts59ockPbo4qDvLM2SAIjS', 1);

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
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UKg8pohnngqi5x1nask7nff2u7w`(`order_no` ASC) USING BTREE,
  INDEX `FK32ql8ubntj5uh44ph9659tiih`(`user_id` ASC) USING BTREE,
  CONSTRAINT `FK32ql8ubntj5uh44ph9659tiih` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES ('cmts59ot5CfHtFgrayZlAKF7', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-06 12:03:20.920000', 'ZY20260905-238801', '2026-09-06 12:03:20.920000', 'WECHAT', 'PAID', 339800, 'cmts59ogzCppiSfx7fHWfzqL');
INSERT INTO `orders` VALUES ('cmts59oticOSWAoQJ8pAaAQ9', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-08 12:03:20.934000', 'ZY20260906-410927', NULL, NULL, 'PENDING_PAYMENT', 129900, 'cmts59ogzCppiSfx7fHWfzqL');
INSERT INTO `orders` VALUES ('cmtsaalchoiKoMBgtPQslM7I', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-08 14:24:01.169000', 'ZY20260908-861146', '2026-09-08 14:24:03.918000', 'WECHAT', 'PAID', 49900, 'cmts59ogzCppiSfx7fHWfzqL');
INSERT INTO `orders` VALUES ('cmtsiodyffd9fc8FQ6y5cFuq', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-08 18:18:41.703000', 'ZY20260908-300785', '2026-09-08 18:18:49.035000', 'WECHAT', 'PAID', 388000, 'cmts59ogzCppiSfx7fHWfzqL');
INSERT INTO `orders` VALUES ('cmtsiz9xlrsAVJpoPgKpoDDb', '{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}', '2026-09-08 18:27:09.705000', 'ZY20260908-891698', '2026-09-08 18:27:22.264000', 'WECHAT', 'PAID', 49900, 'cmts59ogzCppiSfx7fHWfzqL');

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
INSERT INTO `products` VALUES ('cmts59oc2El3OVZEX5rsoXkl', 'cmts59oa7vLEFbUzgyRef02p', 368000, '2026-09-08 12:03:20.306000', '甄选北纬45°黄金绒带95%白鹅绒，蓬松度800+，如云朵般轻盈包裹。100支全棉防绒面料，静音柔滑，锁温透气兼得。', b'1', '[\"/images/products/p01.svg\",\"/images/scenes/scene-2.svg\",\"/images/products/p06.svg\"]', '填充：95%白鹅绒；面料：100支全棉防绒布', '「云绒」95白鹅绒被', 299900, 1286, 'cloud-goose-down-duvet', '[{\"value\":\"95% 白鹅绒（蓬松度 800+）\",\"label\":\"填充物\"},{\"value\":\"100支全棉防绒面料\",\"label\":\"面料\"},{\"value\":\"冬款约 1100g / 200×230cm\",\"label\":\"克重\"},{\"value\":\"立衬分区 · 五重防钻绒\",\"label\":\"工艺\"}]', 'ACTIVE', 200, '一朵云的重量，约等于一夜安眠。织云走遍东北与西伯利亚绒源地，只为找到那束绒朵饱满、干净无杂的白鹅绒——以28年羽绒工艺，织就这张值得托付终身的被。', '95% 白鹅绒 · 100支防绒棉面料');
INSERT INTO `products` VALUES ('cmts59oc9DjCflo2ehWqwkw5', 'cmts59oa7vLEFbUzgyRef02p', NULL, '2026-09-08 12:03:20.313000', '选用江浙优质蚕区100%桑蚕丝长丝，绵韧贴身、轻盈透气。传统手工定位工艺，丝胎经年不移位，四季皆宜。', b'1', '[\"/images/products/p02.svg\",\"/images/scenes/scene-1.svg\"]', '填充：100% 桑蚕丝长丝；面料：60支天丝棉', '「云丝」桑蚕丝长丝被', 388000, 863, 'silk-mulberry-duvet', '[{\"value\":\"100% 桑蚕丝长丝\",\"label\":\"填充物\"},{\"value\":\"60支天丝棉混纺\",\"label\":\"面料\"},{\"value\":\"手工定位 · 丝胎免翻新\",\"label\":\"工艺\"},{\"value\":\"约 2000g / 200×230cm\",\"label\":\"净重\"}]', 'ACTIVE', 149, '一颗茧，可抽丝千米。织云只取一级桑蚕丝长丝，沿袭江南蚕坊手工拉制定位古法——让千年的温柔，落在你枕畔。', '100% 桑蚕丝长丝 · 手工定位');
INSERT INTO `products` VALUES ('cmts59ocdiQElOBzjOF1aMhJ', 'cmts59ob7ABu6nw14q4tzfBq', 59900, '2026-09-08 12:03:20.317000', '三区立体承托设计，仰睡侧睡各得其所；内芯融合托玛琳矿物颗粒，温感自热，促进颈部微循环，抗菌防螨率99%。', b'1', '[\"/images/products/p03.svg\",\"/images/products/p04.svg\"]', '内芯：托玛琳复合颗粒 + 高弹纤维；面料：60支抗菌针织棉', '「深睡」托玛琳抗菌枕', 49900, 2303, 'deep-sleep-pillow', '[{\"value\":\"三区承托（侧睡/仰睡/颈椎承托）\",\"label\":\"结构\"},{\"value\":\"温感自热 · 99%抗菌防螨\",\"label\":\"功能\"},{\"value\":\"48×74cm\",\"label\":\"尺寸\"},{\"value\":\"德国红点设计奖获奖系列\",\"label\":\"认证\"}]', 'ACTIVE', 498, '好枕头，是颈椎的年假。织云联合睡眠实验室，历经217次人体工学测试——只为让你入睡的第一分钟，就开始深睡。', '分区承托 · 温感自热');
INSERT INTO `products` VALUES ('cmts59ocgmIQavgFpqOxBEMA', 'cmts59ob7ABu6nw14q4tzfBq', NULL, '2026-09-08 12:03:20.320000', '5秒慢回弹记忆棉，随头颈曲线温柔包裹，压力分散零死角。外层天珠棉面料，亲肤可机洗。', b'0', '[\"/images/products/p04.svg\",\"/images/scenes/scene-3.svg\"]', '内芯：高密度慢回弹记忆棉；面料：天珠棉', '「云朵」零压枕', 39900, 3105, 'zero-pressure-pillow', '[{\"value\":\"高密度慢回弹记忆棉\",\"label\":\"内芯\"},{\"value\":\"5 秒慢回弹\",\"label\":\"回弹\"},{\"value\":\"50×30cm 波浪双高\",\"label\":\"尺寸\"},{\"value\":\"可拆洗天珠棉外套\",\"label\":\"外套\"}]', 'ACTIVE', 500, '把头交给一朵云。零压，不是没有支撑，而是每一寸都被恰好接住。', '慢回弹记忆棉 · 云感零压');
INSERT INTO `products` VALUES ('cmts59ockPbo4qDvLM2SAIjS', 'cmts59obdh9rjtHmXOUWg1wU', 159900, '2026-09-08 12:03:20.324000', '60支新疆长绒棉，缎纹织造，触感如丝。暮金色调取自黄昏最后一缕光，活性印染，久洗如新。', b'1', '[\"/images/products/p05.svg\",\"/images/scenes/scene-1.svg\",\"/images/scenes/scene-4.svg\"]', '面料：60支新疆长绒棉缎纹', '「暮金」60支长绒棉四件套', 129900, 1789, 'mu-jin-60s-set', '[{\"value\":\"60支新疆长绒棉 · 贡缎缎纹\",\"label\":\"面料\"},{\"value\":\"活性印染 · 环保固色\",\"label\":\"工艺\"},{\"value\":\"被套×1 床单×1 枕套×2\",\"label\":\"配置\"},{\"value\":\"适用 200×230cm 被芯\",\"label\":\"尺寸\"}]', 'ACTIVE', 300, '暮色四合时，最想回到的地方。以日落时分的天光为灵感，把一天的疲惫，温柔收进这一床暮金里。', '60支新疆长绒棉 · 活性印染');
INSERT INTO `products` VALUES ('cmts59oco3zV9JW10doPx2kz', 'cmts59obdh9rjtHmXOUWg1wU', NULL, '2026-09-08 12:03:20.328000', '100支贡缎素织，经纬密度冠绝同业，光如月色流转。无印染添加，本色即高级。', b'0', '[\"/images/products/p06.svg\",\"/images/scenes/scene-2.svg\"]', '面料：100支精梳棉贡缎', '「月白」100支贡缎四件套', 189900, 756, 'yue-bai-100s-set', '[{\"value\":\"100支精梳长绒棉贡缎\",\"label\":\"面料\"},{\"value\":\"素织免染 · 本色呈现\",\"label\":\"工艺\"},{\"value\":\"被套×1 床单×1 枕套×2\",\"label\":\"配置\"},{\"value\":\"缎面月光光泽\",\"label\":\"光泽\"}]', 'ACTIVE', 200, '月白，是中国人最含蓄的奢华。不着一色，自有万色——织得进月光，也睡得下星河。', '100支贡缎 · 素色美学');
INSERT INTO `products` VALUES ('cmts59octYhikfhk2jJB5qEt', 'cmts59obiyxgwLiF0WWBQcGW', 109900, '2026-09-08 12:03:20.333000', '奥地利兰精天丝纤维，Q-max凉感系数0.36，触肤瞬凉2-3℃。轻盈如岚，吸湿透气，空调房与闷热夜的两全法。', b'1', '[\"/images/products/p07.svg\",\"/images/scenes/scene-5.svg\"]', '面料：100% 兰精天丝；填充：凉感纤维', '「青岚」天丝凉感夏被', 89900, 4021, 'tencel-cool-quilt', '[{\"value\":\"Q-max ≥ 0.36（A类优等）\",\"label\":\"凉感值\"},{\"value\":\"100% 奥地利兰精天丝\",\"label\":\"面料\"},{\"value\":\"约 800g / 200×230cm\",\"label\":\"净重\"},{\"value\":\"可机洗 · 免翻晒\",\"label\":\"洗涤\"}]', 'ACTIVE', 600, '夏夜的凉，应当像山间青岚——拂面而不浸骨。以森林之势取材，归还森林以敬意。', '兰精天丝 · 接触瞬凉');
INSERT INTO `products` VALUES ('cmts59ocwU3Hqy6blYqBK1zA', 'cmts59ob7ABu6nw14q4tzfBq', NULL, '2026-09-08 12:03:20.336000', '国家A类母婴安全标准，物理防螨无化学添加。分龄高度设计，守护3-12岁每一个成长期的颈椎。', b'0', '[\"/images/products/p08.svg\",\"/images/scenes/scene-3.svg\"]', '内芯：抗菌中空纤维；面料：A类精梳棉', '「稚梦」儿童抗菌防螨枕', 29900, 1544, 'kids-anti-mite-pillow', '[{\"value\":\"GB 18401 A类母婴级\",\"label\":\"标准\"},{\"value\":\"物理防螨 · 无化学助剂\",\"label\":\"防螨\"},{\"value\":\"3-6岁 / 7-12岁 双档高度\",\"label\":\"分龄\"},{\"value\":\"40×60cm\",\"label\":\"尺寸\"}]', 'ACTIVE', 400, '孩子的睡眠里，藏着长高的秘密。像守护第一颗乳牙一样，守护他的第一只枕头。', 'A类母婴级 · 分龄承托');
INSERT INTO `products` VALUES ('cmts59oczwg86eZ5WSJlBLib', 'cmts59oblOt8HyGkwqZH36QX', 699900, '2026-09-08 12:03:20.339000', '取意「锦瑟无端五十弦」，十件套涵盖鹅绒被、贡缎套件、蚕丝枕与新婚对枕。苏绣缠枝莲纹，一针一线皆是祝福。', b'1', '[\"/images/products/p09.svg\",\"/images/scenes/scene-4.svg\",\"/images/products/p02.svg\"]', '组合：鹅绒被+贡缎四件套+蚕丝对枕等十件', '「锦瑟和鸣」新婚十件套礼盒', 599900, 328, 'wedding-gift-box', '[{\"value\":\"十件套（详见商品参数页）\",\"label\":\"套内\"},{\"value\":\"苏绣缠枝莲纹 · 手工盘金\",\"label\":\"工艺\"},{\"value\":\"织云专属漆器礼盒 · 提袋\",\"label\":\"礼盒\"},{\"value\":\"免费礼品包装 · 可定制贺卡\",\"label\":\"服务\"}]', 'ACTIVE', 80, '琴瑟在御，莫不静好。织云婚嫁系列与苏州绣娘合作，把「白头偕老」四个字，绣进了往后每一个晨昏。', '婚嫁臻礼 · 苏绣纹样');
INSERT INTO `products` VALUES ('cmts59od4ykD3RDe9hFtz6NA', 'cmts59obdh9rjtHmXOUWg1wU', NULL, '2026-09-08 12:03:20.344000', '与前GUCCI印花设计总监联名，以莫奈《睡莲》为底本，数码直喷十六色渐变印花，把吉维尼花园搬进卧室。', b'1', '[\"/images/products/p10.svg\",\"/images/scenes/scene-5.svg\"]', '面料：80支长绒棉数码印花', '「莫奈花园」大师联名四件套', 219900, 967, 'monet-garden-set', '[{\"value\":\"前GUCCI印花设计总监工作室\",\"label\":\"联名\"},{\"value\":\"16色数码直喷 · 渐变无级\",\"label\":\"印花\"},{\"value\":\"80支长绒棉斜纹\",\"label\":\"面料\"},{\"value\":\"被套×1 床单×1 枕套×2\",\"label\":\"配置\"}]', 'ACTIVE', 200, '当莫奈的睡莲在枕畔泛起柔光，梦也有了颜色。艺术不必悬挂于墙——它可以被盖在身上。', '印象派印花 · 艺术家纺');
INSERT INTO `products` VALUES ('cmts59od9ChMpaOTDQs1GnLA', 'cmts59obdh9rjtHmXOUWg1wU', NULL, '2026-09-08 12:03:20.349000', '欧洲雨露麻，天然褶皱纹理与哑光质感，越洗越柔软。中性大地色系，任意床品皆可相融。', b'0', '[\"/images/products/p11.svg\",\"/images/scenes/scene-1.svg\"]', '面料：100% 欧洲雨露麻', '「原野」亚麻枕套对枕', 39900, 688, 'linen-pillowcase-pair', '[{\"value\":\"100% 欧洲雨露麻（4.2支）\",\"label\":\"面料\"},{\"value\":\"48×74cm 对装\",\"label\":\"规格\"},{\"value\":\"天然褶皱 · 哑光肌理\",\"label\":\"风格\"},{\"value\":\"可机洗 · 越洗越柔\",\"label\":\"洗涤\"}]', 'ACTIVE', 300, '亚麻是布料里的原野风。它不讨好肌肤，却让肌肤记得自由。', '雨露麻 · 天然肌理');
INSERT INTO `products` VALUES ('cmts59odc8pHkdcUZqo0kgFO', 'cmts59oa7vLEFbUzgyRef02p', 289900, '2026-09-08 12:03:20.352000', '澳洲美利奴细支羊毛，天然卷曲锁住静止空气，恒温锁暖不闷汗。羊毛脂亲肤，湿气管理能力是棉的2倍。', b'0', '[\"/images/products/p12.svg\",\"/images/scenes/scene-6.svg\"]', '填充：100% 澳洲美利奴羊毛；面料：全棉防羽布', '「暖山」澳洲羊毛冬被', 249900, 542, 'wool-winter-duvet', '[{\"value\":\"100% 澳洲美利奴羊毛\",\"label\":\"填充物\"},{\"value\":\"恒温锁暖 · 吸湿排汗\",\"label\":\"功能\"},{\"value\":\"约 1600g / 200×230cm\",\"label\":\"克重\"},{\"value\":\"Woolmark 国际羊毛局认证\",\"label\":\"认证\"}]', 'ACTIVE', 150, '山有暖意，被有羊毛。最古老的御寒智慧，配得上最现代的一夜好眠。', '澳洲美利奴羊毛 · 恒温锁暖');

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
INSERT INTO `sessions` VALUES ('cmts5rjlvyin9ZS0Mi5mo9Ks', '2026-09-08 12:17:13.987000', '2026-10-08 12:17:13.987000', '49319e5641f79c32dc4cc3b0dbc08acea06a8d7efe303b6d', 'cmts59of5azF8MsLGoB44zw4');
INSERT INTO `sessions` VALUES ('cmtsj1uyoLnTp8oOpBK7QEQU', '2026-09-08 18:29:10.272000', '2026-10-08 18:29:10.272000', 'cefbc2da62fc5b2f3604c01d6e14616279196b1a202d23be', 'cmts59of5azF8MsLGoB44zw4');

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
INSERT INTO `users` VALUES ('cmts59okopM4ElR6j1g27Zkd', '2026-09-08 12:03:20.616000', 'chenyu@example.com', '陈屿', '$2a$10$HIW2E9jHFNZstMPLTbBL1ewW0WJOIUykutD9ZmW5c1bnhMM.Bz5Hi', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmts59omhcWgCgTKZhOpb8jx', '2026-09-08 12:03:20.681000', 'suhe@example.com', '苏合', '$2a$10$nCa/2lnnURH6WXoNTY8OG.gWdUgpN4KNslUy/42tyJjP6/34LxIty', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmts59oo9ZfiQh8020oH2Kk9', '2026-09-08 12:03:20.747000', 'gubc@example.com', '顾北辰', '$2a$10$7uquErLWtdhfgWTXpZsuy.cB8cmpaUpNIM0e3HkCJa5jNIBmsQoRm', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmts59oq3ZimlnszOBCafEft', '2026-09-08 12:03:20.812000', 'baijin@example.com', '白槿', '$2a$10$oKsWriQkNKrseDUUOAXmKOYU.kMjLD2gsJ5f53vQ8X1k5w7YJAx8.', NULL, 'CUSTOMER');
INSERT INTO `users` VALUES ('cmts59os1DZyrhgMKeLxiHhx', '2026-09-08 12:03:20.881000', 'jiangli@example.com', '江离', '$2a$10$lAHb/rTuIHrSUPGG3z0vxORrFSoUwyJk1vf09K8aTxR8gWFUDGWtO', NULL, 'CUSTOMER');

SET FOREIGN_KEY_CHECKS = 1;
