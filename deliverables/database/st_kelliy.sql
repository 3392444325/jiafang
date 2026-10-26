-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: st_kelliy
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `st_kelliy`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `st_kelliy` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `st_kelliy`;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `city` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `district` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_default` bit(1) NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `province` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK1fa36y2oqhao3wgg2rw1pi459` (`user_id`) USING BTREE,
  CONSTRAINT `FK1fa36y2oqhao3wgg2rw1pi459` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES ('cmts59os75yTpHyzqptkkaQJ','杭州市','2026-09-08 12:03:20.887000','天目山路织云里 8 幢 1201 室','西湖区',_binary '','沈知微','13800006666','浙江省','cmts59ogzCppiSfx7fHWfzqL');
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `product_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `qty` int NOT NULL,
  `session_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `user_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_cart_product_user` (`product_id`,`user_id`) USING BTREE,
  UNIQUE KEY `uk_cart_product_session` (`product_id`,`session_id`) USING BTREE,
  KEY `FKfi06hnfi6os4n219jxwyw30g2` (`session_id`) USING BTREE,
  KEY `FK709eickf3kc0dujx3ub9i7btf` (`user_id`) USING BTREE,
  CONSTRAINT `FK1re40cjegsfvw58xrkdp6bac6` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK709eickf3kc0dujx3ub9i7btf` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKfi06hnfi6os4n219jxwyw30g2` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES ('cmttgje4svJnDB2FzB8Fvubc','2026-09-09 10:06:35.596000','cmts59odc8pHkdcUZqo0kgFO',4,NULL,'cmttgje3i8vetTGMn8FrZjY4'),('cmuxs5bwyOJ7WliXxciER2VR','2026-10-07 15:22:21.970000','cmttjtaqqX0a0a6P081E7WkW',2,'cmuxs5bwibRpfRmcbetNmc9V',NULL);
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name_en` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `slug` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort` int NOT NULL,
  `tagline` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UKoul14ho7bctbefv8jywp5v3i2` (`slug`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES ('cmts59oa7vLEFbUzgyRef02p','被芯','Duvets & Comforters','duvets',1,'云感深睡，四季安然'),('cmts59ob7ABu6nw14q4tzfBq','枕芯','Pillows','pillows',2,'承托之道，一夜安眠'),('cmts59obdh9rjtHmXOUWg1wU','床品套件','Bedding Sets','bedding-sets',3,'肌肤的第二层触感'),('cmts59obiyxgwLiF0WWBQcGW','夏凉系列','Summer Series','summer',4,'清风入梦，凉而不冰'),('cmts59oblOt8HyGkwqZH36QX','礼盒系列','Gift Boxes','gifts',5,'以东方之礼，赠重要之人');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leads`
--

