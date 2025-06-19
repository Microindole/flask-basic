/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 90200 (9.2.0)
 Source Host           : localhost:3306
 Source Schema         : flask_basic

 Target Server Type    : MySQL
 Target Server Version : 90200 (9.2.0)
 File Encoding         : 65001

 Date: 16/04/2025 11:37:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS `alembic_version`;
CREATE TABLE `alembic_version`  (
  `version_num` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`version_num`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of alembic_version
-- ----------------------------
INSERT INTO `alembic_version` VALUES ('b77ded64eebd');

-- ----------------------------
-- Table structure for answer
-- ----------------------------
DROP TABLE IF EXISTS `answer`;
CREATE TABLE `answer`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `question_id` int NULL DEFAULT NULL,
  `author_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `author_id`(`author_id` ASC) USING BTREE,
  INDEX `question_id`(`question_id` ASC) USING BTREE,
  CONSTRAINT `answer_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `answer_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of answer
-- ----------------------------
INSERT INTO `answer` VALUES (1, 'wwwww', '2025-03-08 14:41:05', 1, 2);
INSERT INTO `answer` VALUES (2, 'wwwww', '2025-03-08 14:43:25', 1, 2);
INSERT INTO `answer` VALUES (3, 'ssss', '2025-03-08 14:43:30', 1, 2);
INSERT INTO `answer` VALUES (4, 'ssss', '2025-03-08 14:44:53', 1, 2);
INSERT INTO `answer` VALUES (5, 'aaaa', '2025-03-08 14:45:02', 1, 2);
INSERT INTO `answer` VALUES (6, 'aaaa', '2025-03-08 14:46:44', 1, 2);
INSERT INTO `answer` VALUES (7, 'ffff', '2025-03-08 14:46:47', 1, 2);
INSERT INTO `answer` VALUES (8, 'refwrf', '2025-03-08 14:46:51', 1, 2);
INSERT INTO `answer` VALUES (9, 'kkk', '2025-03-08 15:47:45', 1, 2);
INSERT INTO `answer` VALUES (10, '就你也配！gold', '2025-03-08 20:43:54', 1, 3);
INSERT INTO `answer` VALUES (11, '你不过是废太子的一条狗！', '2025-03-08 20:44:47', 1, 2);
INSERT INTO `answer` VALUES (12, 'mvp', '2025-03-08 20:50:53', 5, 3);
INSERT INTO `answer` VALUES (13, 'aaa', '2025-04-03 11:45:43', 4, 2);

-- ----------------------------
-- Table structure for email_captcha
-- ----------------------------
DROP TABLE IF EXISTS `email_captcha`;
CREATE TABLE `email_captcha`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `captcha` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `used` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of email_captcha
-- ----------------------------

-- ----------------------------
-- Table structure for question
-- ----------------------------
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `author_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `author_id`(`author_id` ASC) USING BTREE,
  CONSTRAINT `question_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question
-- ----------------------------
INSERT INTO `question` VALUES (1, '二维体系中磁电阻量子', 'money+intellegent', '2025-03-08 13:20:46', 2);
INSERT INTO `question` VALUES (4, 'flask', 'advsfdbsdfbsgbdg', '2025-03-08 16:11:04', 2);
INSERT INTO `question` VALUES (5, '雍正王朝金句', '就你也配，gold，你不过是废太子的一条狗\r\n不听你的，大清就要亡国了？难说\r\n\r\n', '2025-03-08 20:49:09', 2);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `join_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (2, 'j2ee', 'scrypt:32768:8:1$tNOhZ89YYhCvnWxp$754aa31dcf9d54177d33740251ad730704483ade63ef66d3bb2cd5cc2992c4281241cf62e98df3cdd026bcbb06229347d413e12ca73680f3b689ef45955e9904', '1513979779@qq.com', '2025-03-08 11:20:18');
INSERT INTO `user` VALUES (3, 'Holly', 'scrypt:32768:8:1$CKfeBKAdRN2wAa1z$19a8af7a50123252768fb4ed51a557ccec9fbe24e2c74db46a830c5528f6dc5509e65eeaba3d938cb95ea2ac793f62e2071605bde24252b9bb83d73f625a5446', '3225340736@qq.com', '2025-03-08 20:43:22');

SET FOREIGN_KEY_CHECKS = 1;
