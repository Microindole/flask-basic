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

 Date: 24/05/2025 14:06:54
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
INSERT INTO `answer` VALUES (14, 'hello', '2025-05-23 13:29:38', 5, 3);

-- ----------------------------
-- Table structure for answer_audit_log
-- ----------------------------
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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of answer_audit_log
-- ----------------------------
INSERT INTO `answer_audit_log` VALUES (1, 14, 'INSERT', NULL, 'hello', '2025-05-23 13:29:37', 3);

-- ----------------------------
-- Table structure for email_captcha
-- ----------------------------
DROP TABLE IF EXISTS `email_captcha`;
CREATE TABLE `email_captcha`  (
                                  `id` int NOT NULL AUTO_INCREMENT,
                                  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                                  `captcha` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                                  `used` tinyint(1) NOT NULL,
                                  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
                                  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
                             `last_modified_time` datetime NULL DEFAULT NULL,
                             PRIMARY KEY (`id`) USING BTREE,
                             INDEX `author_id`(`author_id` ASC) USING BTREE,
                             CONSTRAINT `question_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of question
-- ----------------------------
INSERT INTO `question` VALUES (1, '二维体系中磁电阻量子', 'money+intellegent', '2025-03-08 13:20:46', 2, '2025-03-08 13:20:46');
INSERT INTO `question` VALUES (4, 'flask', 'advsfdbsdfbsgbdg', '2025-03-08 16:11:04', 2, '2025-03-08 16:11:04');
INSERT INTO `question` VALUES (5, '雍正王朝金句', '就你也配，gold，你不过是废太子的一条狗\r\n不听你的，大清就要亡国了？难说\r\n\r\n', '2025-03-08 20:49:09', 2, '2025-05-23 13:29:37');

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
                         `last_login_time` datetime NULL DEFAULT NULL,
                         PRIMARY KEY (`id`) USING BTREE,
                         UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (2, 'j2ee', 'scrypt:32768:8:1$tNOhZ89YYhCvnWxp$754aa31dcf9d54177d33740251ad730704483ade63ef66d3bb2cd5cc2992c4281241cf62e98df3cdd026bcbb06229347d413e12ca73680f3b689ef45955e9904', '1513979779@qq.com', '2025-03-08 11:20:18', '2025-05-23 13:37:30');
INSERT INTO `user` VALUES (3, 'Holly', 'scrypt:32768:8:1$CKfeBKAdRN2wAa1z$19a8af7a50123252768fb4ed51a557ccec9fbe24e2c74db46a830c5528f6dc5509e65eeaba3d938cb95ea2ac793f62e2071605bde24252b9bb83d73f625a5446', '3225340736@qq.com', '2025-03-08 20:43:22', '2025-05-23 13:29:17');

-- ----------------------------
-- Table structure for user_login_log
-- ----------------------------
DROP TABLE IF EXISTS `user_login_log`;
CREATE TABLE `user_login_log`  (
                                   `log_id` int NOT NULL AUTO_INCREMENT,
                                   `user_id` int NOT NULL,
                                   `login_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                                   PRIMARY KEY (`log_id`) USING BTREE,
                                   INDEX `idx_user_id_login_time`(`user_id` ASC, `login_time` ASC) USING BTREE,
                                   CONSTRAINT `fk_user_login_log_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_login_log
-- ----------------------------
INSERT INTO `user_login_log` VALUES (1, 2, '2025-05-23 13:28:25', NULL);
INSERT INTO `user_login_log` VALUES (2, 2, '2025-05-23 13:28:25', '127.0.0.1');
INSERT INTO `user_login_log` VALUES (3, 3, '2025-05-23 13:29:17', NULL);
INSERT INTO `user_login_log` VALUES (4, 3, '2025-05-23 13:29:17', '127.0.0.1');
INSERT INTO `user_login_log` VALUES (5, 2, '2025-05-23 13:37:30', NULL);
INSERT INTO `user_login_log` VALUES (6, 2, '2025-05-23 13:37:30', '127.0.0.1');

-- ----------------------------
-- Procedure structure for sp_deactivate_old_unused_captchas
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_deactivate_old_unused_captchas`;
delimiter ;;
CREATE PROCEDURE `sp_deactivate_old_unused_captchas`(IN days_threshold INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE current_captcha_id INT;
    -- 声明游标
    DECLARE cur_old_captchas CURSOR FOR
SELECT id
FROM email_captcha
WHERE used = FALSE AND create_time < DATE_SUB(NOW(), INTERVAL days_threshold DAY);
-- 声明NOT FOUND处理器，当游标取不到数据时，将done设为TRUE
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur_old_captchas;

deactivate_loop: LOOP
        FETCH cur_old_captchas INTO current_captcha_id;
        IF done THEN
            LEAVE deactivate_loop; -- 如果没有更多行，则退出循环
END IF;

        -- 更新当前行的验证码为已使用
UPDATE email_captcha
SET used = TRUE
WHERE id = current_captcha_id;

END LOOP deactivate_loop;

CLOSE cur_old_captchas;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_user_activity_summary
-- ----------------------------
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

-- ----------------------------
-- Triggers structure for table answer
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_update_question_last_modified_on_answer`;
delimiter ;;
CREATE TRIGGER `trg_update_question_last_modified_on_answer` AFTER INSERT ON `answer` FOR EACH ROW BEGIN
    UPDATE question
    SET last_modified_time = NOW()
    WHERE id = NEW.question_id;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table answer
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_log_answer_insert`;
delimiter ;;
CREATE TRIGGER `trg_log_answer_insert` AFTER INSERT ON `answer` FOR EACH ROW BEGIN
    -- 尝试获取当前数据库用户，或者如果应用设置了会话变量，可以想办法传递
    -- DECLARE current_db_user VARCHAR(255);
    -- SET current_db_user = USER(); -- 获取执行操作的数据库用户

    INSERT INTO `answer_audit_log` (`answer_id`, `operation_type`, `new_content`, `operation_time`, `operated_by_user_id`)
    VALUES (NEW.id, 'INSERT', NEW.content, NOW(), NEW.author_id); -- 使用回答的作者作为操作者示例
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table answer
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_log_answer_update`;
delimiter ;;
CREATE TRIGGER `trg_log_answer_update` AFTER UPDATE ON `answer` FOR EACH ROW BEGIN
    -- 只有当内容实际发生变化时才记录日志
    IF OLD.content <> NEW.content THEN
        INSERT INTO `answer_audit_log` (`answer_id`, `operation_type`, `old_content`, `new_content`, `operation_time`, `operated_by_user_id`)
        VALUES (NEW.id, 'UPDATE', OLD.content, NEW.content, NOW(), NEW.author_id); -- 假设更新者也是author_id，实际场景可能需要更复杂的逻辑获取操作者
END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table answer
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_log_answer_delete`;
delimiter ;;
CREATE TRIGGER `trg_log_answer_delete` BEFORE DELETE ON `answer` FOR EACH ROW BEGIN
    INSERT INTO `answer_audit_log` (`answer_id`, `operation_type`, `old_content`, `operation_time`, `operated_by_user_id`)
    VALUES (OLD.id, 'DELETE', OLD.content, NOW(), OLD.author_id); -- 使用被删除回答的作者作为操作者示例
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table user
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_log_user_login`;
delimiter ;;
CREATE TRIGGER `trg_log_user_login` AFTER UPDATE ON `user` FOR EACH ROW BEGIN
    -- 仅当 last_login_time 字段发生变化时记录日志
    -- 并且 OLD.last_login_time IS NULL OR OLD.last_login_time <> NEW.last_login_time
    -- (后者确保了如果 last_login_time 被更新为相同的值，不会重复记录，
    --  但更简单的判断是只要它被更新就记录，因为登录操作通常会赋新值)
    IF NEW.last_login_time IS NOT NULL AND (OLD.last_login_time IS NULL OR OLD.last_login_time <> NEW.last_login_time) THEN
        -- 尝试从会话变量获取IP地址 (如果应用层面设置了)
        -- DECLARE login_ip VARCHAR(45);
        -- SET login_ip = @app_login_ip; -- 假设应用在更新last_login_time前设置了此会话变量

        INSERT INTO `user_login_log` (`user_id`, `login_time`, `ip_address`)
        VALUES (NEW.id, NEW.last_login_time, NULL); -- 替换 NULL 为 login_ip 如果能获取
                                                    -- 或者直接使用 NEW.last_login_time 作为 login_time
                                                    -- 如果希望 login_time 是触发器执行的精确时间，用 NOW()
                                                    -- 这里使用 NEW.last_login_time 更能反映“被记录的登录时间”
END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