DROP TABLE IF EXISTS `leads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leads` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `note` text,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads`
--

LOCK TABLES `leads` WRITE;
/*!40000 ALTER TABLE `leads` DISABLE KEYS */;
INSERT INTO `leads` VALUES ('cmts59otqhf4HAGz0fvvAFc4','2026-09-08 12:03:20.942000','陈立寒','意向杭州西湖区门店，面积约 80㎡，预算 30–50 万','13900001111','NEW','FRANCHISE'),('cmts59otuJc9rvnZagGGyoY0','2026-09-08 12:03:20.946000','林晓鸥','公司年会采购 40 套枕芯，希望一个月内交付','13700002222','CONTACTED','GROUP_BUY'),('cmts59otyQHoZfCbrEQPhDz1','2026-09-08 12:03:20.950000','郑屿舟','拟洽谈酒店渠道供应链合作','13600003333','CLOSED','COOPERATION'),('cmuqqf1gbWmkvb94Z2gNXVdh','2026-10-02 16:59:32.507000','限流测试-可删除','接口限流功能验证数据，可忽略','13800000000','NEW','COOPERATION'),('cmuqqf1i8nUOXRb97VdT9vBv','2026-10-02 16:59:32.576000','限流测试-可删除','接口限流功能验证数据，可忽略','13800000000','NEW','COOPERATION'),('cmuqqf1kxN1X6k8gPvdB1Fvk','2026-10-02 16:59:32.673000','限流测试-可删除','接口限流功能验证数据，可忽略','13800000000','NEW','COOPERATION'),('cmuqqf1o37BSJ5FCEN9SuqTW','2026-10-02 16:59:32.787000','限流测试-可删除','接口限流功能验证数据，可忽略','13800000000','NEW','COOPERATION'),('cmuqqf1rjwDFY5MuLz2WA14K','2026-10-02 16:59:32.911000','限流测试-可删除','接口限流功能验证数据，可忽略','13800000000','NEW','COOPERATION'),('cmuxs3ol0Ujns2ByJFuQEvdO','2026-10-07 15:21:05.076000','联调测试','小程序链路验证','13800001111','NEW','FRANCHISE'),('cmuxs4ltg1LMKMsEbmJcJtXx','2026-10-07 15:21:48.148000','联调测试','小程序链路验证','13800001111','NEW','FRANCHISE');
/*!40000 ALTER TABLE `leads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `category` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text NOT NULL,
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `excerpt` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `featured` bit(1) NOT NULL,
  `published` bit(1) NOT NULL,
  `published_at` datetime(6) DEFAULT NULL,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES ('cmuscl18x3QOsX4EgPUmG63X','新品发布','延续与前 GUCCI 印花设计总监的联名合作，第二季以《睡莲·黄昏》为灵感，新增四组暮金色号与十六色渐变直喷工艺，全球限量 3,000 套，每套附艺术家签名编号。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。','/images/heroes/hero-3.jpg','2026-08-28 00:00:00.000000','延续与前 GUCCI 印花设计总监的联名合作，第二季以《睡莲·黄昏》为灵感，新增四组暮金色号与十六色渐变直喷工艺，全球限量 3,000 套，每套附艺术家签名编号。',_binary '',_binary '','2026-08-28 00:00:00.000000','「莫奈花园」第二季上市：把睡莲的黄昏，织进一套四件套'),('cmuscl1axlk4uqqFMVzDHF9v','品牌新闻','双方将在未来三年推出四季联名系列，并联合设立「东方织造印花实验室」。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。',NULL,'2026-08-10 00:00:00.000000','双方将在未来三年推出四季联名系列，并联合设立「东方织造印花实验室」。',_binary '\0',_binary '','2026-08-10 00:00:00.000000','织云与前 GUCCI 印花设计总监完成三年续约'),('cmuscl1bbN2pwlXRUJD1gZd1','媒体报道','评审团评价：「云绒」系列以 95 白鹅绒与 27 项原材检测，重新定义了国产高端被芯的标尺。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。',NULL,'2026-07-20 00:00:00.000000','评审团评价：「云绒」系列以 95 白鹅绒与 27 项原材检测，重新定义了国产高端被芯的标尺。',_binary '\0',_binary '','2026-07-20 00:00:00.000000','《时尚家居》年度榜单：织云蝉联「年度鹅绒被」'),('cmuscl1bnfzqNPvDAxeZHDRf','活动回顾','织云联合睡眠研究机构发布《城市深睡白皮书》，并预告「深睡 2.0」系列。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。',NULL,'2026-06-18 00:00:00.000000','织云联合睡眠研究机构发布《城市深睡白皮书》，并预告「深睡 2.0」系列。',_binary '\0',_binary '','2026-06-18 00:00:00.000000','世界睡眠日·深睡论坛在杭州西子湖畔举办'),('cmuscl1byYVhD3C587rrLgcm','品牌新闻','新店以「东方织造美术馆」为概念，陈列 38 年来 12 件典藏织品。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。',NULL,'2026-05-30 00:00:00.000000','新店以「东方织造美术馆」为概念，陈列 38 年来 12 件典藏织品。',_binary '\0',_binary '','2026-05-30 00:00:00.000000','全国第 1,200 家门店落地成都 IFS'),('cmuscl1c7mM0NWDREru2G7Zf','新品发布','全新兰精天丝 500 织法，接触瞬凉 1.8℃，凉而不冰。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。',NULL,'2026-04-12 00:00:00.000000','全新兰精天丝 500 织法，接触瞬凉 1.8℃，凉而不冰。',_binary '\0',_binary '','2026-04-12 00:00:00.000000','「青岚」天丝夏凉系列全新升级'),('cmuscl1cjDTNBbIAazX5Y3ar','媒体报道','镜头深入织云工坊，记录一道被芯从绒朵到成品的完整旅程。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。',NULL,'2026-03-08 00:00:00.000000','镜头深入织云工坊，记录一道被芯从绒朵到成品的完整旅程。',_binary '\0',_binary '','2026-03-08 00:00:00.000000','央视《大国匠心》专题记录：43 道工序的织造'),('cmuscl1csuvPhUhXcxtHYSHR','品牌新闻','原材可追溯率提升至 86%，循环再生计划全年回收旧被 4.2 万床。\n\n如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n织云 ZHIYUN LIVING，以东方织造，致一世安眠。',NULL,'2026-01-15 00:00:00.000000','原材可追溯率提升至 86%，循环再生计划全年回收旧被 4.2 万床。',_binary '\0',_binary '','2026-01-15 00:00:00.000000','织云发布《2025 可持续发展报告》');
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `image_snap` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `name_snap` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `price_fen` int NOT NULL,
  `product_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `qty` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKbioxgbv59vetrxe0ejfubep1w` (`order_id`) USING BTREE,
  KEY `FKocimc7dtr037rh4ls4l95nlfi` (`product_id`) USING BTREE,
  CONSTRAINT `FKbioxgbv59vetrxe0ejfubep1w` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKocimc7dtr037rh4ls4l95nlfi` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES ('cmts59ot94oFFnovRYZOERO6','/images/products/p01.jpg','「云绒」95白鹅绒被','cmts59ot5CfHtFgrayZlAKF7',299900,'cmts59oc2El3OVZEX5rsoXkl',1),('cmts59otdxF4DlcNHTuK3E0u','/images/products/p04.jpg','「云朵」零压枕','cmts59ot5CfHtFgrayZlAKF7',39900,'cmts59ocgmIQavgFpqOxBEMA',1),('cmts59otmLKNxdcs4lIHEd4Y','/images/products/p05.jpg','「暮金」60支长绒棉四件套','cmts59oticOSWAoQJ8pAaAQ9',129900,'cmts59ockPbo4qDvLM2SAIjS',1),('cmtthh9yx2145RlhwyXhrWA7','/images/products/p12.jpg','「暖山」澳洲羊毛冬被','cmtthh9yvgHmJwZUFyatHxbG',249900,'cmts59odc8pHkdcUZqo0kgFO',2),('cmtthha4b6tbIDMrCN7DnaLA','/images/products/p12.jpg','「暖山」澳洲羊毛冬被','cmtthha4akTYV7g1UiCfn0uh',249900,'cmts59odc8pHkdcUZqo0kgFO',1),('cmttjukagh1DUIvTdsi9Tdy9','/images/products/p01.jpg','高级床垫','cmttjuka5rb5fw3FjZWBw6G9',2888800,'cmttjtaqqX0a0a6P081E7WkW',1),('cmuxscvnu2by6bTcyNvOnCIK','/images/products/p01.jpg','高级床垫','cmuxscvntxGuEFqYrTrBfIbD',2888800,'cmttjtaqqX0a0a6P081E7WkW',2);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address_json` text NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `paid_at` datetime(6) DEFAULT NULL,
  `pay_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `total_fen` int NOT NULL,
  `user_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cancel_requested` bit(1) NOT NULL,
  `cancel_requested_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UKg8pohnngqi5x1nask7nff2u7w` (`order_no`) USING BTREE,
  KEY `FK32ql8ubntj5uh44ph9659tiih` (`user_id`) USING BTREE,
  CONSTRAINT `FK32ql8ubntj5uh44ph9659tiih` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES ('cmts59ot5CfHtFgrayZlAKF7','{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}','2026-09-06 12:03:20.920000','ZY20260905-238801','2026-09-06 12:03:20.920000','WECHAT','PAID',339800,'cmts59ogzCppiSfx7fHWfzqL',_binary '\0',NULL),('cmts59oticOSWAoQJ8pAaAQ9','{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}','2026-09-08 12:03:20.934000','ZY20260906-410927',NULL,NULL,'PENDING_PAYMENT',129900,'cmts59ogzCppiSfx7fHWfzqL',_binary '\0',NULL),('cmtsaalchoiKoMBgtPQslM7I','{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}','2026-09-08 14:24:01.169000','ZY20260908-861146','2026-09-08 14:24:03.918000','WECHAT','PAID',49900,'cmts59ogzCppiSfx7fHWfzqL',_binary '\0',NULL),('cmtsiodyffd9fc8FQ6y5cFuq','{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}','2026-09-08 18:18:41.703000','ZY20260908-300785','2026-09-08 18:18:49.035000','WECHAT','PAID',388000,'cmts59ogzCppiSfx7fHWfzqL',_binary '\0',NULL),('cmtsiz9xlrsAVJpoPgKpoDDb','{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}','2026-09-08 18:27:09.705000','ZY20260908-891698','2026-09-08 18:27:22.264000','WECHAT','PAID',49900,'cmts59ogzCppiSfx7fHWfzqL',_binary '\0',NULL),('cmttfunlvAN5OoAbstIwujNE','{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}','2026-09-09 09:47:21.480000','ZY20260909094721453-001-9401','2026-09-09 09:47:25.617000','WECHAT','PAID',299900,'cmts59ogzCppiSfx7fHWfzqL',_binary '\0',NULL),('cmttgm3r4PqTrACPIOIDlspG','{\"name\":\"??\",\"phone\":\"13800000000\",\"region\":\"??? ???\",\"detail\":\"????1?\"}','2026-09-09 10:08:42.112000','ZY20260909100842108-001-5703',NULL,NULL,'CANCELLED',499800,'cmttgm3pg018DhXDD3J2RU7N',_binary '\0',NULL),('cmttgm3urqyKRK2pAQUXvYZg','{\"name\":\"??\",\"phone\":\"13800000000\",\"region\":\"??? ???\",\"detail\":\"????1?\"}','2026-09-09 10:08:42.243000','ZY20260909100842243-002-8940','2026-09-09 10:08:42.263000','WECHAT','CANCELLED',249900,'cmttgm3pg018DhXDD3J2RU7N',_binary '\0',NULL),('cmttgm41rqSdghl44GrMeo52','{\"name\":\"??\",\"phone\":\"13800000000\",\"region\":\"??? ???\",\"detail\":\"????1?\"}','2026-09-09 10:08:42.495000','ZY20260909100842494-003-4703','2026-09-09 10:08:42.513000','ALIPAY','PAID',249900,'cmttgm3pg018DhXDD3J2RU7N',_binary '\0',NULL),('cmttgrvbhCo1TD6ahpWk2gML','{\"name\":\"dbg\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}','2026-09-09 10:13:11.118000','ZY20260909101311114-001-2758',NULL,NULL,'CANCELLED',249900,'cmttgrv5pmc6AjEjVPRNYLwt',_binary '\0',NULL),('cmttgyhdz7BubbTTc2Zb1fjH','{\"name\":\"dbg2\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}','2026-09-09 10:18:19.656000','ZY20260909101819648-001-3874',NULL,NULL,'CANCELLED',499800,'cmttgyh6tirigxVYeWdepe7R',_binary '\0',NULL),('cmttgyhjm02fL8hVUUzQ3rW2','{\"name\":\"dbg2\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}','2026-09-09 10:18:19.858000','ZY20260909101819856-002-7272','2026-09-09 10:18:19.906000','WECHAT','CANCELLED',249900,'cmttgyh6tirigxVYeWdepe7R',_binary '\0',NULL),('cmtth9kfkXFMGOGSNGHQhI6x','{\"name\":\"dbg3\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}','2026-09-09 10:26:56.816000','ZY20260909102656813-001-2836',NULL,NULL,'CANCELLED',499800,'cmtth9k80Q3AWxEBpYIFXXoG',_binary '\0',NULL),('cmtthh9yvgHmJwZUFyatHxbG','{\"name\":\"final\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}','2026-09-09 10:32:56.503000','ZY20260909103256498-001-3111',NULL,NULL,'CANCELLED',499800,'cmtthh9rtnfWfOK55CnZvq83',_binary '\0',NULL),('cmtthha4akTYV7g1UiCfn0uh','{\"name\":\"final\",\"phone\":\"138\",\"region\":\"? ?\",\"detail\":\"x\"}','2026-09-09 10:32:56.699000','ZY20260909103256698-002-9912','2026-09-09 10:32:56.736000','WECHAT','CANCELLED',249900,'cmtthh9rtnfWfOK55CnZvq83',_binary '\0',NULL),('cmttjuka5rb5fw3FjZWBw6G9','{\"name\":\"沈知微\",\"phone\":\"13800006666\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"天目山路织云里 8 幢 1201 室\"}','2026-09-09 11:39:15.635000','ZY20260909113915599-001-7209','2026-09-09 11:39:21.744000','WECHAT','PAID',2888800,'cmts59ogzCppiSfx7fHWfzqL',_binary '\0',NULL),('cmuxscvntxGuEFqYrTrBfIbD','{\"name\":\"沈知微\",\"phone\":\"13800001111\",\"region\":\"浙江省 杭州市 西湖区\",\"detail\":\"测试路 1 号\"}','2026-10-07 15:28:14.153000','ZY20261007152814150-001-5107','2026-10-07 15:28:14.233000','WECHAT','PAID',5777600,'cmts59ogzCppiSfx7fHWfzqL',_binary '\0',NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `category_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `compare_at_fen` int DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` text NOT NULL,
  `featured` bit(1) NOT NULL,
  `images` text NOT NULL,
  `material` text,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `price_fen` int NOT NULL,
  `sales` int NOT NULL,
  `slug` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `specs` text,
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `stock` int NOT NULL,
  `story` text,
  `subtitle` varchar(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UKostq1ec3toafnjok09y9l7dox` (`slug`) USING BTREE,
  KEY `FKog2rp4qthbtt2lfyhfo32lsw9` (`category_id`) USING BTREE,
  CONSTRAINT `FKog2rp4qthbtt2lfyhfo32lsw9` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES ('cmts59oc2El3OVZEX5rsoXkl','cmts59oa7vLEFbUzgyRef02p',368000,'2026-09-08 12:03:20.306000','甄选北纬45°黄金绒带95%白鹅绒，蓬松度800+，如云朵般轻盈包裹。100支全棉防绒面料，静音柔滑，锁温透气兼得。',_binary '','[\"/images/products/p01.jpg\",\"/images/scenes/scene-2.jpg\",\"/images/products/p06.jpg\"]','填充：95%白鹅绒；面料：100支全棉防绒布','「云绒」95白鹅绒被',299900,1287,'cloud-goose-down-duvet','[{\"value\":\"95% 白鹅绒（蓬松度 800+）\",\"label\":\"填充物\"},{\"value\":\"100支全棉防绒面料\",\"label\":\"面料\"},{\"value\":\"冬款约 1100g / 200×230cm\",\"label\":\"克重\"},{\"value\":\"立衬分区 · 五重防钻绒\",\"label\":\"工艺\"}]','ACTIVE',199,'一朵云的重量，约等于一夜安眠。织云走遍东北与西伯利亚绒源地，只为找到那束绒朵饱满、干净无杂的白鹅绒——以28年羽绒工艺，织就这张值得托付终身的被。','95% 白鹅绒 · 100支防绒棉面料'),('cmts59oc9DjCflo2ehWqwkw5','cmts59oa7vLEFbUzgyRef02p',NULL,'2026-09-08 12:03:20.313000','选用江浙优质蚕区100%桑蚕丝长丝，绵韧贴身、轻盈透气。传统手工定位工艺，丝胎经年不移位，四季皆宜。',_binary '','[\"/images/products/p02.jpg\",\"/images/scenes/scene-1.jpg\"]','填充：100% 桑蚕丝长丝；面料：60支天丝棉','「云丝」桑蚕丝长丝被',388000,863,'silk-mulberry-duvet','[{\"value\":\"100% 桑蚕丝长丝\",\"label\":\"填充物\"},{\"value\":\"60支天丝棉混纺\",\"label\":\"面料\"},{\"value\":\"手工定位 · 丝胎免翻新\",\"label\":\"工艺\"},{\"value\":\"约 2000g / 200×230cm\",\"label\":\"净重\"}]','ACTIVE',149,'一颗茧，可抽丝千米。织云只取一级桑蚕丝长丝，沿袭江南蚕坊手工拉制定位古法——让千年的温柔，落在你枕畔。','100% 桑蚕丝长丝 · 手工定位'),('cmts59ocdiQElOBzjOF1aMhJ','cmts59ob7ABu6nw14q4tzfBq',59900,'2026-09-08 12:03:20.317000','三区立体承托设计，仰睡侧睡各得其所；内芯融合托玛琳矿物颗粒，温感自热，促进颈部微循环，抗菌防螨率99%。',_binary '','[\"/images/products/p03.jpg\",\"/images/products/p04.jpg\"]','内芯：托玛琳复合颗粒 + 高弹纤维；面料：60支抗菌针织棉','「深睡」托玛琳抗菌枕',49900,2303,'deep-sleep-pillow','[{\"value\":\"三区承托（侧睡/仰睡/颈椎承托）\",\"label\":\"结构\"},{\"value\":\"温感自热 · 99%抗菌防螨\",\"label\":\"功能\"},{\"value\":\"48×74cm\",\"label\":\"尺寸\"},{\"value\":\"德国红点设计奖获奖系列\",\"label\":\"认证\"}]','ACTIVE',498,'好枕头，是颈椎的年假。织云联合睡眠实验室，历经217次人体工学测试——只为让你入睡的第一分钟，就开始深睡。','分区承托 · 温感自热'),('cmts59ocgmIQavgFpqOxBEMA','cmts59ob7ABu6nw14q4tzfBq',NULL,'2026-09-08 12:03:20.320000','5秒慢回弹记忆棉，随头颈曲线温柔包裹，压力分散零死角。外层天珠棉面料，亲肤可机洗。',_binary '\0','[\"/images/products/p04.jpg\",\"/images/scenes/scene-3.jpg\"]','内芯：高密度慢回弹记忆棉；面料：天珠棉','「云朵」零压枕',39900,3105,'zero-pressure-pillow','[{\"value\":\"高密度慢回弹记忆棉\",\"label\":\"内芯\"},{\"value\":\"5 秒慢回弹\",\"label\":\"回弹\"},{\"value\":\"50×30cm 波浪双高\",\"label\":\"尺寸\"},{\"value\":\"可拆洗天珠棉外套\",\"label\":\"外套\"}]','ACTIVE',500,'把头交给一朵云。零压，不是没有支撑，而是每一寸都被恰好接住。','慢回弹记忆棉 · 云感零压'),('cmts59ockPbo4qDvLM2SAIjS','cmts59obdh9rjtHmXOUWg1wU',159900,'2026-09-08 12:03:20.324000','60支新疆长绒棉，缎纹织造，触感如丝。暮金色调取自黄昏最后一缕光，活性印染，久洗如新。',_binary '','[\"/images/products/p05.jpg\",\"/images/scenes/scene-1.jpg\",\"/images/scenes/scene-4.jpg\"]','面料：60支新疆长绒棉缎纹','「暮金」60支长绒棉四件套',129900,1789,'mu-jin-60s-set','[{\"value\":\"60支新疆长绒棉 · 贡缎缎纹\",\"label\":\"面料\"},{\"value\":\"活性印染 · 环保固色\",\"label\":\"工艺\"},{\"value\":\"被套×1 床单×1 枕套×2\",\"label\":\"配置\"},{\"value\":\"适用 200×230cm 被芯\",\"label\":\"尺寸\"}]','ACTIVE',300,'暮色四合时，最想回到的地方。以日落时分的天光为灵感，把一天的疲惫，温柔收进这一床暮金里。','60支新疆长绒棉 · 活性印染'),('cmts59oco3zV9JW10doPx2kz','cmts59obdh9rjtHmXOUWg1wU',NULL,'2026-09-08 12:03:20.328000','100支贡缎素织，经纬密度冠绝同业，光如月色流转。无印染添加，本色即高级。',_binary '\0','[\"/images/products/p06.jpg\",\"/images/scenes/scene-2.jpg\"]','面料：100支精梳棉贡缎','「月白」100支贡缎四件套',189900,756,'yue-bai-100s-set','[{\"value\":\"100支精梳长绒棉贡缎\",\"label\":\"面料\"},{\"value\":\"素织免染 · 本色呈现\",\"label\":\"工艺\"},{\"value\":\"被套×1 床单×1 枕套×2\",\"label\":\"配置\"},{\"value\":\"缎面月光光泽\",\"label\":\"光泽\"}]','ACTIVE',200,'月白，是中国人最含蓄的奢华。不着一色，自有万色——织得进月光，也睡得下星河。','100支贡缎 · 素色美学'),('cmts59octYhikfhk2jJB5qEt','cmts59obiyxgwLiF0WWBQcGW',109900,'2026-09-08 12:03:20.333000','奥地利兰精天丝纤维，Q-max凉感系数0.36，触肤瞬凉2-3℃。轻盈如岚，吸湿透气，空调房与闷热夜的两全法。',_binary '','[\"/images/products/p07.jpg\",\"/images/scenes/scene-5.jpg\"]','面料：100% 兰精天丝；填充：凉感纤维','「青岚」天丝凉感夏被',89900,4021,'tencel-cool-quilt','[{\"value\":\"Q-max ≥ 0.36（A类优等）\",\"label\":\"凉感值\"},{\"value\":\"100% 奥地利兰精天丝\",\"label\":\"面料\"},{\"value\":\"约 800g / 200×230cm\",\"label\":\"净重\"},{\"value\":\"可机洗 · 免翻晒\",\"label\":\"洗涤\"}]','ACTIVE',600,'夏夜的凉，应当像山间青岚——拂面而不浸骨。以森林之势取材，归还森林以敬意。','兰精天丝 · 接触瞬凉'),('cmts59ocwU3Hqy6blYqBK1zA','cmts59ob7ABu6nw14q4tzfBq',NULL,'2026-09-08 12:03:20.336000','国家A类母婴安全标准，物理防螨无化学添加。分龄高度设计，守护3-12岁每一个成长期的颈椎。',_binary '\0','[\"/images/products/p08.jpg\",\"/images/scenes/scene-3.jpg\"]','内芯：抗菌中空纤维；面料：A类精梳棉','「稚梦」儿童抗菌防螨枕',29900,1544,'kids-anti-mite-pillow','[{\"value\":\"GB 18401 A类母婴级\",\"label\":\"标准\"},{\"value\":\"物理防螨 · 无化学助剂\",\"label\":\"防螨\"},{\"value\":\"3-6岁 / 7-12岁 双档高度\",\"label\":\"分龄\"},{\"value\":\"40×60cm\",\"label\":\"尺寸\"}]','ACTIVE',400,'孩子的睡眠里，藏着长高的秘密。像守护第一颗乳牙一样，守护他的第一只枕头。','A类母婴级 · 分龄承托'),('cmts59oczwg86eZ5WSJlBLib','cmts59oblOt8HyGkwqZH36QX',699900,'2026-09-08 12:03:20.339000','取意「锦瑟无端五十弦」，十件套涵盖鹅绒被、贡缎套件、蚕丝枕与新婚对枕。苏绣缠枝莲纹，一针一线皆是祝福。',_binary '','[\"/images/products/p09.jpg\",\"/images/scenes/scene-4.jpg\",\"/images/products/p02.jpg\"]','组合：鹅绒被+贡缎四件套+蚕丝对枕等十件','「锦瑟和鸣」新婚十件套礼盒',599900,328,'wedding-gift-box','[{\"value\":\"十件套（详见商品参数页）\",\"label\":\"套内\"},{\"value\":\"苏绣缠枝莲纹 · 手工盘金\",\"label\":\"工艺\"},{\"value\":\"织云专属漆器礼盒 · 提袋\",\"label\":\"礼盒\"},{\"value\":\"免费礼品包装 · 可定制贺卡\",\"label\":\"服务\"}]','ACTIVE',80,'琴瑟在御，莫不静好。织云婚嫁系列与苏州绣娘合作，把「白头偕老」四个字，绣进了往后每一个晨昏。','婚嫁臻礼 · 苏绣纹样'),('cmts59od4ykD3RDe9hFtz6NA','cmts59obdh9rjtHmXOUWg1wU',NULL,'2026-09-08 12:03:20.344000','与前GUCCI印花设计总监联名，以莫奈《睡莲》为底本，数码直喷十六色渐变印花，把吉维尼花园搬进卧室。',_binary '','[\"/images/products/p10.jpg\",\"/images/scenes/scene-5.jpg\"]','面料：80支长绒棉数码印花','「莫奈花园」大师联名四件套',219900,967,'monet-garden-set','[{\"value\":\"前GUCCI印花设计总监工作室\",\"label\":\"联名\"},{\"value\":\"16色数码直喷 · 渐变无级\",\"label\":\"印花\"},{\"value\":\"80支长绒棉斜纹\",\"label\":\"面料\"},{\"value\":\"被套×1 床单×1 枕套×2\",\"label\":\"配置\"}]','ACTIVE',200,'当莫奈的睡莲在枕畔泛起柔光，梦也有了颜色。艺术不必悬挂于墙——它可以被盖在身上。','印象派印花 · 艺术家纺'),('cmts59od9ChMpaOTDQs1GnLA','cmts59obdh9rjtHmXOUWg1wU',NULL,'2026-09-08 12:03:20.349000','欧洲雨露麻，天然褶皱纹理与哑光质感，越洗越柔软。中性大地色系，任意床品皆可相融。',_binary '\0','[\"/images/products/p11.jpg\",\"/images/scenes/scene-1.jpg\"]','面料：100% 欧洲雨露麻','「原野」亚麻枕套对枕',39900,688,'linen-pillowcase-pair','[{\"value\":\"100% 欧洲雨露麻（4.2支）\",\"label\":\"面料\"},{\"value\":\"48×74cm 对装\",\"label\":\"规格\"},{\"value\":\"天然褶皱 · 哑光肌理\",\"label\":\"风格\"},{\"value\":\"可机洗 · 越洗越柔\",\"label\":\"洗涤\"}]','ACTIVE',300,'亚麻是布料里的原野风。它不讨好肌肤，却让肌肤记得自由。','雨露麻 · 天然肌理'),('cmts59odc8pHkdcUZqo0kgFO','cmts59oa7vLEFbUzgyRef02p',289900,'2026-09-08 12:03:20.352000','澳洲美利奴细支羊毛，天然卷曲锁住静止空气，恒温锁暖不闷汗。羊毛脂亲肤，湿气管理能力是棉的2倍。',_binary '\0','[\"/images/products/p12.jpg\",\"/images/scenes/scene-6.jpg\"]','填充：100% 澳洲美利奴羊毛；面料：全棉防羽布','「暖山」澳洲羊毛冬被',249900,552,'wool-winter-duvet','[{\"value\":\"100% 澳洲美利奴羊毛\",\"label\":\"填充物\"},{\"value\":\"恒温锁暖 · 吸湿排汗\",\"label\":\"功能\"},{\"value\":\"约 1600g / 200×230cm\",\"label\":\"克重\"},{\"value\":\"Woolmark 国际羊毛局认证\",\"label\":\"认证\"}]','ACTIVE',140,'山有暖意，被有羊毛。最古老的御寒智慧，配得上最现代的一夜好眠。','澳洲美利奴羊毛 · 恒温锁暖'),('cmttjtaqqX0a0a6P081E7WkW','cmts59obdh9rjtHmXOUWg1wU',NULL,'2026-09-09 11:38:16.610000','极致柔软，安心睡眠',_binary '\0','[\"/images/products/p01.jpg\"]',NULL,'高级床垫',2888800,3,'zy-mttjtaql',NULL,'ACTIVE',886,NULL,NULL),('cmuqokknsqeVtCgvCsH9iAm6','cmts59oa7vLEFbUzgyRef02p',NULL,'2026-10-02 16:07:51.448000','端到端测试商品',_binary '\0','[\"/images/products/p02.jpg\"]',NULL,'E2E测试商品',129900,0,'zy-muqokkno',NULL,'OFF',50,NULL,'测试副标题');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `product_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `rating` int NOT NULL,
  `user_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKpl51cejpw4gy5swfar8br9ngi` (`product_id`) USING BTREE,
  KEY `FKcgy7qjc1r99dp117y9en6lxye` (`user_id`) USING BTREE,
  CONSTRAINT `FKcgy7qjc1r99dp117y9en6lxye` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKpl51cejpw4gy5swfar8br9ngi` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES ('cmts59osbAU8lTLmzCTA5IfK','像睡进一朵云里。北方的冬天暖气很足，这床被居然完全不闷，蓬松度名不虚传。','2026-09-08 12:03:20.891000','cmts59oc2El3OVZEX5rsoXkl',5,'cmts59oitsiceH9H1rDsdqgY'),('cmts59osef8WVC5SNGTSGiyy','给父母买的，二老说比国外买的某大牌还要暖和轻盈，客服也很耐心。','2026-09-08 12:03:20.895000','cmts59oc2El3OVZEX5rsoXkl',5,'cmts59okopM4ElR6j1g27Zkd'),('cmts59osjMX0KZhwVQZThbPn','蚕丝被贴身的那种柔软很难形容，就是睡下去不想起来。包装也极有质感，送礼体面。','2026-09-08 12:03:20.899000','cmts59oc9DjCflo2ehWqwkw5',5,'cmts59omhcWgCgTKZhOpb8jx'),('cmts59osmIYLlPGTQKLdFU93','颈椎承托区的设计确实到位，温感微微发热很舒服，唯一希望出个更矮的款。','2026-09-08 12:03:20.902000','cmts59ocdiQElOBzjOF1aMhJ',4,'cmts59oo9ZfiQh8020oH2Kk9'),('cmts59ospmdeqqDkZQfS4YzU','慢回弹真的零压，侧睡肩膀不酸了。已经回购第二只给男朋友。','2026-09-08 12:03:20.905000','cmts59ocgmIQavgFpqOxBEMA',5,'cmts59oitsiceH9H1rDsdqgY'),('cmts59ostAs2cFWzSjKRS2pJ','暮金色比图片更温柔，缎纹的垂坠感一铺上床整个卧室都高级了。','2026-09-08 12:03:20.909000','cmts59ockPbo4qDvLM2SAIjS',5,'cmts59oq3ZimlnszOBCafEft'),('cmts59osvDEr29eroGlDKMxO','印花渐变太美了，没有任何色差和异味，朋友以为是美术馆的联名。','2026-09-08 12:03:20.911000','cmts59od4ykD3RDe9hFtz6NA',5,'cmts59os1DZyrhgMKeLxiHhx'),('cmts59oszjBpBR9M86TKfQ1L','闺蜜结婚送的，苏绣礼盒一打开全场惊叹，绣工确实是大师级。','2026-09-08 12:03:20.915000','cmts59oczwg86eZ5WSJlBLib',5,'cmts59okopM4ElR6j1g27Zkd'),('cmuxs5cdfuvuN9SPmFGGkBLj','小程序联调链路验证评价','2026-10-07 15:22:22.563000','cmttjtaqqX0a0a6P081E7WkW',5,'cmts59ogzCppiSfx7fHWfzqL');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UKnr21vuswfbmr91q57xdbnou5f` (`token`) USING BTREE,
  KEY `FKruie73rneumyyd1bgo6qw8vjt` (`user_id`) USING BTREE,
  CONSTRAINT `FKruie73rneumyyd1bgo6qw8vjt` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('cmuqoglwribfsBtheZL2gAIo','2026-10-02 16:04:46.443000','2026-11-01 16:04:46.438000','82fa6758df9783de8e522c3256d653ee64731d8399a5bace','cmts59of5azF8MsLGoB44zw4'),('cmuqogwg3qJF7g98J7opR0aw','2026-10-02 16:05:00.099000','2026-11-01 16:05:00.099000','5d556f699f3d2c4de6cc46b118a74ef270c350cd052d8a52','cmts59of5azF8MsLGoB44zw4'),('cmuqoh8fhfcU5VcVVGwSk6il','2026-10-02 16:05:15.629000','2026-11-01 16:05:15.629000','473af1aa1c30bd1ba28b273564a6b6526f5cecabe5757167','cmts59of5azF8MsLGoB44zw4'),('cmuqoie29zQKkPmrkeytXWWz','2026-10-02 16:06:09.585000','2026-11-01 16:06:09.585000','557527c721cc30b3cef37b28bb9c147dcf26b1cbe1ac93c8','cmts59of5azF8MsLGoB44zw4'),('cmuqokkasz4xZsdqGFtAkTVz','2026-10-02 16:07:50.980000','2026-11-01 16:07:50.976000','b30b10dc880f0f7df38cb7f7f9f8aa36329475272b74e25e','cmts59of5azF8MsLGoB44zw4'),('cmuqomq4r8s3D59X7c41O55W','2026-10-02 16:09:31.851000','2026-11-01 16:09:31.850000','66a4a5c0ba6338d8cc357ecf4be0431eae38cc1e63121824','cmts59of5azF8MsLGoB44zw4'),('cmuqonn7pT8xyKsC1FsqWNAn','2026-10-02 16:10:14.725000','2026-11-01 16:10:14.725000','8e80f042cccf3ca6a5ccd90c0ad0704ef5f3fb0b35bfe83c','cmts59of5azF8MsLGoB44zw4'),('cmuqoszj5Az63y8H5E0DhB9H','2026-10-02 16:14:23.969000','2026-11-01 16:14:23.969000','7bf37a95ab137bf5ab397b102d3ee4f6198932c053510328','cmts59of5azF8MsLGoB44zw4'),('cmuqq1fx9AGkodVf5t2B2F8j','2026-10-02 16:48:58.078000','2026-11-01 16:48:58.071000','68ad74625c53146916c64499d77ed99594a7e984824705eb','cmts59of5azF8MsLGoB44zw4'),('cmuqqdwhffJf5GLXePJ4gBsE','2026-10-02 16:58:39.411000','2026-11-01 16:58:39.407000','903cd7bfea667855e52d4e21fe71190823594bf201f721fe','cmts59of5azF8MsLGoB44zw4'),('cmuqqepa8YtTS28dTicajZeD','2026-10-02 16:59:16.736000','2026-11-01 16:59:16.736000','5d42cd4b38f38b0cf2437cc7424161554635295a25a92ab9','cmts59of5azF8MsLGoB44zw4'),('cmuqqepvhM4fMX8bEQm4d4Bn','2026-10-02 16:59:17.502000','2026-11-01 16:59:17.501000','958aefd958a0d6ef9c290af4f38809e3d935030ec3a790da','cmts59of5azF8MsLGoB44zw4'),('cmuscl218HBTzZ2wbiYNh94W','2026-10-03 20:07:50.924000','2026-11-02 20:07:50.922000','2117cf33e75414f68193b6ef607793ebbedb6c796c1a0421','cmts59of5azF8MsLGoB44zw4'),('cmusclo8xdK34w95WdorTEKW','2026-10-03 20:08:19.713000','2026-11-02 20:08:19.713000','53db9c32b6a7d523581941acc0a8301868de273dbcde37e6','cmts59of5azF8MsLGoB44zw4'),('cmuscmkgyHfJumst9SOH1ed4','2026-10-03 20:09:01.474000','2026-11-02 20:09:01.474000','baf9f7655a574b8a5954027f4d00f522751ca62574329376','cmts59of5azF8MsLGoB44zw4'),('cmutddgkuevbnHYbaXhec4jN','2026-10-04 13:17:42.318000','2026-11-03 13:17:42.308000','3bce961a0905f846c61bd329d4f3764dfce2e5f65fae5936','cmts59of5azF8MsLGoB44zw4'),('cmuxpzjl8L0C8bPlmHOusE6V','2026-10-07 14:21:52.748000','2026-11-06 14:21:52.737000','c0d4de14f60faac7828f2e886ca1849c896d02a1d3932adb','cmts59of5azF8MsLGoB44zw4'),('cmuxs3o2lryQc8BVUFqJfHpH','2026-10-07 15:21:04.413000','2026-11-06 15:21:04.409000','0672f9039f282fe9b7d5700fef6afe0cc34e0a235821a8df','cmts59ogzCppiSfx7fHWfzqL'),('cmuxs4le65UTsZheGO8i56Vl','2026-10-07 15:21:47.600000','2026-11-06 15:21:47.598000','b8f927cb023cb58aafb4d8a7499ae12c11280d5158cd3492','cmts59ogzCppiSfx7fHWfzqL'),('cmuxs5bwibRpfRmcbetNmc9V','2026-10-07 15:22:21.955000','2026-11-06 15:22:21.954000','ccaa9da22746e560af3e7ef380b061fc27583fa6223c6f4a',NULL),('cmuxs5c2mUrfcgNJuvokQJlj','2026-10-07 15:22:22.175000','2026-11-06 15:22:22.174000','413dc8ea8fd8bf9ac371b8556bd012a4c64258ca23062290','cmts59ogzCppiSfx7fHWfzqL'),('cmuxs60nhfJnp4wwlpyaoWcO','2026-10-07 15:22:54.029000','2026-11-06 15:22:54.029000','c8ad5c301a55e5a33f0d69d3d764716bd9018f9c4c3bffc3','cmts59ogzCppiSfx7fHWfzqL'),('cmuxs7gt0TZB1kNZCbZCnM9b','2026-10-07 15:24:01.620000','2026-11-06 15:24:01.620000','bd6b411e1d9ea2575be3b2dea48e19dfe828735fdca6ee50','cmts59ogzCppiSfx7fHWfzqL'),('cmuxscvibSwiWXKzDNsaZUzK','2026-10-07 15:28:13.955000','2026-11-06 15:28:13.955000','670272c96a5c9d529dd21f3c2640e0ba3f7a655347e0c4c5','cmts59ogzCppiSfx7fHWfzqL'),('cmv9c09ps4XzZEZ2H28hCjbD','2026-10-15 17:23:46.096000','2026-11-14 17:23:46.064000','55519204ed06d74173c50c813e0c5ad7fb5c9a393943f62d','cmts59of5azF8MsLGoB44zw4'),('cmv9dkidbRROZRc5bfmfOnqR','2026-10-15 18:07:30.047000','2026-11-14 18:07:30.045000','b174cd1d384787f7fd8bc167e72fd06fe977de111f882014','cmts59of5azF8MsLGoB44zw4');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_content`
