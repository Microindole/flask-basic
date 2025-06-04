/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : flask_basic

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 02/06/2025 17:16:30
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

/*
====================================
数据库版本管理表
用于存储Alembic迁移版本信息
====================================*/
DROP TABLE IF EXISTS `alembic_version`;
CREATE TABLE `alembic_version`  (
  `version_num` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`version_num`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

INSERT INTO `alembic_version` VALUES ('b77ded64eebd');

/*
====================================
回答表
存储用户对问题的回答信息
包含回答内容、创建时间、关联问题和作者
====================================*/
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
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
INSERT INTO `answer` VALUES (14, 'hello', '2025-05-23 13:29:38', 5, 3);
INSERT INTO `answer` VALUES (15, 'wwwww', '2025-06-02 17:02:00', 5, 2);

/*
====================================
回答审计日志表
记录回答的增删改操作历史
用于系统审计和数据追踪
====================================*/
DROP TABLE IF EXISTS `answer_audit_log`;
CREATE TABLE `answer_audit_log`  (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `answer_id` int NOT NULL,
  `operation_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `old_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `new_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `operation_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operated_by_user_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_answer_id`(`answer_id` ASC) USING BTREE,
  INDEX `idx_operation_time`(`operation_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

INSERT INTO `answer_audit_log` VALUES (1, 14, 'INSERT', NULL, 'hello', '2025-05-23 13:29:37', 3);
INSERT INTO `answer_audit_log` VALUES (2, 15, 'INSERT', NULL, 'wwwww', '2025-06-02 17:02:00', 2);

/*
====================================
邮箱验证码表
存储用户注册和验证时的邮箱验证码
包含验证码状态和有效期管理
====================================*/
DROP TABLE IF EXISTS `email_captcha`;
CREATE TABLE `email_captcha`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `captcha` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `used` tinyint(1) NOT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

/*
====================================
问题表
存储用户发布的问题信息
包含标题、内容、创建时间、作者和最后修改时间
支持点赞功能，包含点赞数统计字段
====================================*/
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `author_id` int NULL DEFAULT NULL,
  `last_modified_time` datetime NULL DEFAULT NULL,
  `likes_count` int NOT NULL DEFAULT 0 COMMENT '点赞数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `author_id`(`author_id` ASC) USING BTREE,
  CONSTRAINT `question_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

INSERT INTO `question` VALUES (1, '二维体系中磁电阻量子', 'money+intellegent', '2025-03-08 13:20:46', 2, '2025-03-08 13:20:46', 0);
INSERT INTO `question` VALUES (4, 'flask', 'advsfdbsdfbsgbdg', '2025-03-08 16:11:04', 2, '2025-03-08 16:11:04', 0);
INSERT INTO `question` VALUES (5, '雍正王朝金句', '就你也配，gold，你不过是废太子的一条狗\r\n不听你的，大清就要亡国了？难说\r\n\r\n', '2025-03-08 20:49:09', 2, '2025-06-02 17:02:00', 0);

/*
====================================
用户表
存储用户基本信息
包含用户名、密码、邮箱、加入时间和最后登录时间
====================================*/
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `join_time` datetime NULL DEFAULT NULL,
  `last_login_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

INSERT INTO `user` VALUES (2, 'j2ee', 'scrypt:32768:8:1$tNOhZ89YYhCvnWxp$754aa31dcf9d54177d33740251ad730704483ade63ef66d3bb2cd5cc2992c4281241cf62e98df3cdd026bcbb06229347d413e12ca73680f3b689ef45955e9904', '1513979779@qq.com', '2025-03-08 11:20:18', '2025-06-02 17:01:51');
INSERT INTO `user` VALUES (3, 'Holly', 'scrypt:32768:8:1$CKfeBKAdRN2wAa1z$19a8af7a50123252768fb4ed51a557ccec9fbe24e2c74db46a830c5528f6dc5509e65eeaba3d938cb95ea2ac793f62e2071605bde24252b9bb83d73f625a5446', '3225340736@qq.com', '2025-03-08 20:43:22', '2025-05-23 13:29:17');

/*
====================================
用户登录日志表
记录用户登录历史
包含登录时间和IP地址信息
用于安全审计和用户行为分析
====================================*/
DROP TABLE IF EXISTS `user_login_log`;
CREATE TABLE `user_login_log`  (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `login_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_user_id_login_time`(`user_id` ASC, `login_time` ASC) USING BTREE,
  CONSTRAINT `fk_user_login_log_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

INSERT INTO `user_login_log` VALUES (1, 2, '2025-05-23 13:28:25', NULL);
INSERT INTO `user_login_log` VALUES (2, 2, '2025-05-23 13:28:25', '127.0.0.1');
INSERT INTO `user_login_log` VALUES (3, 3, '2025-05-23 13:29:17', NULL);
INSERT INTO `user_login_log` VALUES (4, 3, '2025-05-23 13:29:17', '127.0.0.1');
INSERT INTO `user_login_log` VALUES (5, 2, '2025-05-23 13:37:30', NULL);
INSERT INTO `user_login_log` VALUES (6, 2, '2025-05-23 13:37:30', '127.0.0.1');
INSERT INTO `user_login_log` VALUES (7, 2, '2025-06-02 17:01:51', NULL);
INSERT INTO `user_login_log` VALUES (8, 2, '2025-06-02 17:01:51', '127.0.0.1');

/*
====================================
问题点赞表
记录用户对问题的点赞关系
支持点赞和取消点赞操作
每个用户对每个问题只能点赞一次
====================================*/
DROP TABLE IF EXISTS `question_likes`;
CREATE TABLE `question_likes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int NOT NULL,
  `user_id` int NOT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `question_user_like`(`question_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `question_likes_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `question_likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

/*
====================================
存储过程：批量失效过期验证码
根据天数阈值批量将未使用的过期验证码标记为已使用
用于定期清理过期验证码，释放系统资源
====================================*/
DROP PROCEDURE IF EXISTS `sp_deactivate_old_unused_captchas`;
delimiter ;;
CREATE PROCEDURE `sp_deactivate_old_unused_captchas`(IN days_threshold INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE current_captcha_id INT;
    DECLARE cur_old_captchas CURSOR FOR
        SELECT id
        FROM email_captcha
        WHERE used = FALSE AND create_time < DATE_SUB(NOW(), INTERVAL days_threshold DAY);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur_old_captchas;

    deactivate_loop: LOOP
        FETCH cur_old_captchas INTO current_captcha_id;
        IF done THEN
            LEAVE deactivate_loop;
        END IF;

        UPDATE email_captcha
        SET used = TRUE
        WHERE id = current_captcha_id;

    END LOOP deactivate_loop;

    CLOSE cur_old_captchas;
END
;;
delimiter ;

/*
====================================
存储过程：获取用户活跃度统计
查询指定用户的问题数量和回答数量
用于用户活跃度分析和展示
====================================*/
DROP PROCEDURE IF EXISTS `sp_get_user_activity_summary`;
delimiter ;;
CREATE PROCEDURE `sp_get_user_activity_summary`(IN user_id_param INT)
BEGIN
    SELECT
        (SELECT COUNT(*) FROM question WHERE author_id = user_id_param) AS total_questions,
        (SELECT COUNT(*) FROM answer WHERE author_id = user_id_param) AS total_answers;
END
;;
delimiter ;

/*
====================================
触发器：回答插入时更新问题最后修改时间
当有新回答时自动更新对应问题的最后修改时间
用于保持问题活跃度和排序
====================================*/
DROP TRIGGER IF EXISTS `trg_update_question_last_modified_on_answer`;
delimiter ;;
CREATE TRIGGER `trg_update_question_last_modified_on_answer` AFTER INSERT ON `answer` FOR EACH ROW BEGIN
    UPDATE question
    SET last_modified_time = NOW()
    WHERE id = NEW.question_id;
END
;;
delimiter ;

/*
====================================
触发器：记录回答插入操作
当插入新回答时自动记录到审计日志
用于系统审计和操作追踪
====================================*/
DROP TRIGGER IF EXISTS `trg_log_answer_insert`;
delimiter ;;
CREATE TRIGGER `trg_log_answer_insert` AFTER INSERT ON `answer` FOR EACH ROW BEGIN
    INSERT INTO `answer_audit_log` (`answer_id`, `operation_type`, `new_content`, `operation_time`, `operated_by_user_id`)
    VALUES (NEW.id, 'INSERT', NEW.content, NOW(), NEW.author_id);
END
;;
delimiter ;

/*
====================================
触发器：记录回答更新操作
当回答内容发生变化时自动记录到审计日志
用于内容变更追踪和审计
====================================*/
DROP TRIGGER IF EXISTS `trg_log_answer_update`;
delimiter ;;
CREATE TRIGGER `trg_log_answer_update` AFTER UPDATE ON `answer` FOR EACH ROW BEGIN
    IF OLD.content <> NEW.content THEN
        INSERT INTO `answer_audit_log` (`answer_id`, `operation_type`, `old_content`, `new_content`, `operation_time`, `operated_by_user_id`)
        VALUES (NEW.id, 'UPDATE', OLD.content, NEW.content, NOW(), NEW.author_id);
    END IF;
END
;;
delimiter ;

/*
====================================
触发器：记录回答删除操作
当删除回答时自动记录到审计日志
用于删除操作追踪和数据恢复
====================================*/
DROP TRIGGER IF EXISTS `trg_log_answer_delete`;
delimiter ;;
CREATE TRIGGER `trg_log_answer_delete` BEFORE DELETE ON `answer` FOR EACH ROW BEGIN
    INSERT INTO `answer_audit_log` (`answer_id`, `operation_type`, `old_content`, `operation_time`, `operated_by_user_id`)
    VALUES (OLD.id, 'DELETE', OLD.content, NOW(), OLD.author_id);
END
;;
delimiter ;

/*
====================================
触发器：记录用户登录日志
当用户登录时间发生变化时自动记录登录日志
用于用户活动追踪和安全审计
====================================*/
DROP TRIGGER IF EXISTS `trg_log_user_login`;
delimiter ;;
CREATE TRIGGER `trg_log_user_login` AFTER UPDATE ON `user` FOR EACH ROW BEGIN
    IF NEW.last_login_time IS NOT NULL AND (OLD.last_login_time IS NULL OR OLD.last_login_time <> NEW.last_login_time) THEN
        INSERT INTO `user_login_log` (`user_id`, `login_time`, `ip_address`)
        VALUES (NEW.id, NEW.last_login_time, NULL);
    END IF;
END
;;
delimiter ;

/*
====================================
触发器：点赞时更新问题点赞数
当用户点赞时自动更新问题的点赞数统计
保持点赞数的实时准确性
====================================*/
DROP TRIGGER IF EXISTS `trg_update_question_likes_count`;
delimiter ;;
CREATE TRIGGER `trg_update_question_likes_count` AFTER INSERT ON `question_likes` FOR EACH ROW BEGIN
    UPDATE question 
    SET likes_count = (SELECT COUNT(*) FROM question_likes WHERE question_id = NEW.question_id)
    WHERE id = NEW.question_id;
END
;;
delimiter ;

/*
====================================
触发器：取消点赞时更新问题点赞数
当用户取消点赞时自动更新问题的点赞数统计
保持点赞数的实时准确性
====================================*/
DROP TRIGGER IF EXISTS `trg_update_question_likes_count_on_delete`;
delimiter ;;
CREATE TRIGGER `trg_update_question_likes_count_on_delete` AFTER DELETE ON `question_likes` FOR EACH ROW BEGIN
    UPDATE question 
    SET likes_count = (SELECT COUNT(*) FROM question_likes WHERE question_id = OLD.question_id)
    WHERE id = OLD.question_id;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