--

DROP TABLE IF EXISTS `site_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_content` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_json` text NOT NULL,
  `content_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK2ve1ysexh1fqquvs0k1ljaldj` (`content_key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_content`
--

LOCK TABLES `site_content` WRITE;
/*!40000 ALTER TABLE `site_content` DISABLE KEYS */;
INSERT INTO `site_content` VALUES ('cmuqoiea4z509ZzZ3i2ZQg1t','{\"slides\":[{\"src\":\"/images/heroes/hero-1.jpg\",\"eyebrow\":\"ZHIYUN LIVING · Since 1988\",\"title\":\"以东方织造，\\n致一世安眠\",\"sub\":\"三十八年，三代织人，一件事：把「睡个好觉」，做成值得传家的东西。\",\"href\":\"/story\",\"cta\":\"走进品牌\"},{\"src\":\"/images/heroes/hero-2.jpg\",\"eyebrow\":\"Craftsmanship · 匠心\",\"title\":\"不赶时间，只赶手艺\",\"sub\":\"绒朵、长丝与贡缎——95% 的预算花在看不见的地方。27 项原材检测，43 道出厂工序。\",\"href\":\"/story\",\"cta\":\"了解匠心\"},{\"src\":\"/images/heroes/hero-3.jpg\",\"eyebrow\":\"Master Collaboration · 大师联名\",\"title\":\"当莫奈的睡莲，\\n开在枕畔\",\"sub\":\"与前GUCCI印花设计总监联名，十六色渐变直喷——艺术家纺，自此有了模样。\",\"href\":\"/shop\",\"cta\":\"走进官方商城\"}]}','home.hero','2026-10-02 16:20:20.390000'),('cmuqoieadIiVyz21NIlSBxV4','{\"img\":\"/images/heroes/hero-2.jpg\",\"eyebrow\":\"Zhiyun Official Store\",\"title\":\"秋季焕新 · 官方商城\",\"sub\":\"全场满 ¥1,299 减 ¥150 · 顺丰包邮 · 30 天无忧退换\\n新会员注册即赠 ¥100 礼遇\"}','shop.hero','2026-10-02 16:20:20.399000'),('cmuqomqhgFaXYL8wDrnPYN0V','{\"eyebrow\":\"Philosophy\",\"title\":\"织云，织的是时间\",\"desc\":\"从一颗茧、一束绒到一寸缎，织云坚持最古老的方式：不赶时间，只赶手艺。我们把「睡个好觉」这件事，做成了值得传家的东西。\"}','home.philosophy','2026-10-02 16:20:20.394000'),('cmuqomqhoDksZu2I8yuvdoHc','{\"image\":\"\",\"title\":\"当莫奈的睡莲，\\n开在枕畔。\",\"desc\":\"与前 GUCCI 印花设计总监联手的艺术家纺系列——十六色渐变直喷工艺，将《睡莲》的光影移植到 100 支贡缎之上。\"}','home.collab','2026-10-02 16:20:20.397000'),('cmuqomqi4UgQHdW5Y2LbGffK','{\"img\":\"/images/scenes/scene-2.jpg\",\"eyebrow\":\"Newsroom\",\"title\":\"品牌动态\",\"sub\":\"织云的每一步，都与你有关——新品发布、品牌荣誉与来自一线的故事。\"}','news.hero','2026-10-02 16:20:20.401000'),('cmuscmkjzK3FnhoiZB6dUbnC','{\"img\":\"/images/scenes/scene-6.jpg\",\"eyebrow\":\"Our Story · Since 1988\",\"title\":\"以东方织造，\\n致一世安眠。\",\"sub\":\"三十八年，三代织人，一件事：把「睡个好觉」做成传家的东西。\"}','story.hero','2026-10-03 20:09:01.581000');
/*!40000 ALTER TABLE `site_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `password_hash` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `role` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('cmts59of5azF8MsLGoB44zw4','2026-09-08 12:03:20.417000','admin@zhiyun.cn','织云管理员','$2a$10$t3FwgrPwk01WCTR8/6Qg..d954zFrqQKnniNWS8apIgzhwspmTuBS',NULL,'ADMIN'),('cmts59ogzCppiSfx7fHWfzqL','2026-09-08 12:03:20.483000','demo@zhiyun.cn','沈知微','$2a$10$RMn38Lrwnm13hR2QuoJHGuA8qDcjny.LL.Ac7dBmEtyzaJ1lDQYSm','13800006666','CUSTOMER'),('cmts59oitsiceH9H1rDsdqgY','2026-09-08 12:03:20.549000','linww@example.com','林晚晚','$2a$10$tX625TjkvcSnIighl3yjVeGqvovBn0zZh3Xz1T9Gk/9L30ONbLyp2',NULL,'CUSTOMER'),('cmts59okopM4ElR6j1g27Zkd','2026-09-08 12:03:20.616000','123456','陈屿','123456',NULL,'CUSTOMER'),('cmts59omhcWgCgTKZhOpb8jx','2026-09-08 12:03:20.681000','suhe@example.com','苏合','$2a$10$nCa/2lnnURH6WXoNTY8OG.gWdUgpN4KNslUy/42tyJjP6/34LxIty',NULL,'CUSTOMER'),('cmts59oo9ZfiQh8020oH2Kk9','2026-09-08 12:03:20.747000','gubc@example.com','顾北辰','$2a$10$7uquErLWtdhfgWTXpZsuy.cB8cmpaUpNIM0e3HkCJa5jNIBmsQoRm',NULL,'CUSTOMER'),('cmts59oq3ZimlnszOBCafEft','2026-09-08 12:03:20.812000','baijin@example.com','白槿','$2a$10$oKsWriQkNKrseDUUOAXmKOYU.kMjLD2gsJ5f53vQ8X1k5w7YJAx8.',NULL,'CUSTOMER'),('cmts59os1DZyrhgMKeLxiHhx','2026-09-08 12:03:20.881000','jiangli@example.com','江离','$2a$10$lAHb/rTuIHrSUPGG3z0vxORrFSoUwyJk1vf09K8aTxR8gWFUDGWtO',NULL,'CUSTOMER'),('cmttgje3i8vetTGMn8FrZjY4','2026-09-09 10:06:35.551000','t639245451954635258@test.cn','????','$2a$10$HCzpuSYIPk38plug3YlaLeEPjFLMJA1yhWwQECX1./3omYCLe1LVC',NULL,'CUSTOMER'),('cmttgkx9axMqB2cWS3e0Zkt6','2026-09-09 10:07:47.038000','t2639245452669501888@test.cn','??2','$2a$10$unxjFjAU7AhzTu.rGbc9deVeliky98UYe6jL2R71SGxM3dD4fsOKG',NULL,'CUSTOMER'),('cmttgm3pg018DhXDD3J2RU7N','2026-09-09 10:08:42.052000','t639245453219699046@test.cn','????','$2a$10$eqYxSnxcI5zDf1n44QCYI.LeUfkgZLq/7ciKkvzjQ7IIhN4I31NGm',NULL,'CUSTOMER'),('cmttgrv5pmc6AjEjVPRNYLwt','2026-09-09 10:13:10.910000','t639245455907783431@test.cn','dbg','$2a$10$DPOLJDHLYZkVzcYvDFfoWu2ux/9m9IKfLI5hHvumwyTkFuuIOCFfu',NULL,'CUSTOMER'),('cmttgyh6tirigxVYeWdepe7R','2026-09-09 10:18:19.397000','t639245458991769827@test.cn','dbg2','$2a$10$yb050BbL7psoGKjQ.xcjD.RkuS7FyiqssXAfZsKcy.oDTfTsKFUzu',NULL,'CUSTOMER'),('cmtth9k80Q3AWxEBpYIFXXoG','2026-09-09 10:26:56.545000','t639245464162750696@test.cn','dbg3','$2a$10$BSICr3BEWmrUb1pK99uCL.zhsq83Yzp.Eth.wqg9C3YYLDc4Z40hq',NULL,'CUSTOMER'),('cmtthh9rtnfWfOK55CnZvq83','2026-09-09 10:32:56.249000','t639245467760859678@test.cn','final','$2a$10$DyMlcXMF2x24lFM.kRMw1e/4wG5Bbh7ryZeilXcTSMQV22yKNwqYC',NULL,'CUSTOMER'),('cmttj4w6qQWifWuLVgYkEtlk','2026-09-09 11:19:18.002000','ua639245495577674972@t.cn','??A','$2a$10$BZy73M1hs03xWaAC3A44OODWt6g6VLC/.nkUU7gPDxA9I.kii21g.',NULL,'CUSTOMER'),('cmttj4wbp01K9WrobErsFWfO','2026-09-09 11:19:18.181000','ub639245495577674972@t.cn','??B','$2a$10$fstYUdC6MNmYahONzxQNYOSvNioBsSYcQ51Q7U20CG7tyAbCAlCpa',NULL,'CUSTOMER');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'st_kelliy'
--

--
-- Dumping routines for database 'st_kelliy'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-18 16:27:06
