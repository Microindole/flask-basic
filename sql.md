# 数据库设计与实现

## 数据库概述

本项目采用 MySQL 8.0 数据库，实现了一个完整的问答系统数据存储方案。数据库设计遵循关系型数据库设计规范，包含核心业务表、审计日志表、存储过程和触发器等高级特性。

## 数据库范式分析

### 第一范式（1NF）
- ✅ **原子性**：所有表的字段都是不可分割的原子值
- ✅ **唯一性**：每行数据都有唯一标识（主键）
- ✅ **字段单一性**：每个字段只存储一种类型的数据

### 第二范式（2NF）
- ✅ **满足1NF**：符合第一范式要求
- ✅ **完全依赖主键**：非主键字段完全依赖于主键
- ✅ **消除部分依赖**：没有非主键字段仅依赖于主键的一部分

### 第三范式（3NF）
- ✅ **满足2NF**：符合第二范式要求
- ✅ **消除传递依赖**：非主键字段不依赖于其他非主键字段
- ✅ **字段直接依赖**：所有字段都直接依赖于主键

## 数据库表结构设计

### 核心业务表

#### 1. 用户表 (user)
```sql
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,           -- 主键，用户唯一标识
  `username` varchar(100) NOT NULL,           -- 用户名，非空
  `password` varchar(200) NOT NULL,           -- 密码，加密存储
  `email` varchar(100) NOT NULL,              -- 邮箱，唯一约束
  `join_time` datetime DEFAULT NULL,          -- 注册时间
  `last_login_time` datetime DEFAULT NULL,    -- 最后登录时间
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
);
```

**设计特点**：
- 主键自增，保证唯一性
- 邮箱唯一约束，防止重复注册
- 密码字段长度足够存储加密后的哈希值

#### 2. 问题表 (question)
```sql
CREATE TABLE `question` (
  `id` int NOT NULL AUTO_INCREMENT,           -- 主键，问题唯一标识
  `title` varchar(100) NOT NULL,              -- 问题标题
  `content` text NOT NULL,                    -- 问题内容
  `create_time` datetime DEFAULT NULL,        -- 创建时间
  `author_id` int DEFAULT NULL,               -- 作者外键
  `last_modified_time` datetime DEFAULT NULL, -- 最后修改时间
  `likes_count` int NOT NULL DEFAULT 0,       -- 点赞数统计
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `question_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`)
);
```

**设计特点**：
- 外键约束确保数据完整性
- 冗余存储点赞数，提升查询性能
- 支持问题修改时间追踪

#### 3. 回答表 (answer)
```sql
CREATE TABLE `answer` (
  `id` int NOT NULL AUTO_INCREMENT,           -- 主键，回答唯一标识
  `content` text NOT NULL,                    -- 回答内容
  `create_time` datetime DEFAULT NULL,        -- 创建时间
  `question_id` int DEFAULT NULL,             -- 问题外键
  `author_id` int DEFAULT NULL,               -- 作者外键
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  KEY `question_id` (`question_id`),
  CONSTRAINT `answer_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`),
  CONSTRAINT `answer_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`)
);
```

**设计特点**：
- 双外键设计，关联问题和用户
- 建立索引提升查询效率
- 支持级联操作控制

#### 4. 问题点赞表 (question_likes)
```sql
CREATE TABLE `question_likes` (
  `id` int NOT NULL AUTO_INCREMENT,           -- 主键
  `question_id` int NOT NULL,                 -- 问题外键
  `user_id` int NOT NULL,                     -- 用户外键
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP, -- 点赞时间
  PRIMARY KEY (`id`),
  UNIQUE KEY `question_user_like` (`question_id`, `user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `question_likes_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE CASCADE,
  CONSTRAINT `question_likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
);
```

**设计特点**：
- 复合唯一约束防止重复点赞
- 级联删除保证数据一致性
- 时间戳记录点赞行为

#### 5. 邮箱验证码表 (email_captcha)
```sql
CREATE TABLE `email_captcha` (
  `id` int NOT NULL AUTO_INCREMENT,           -- 主键
  `email` varchar(100) NOT NULL,              -- 邮箱地址
  `captcha` varchar(100) NOT NULL,            -- 验证码
  `used` tinyint(1) NOT NULL,                 -- 使用状态
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间
  PRIMARY KEY (`id`)
);
```

**设计特点**：
- 支持验证码状态管理
- 自动时间戳记录
- 支持批量清理过期验证码

### 审计日志表

#### 6. 回答审计日志表 (answer_audit_log)
```sql
CREATE TABLE `answer_audit_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,       -- 日志主键
  `answer_id` int NOT NULL,                   -- 回答ID
  `operation_type` varchar(10) NOT NULL,      -- 操作类型
  `old_content` text,                         -- 旧内容
  `new_content` text,                         -- 新内容
  `operation_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 操作时间
  `operated_by_user_id` int DEFAULT NULL,     -- 操作用户
  PRIMARY KEY (`log_id`),
  KEY `idx_answer_id` (`answer_id`),
  KEY `idx_operation_time` (`operation_time`)
);
```

**设计特点**：
- 完整记录数据变更历史
- 支持操作类型分类（INSERT/UPDATE/DELETE）
- 建立时间索引提升查询性能

#### 7. 用户登录日志表 (user_login_log)
```sql
CREATE TABLE `user_login_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,       -- 日志主键
  `user_id` int NOT NULL,                     -- 用户ID
  `login_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登录时间
  `ip_address` varchar(45) DEFAULT NULL,      -- IP地址
  PRIMARY KEY (`log_id`),
  KEY `idx_user_id_login_time` (`user_id`, `login_time`),
  CONSTRAINT `fk_user_login_log_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
);
```

**设计特点**：
- 复合索引优化用户登录历史查询
- 支持IPv4和IPv6地址存储
- 级联删除保证数据一致性

## 存储过程

### 1. 批量失效过期验证码
```sql
CALL sp_deactivate_old_unused_captchas(7);
```

**功能**：批量将7天前未使用的验证码标记为已使用
**特点**：
- 使用游标遍历过期验证码
- 支持自定义天数阈值
- 提升数据清理效率

### 2. 获取用户活跃度统计
```sql
CALL sp_get_user_activity_summary(2);
```

**功能**：查询指定用户的问题数和回答数统计
**特点**：
- 单次调用获取多维度统计
- 优化复杂查询性能
- 支持用户活跃度分析

## 触发器设计

### 1. 业务逻辑触发器

#### 自动更新问题修改时间
```sql
-- 有新回答时更新问题的最后修改时间
CREATE TRIGGER trg_update_question_last_modified_on_answer
AFTER INSERT ON answer FOR EACH ROW
BEGIN
    UPDATE question SET last_modified_time = NOW() WHERE id = NEW.question_id;
END;
```

#### 自动更新点赞数统计
```sql
-- 点赞时更新统计
CREATE TRIGGER trg_update_question_likes_count
AFTER INSERT ON question_likes FOR EACH ROW
-- 取消点赞时更新统计
CREATE TRIGGER trg_update_question_likes_count_on_delete
AFTER DELETE ON question_likes FOR EACH ROW
```

### 2. 审计日志触发器

#### 回答操作审计
```sql
-- 插入操作审计
CREATE TRIGGER trg_log_answer_insert AFTER INSERT ON answer
-- 更新操作审计  
CREATE TRIGGER trg_log_answer_update AFTER UPDATE ON answer
-- 删除操作审计
CREATE TRIGGER trg_log_answer_delete BEFORE DELETE ON answer
```

#### 用户登录审计
```sql
-- 登录时间更新时自动记录日志
CREATE TRIGGER trg_log_user_login AFTER UPDATE ON user
```

## 数据库设计规范

### 1. 命名规范
- **表名**：使用小写字母和下划线，语义清晰
- **字段名**：使用小写字母和下划线，避免保留字
- **索引名**：使用 `idx_` 前缀，描述索引用途
- **外键名**：使用 `fk_` 前缀，包含关联表信息

### 2. 数据类型规范
- **主键**：统一使用 `int AUTO_INCREMENT`
- **时间字段**：使用 `datetime` 类型，支持默认值
- **文本字段**：根据长度选择 `varchar` 或 `text`
- **布尔字段**：使用 `tinyint(1)` 表示

### 3. 约束规范
- **主键约束**：每张表必须有主键
- **外键约束**：维护数据完整性，设置合适的级联操作
- **唯一约束**：防止业务数据重复
- **非空约束**：重要字段设置 NOT NULL

### 4. 索引设计
- **主键索引**：自动创建
- **外键索引**：提升关联查询性能
- **复合索引**：优化多字段查询
- **时间索引**：支持按时间排序和筛选

## 性能优化策略

### 1. 查询优化
- 合理使用索引提升查询速度
- 避免全表扫描，使用 WHERE 条件
- 优化 JOIN 查询，减少数据传输

### 2. 存储优化
- 选择合适的数据类型减少存储空间
- 定期清理过期数据（验证码等）
- 使用存储过程封装复杂逻辑

### 3. 并发控制
- 使用事务保证数据一致性
- 合理设置隔离级别
- 避免长事务和死锁

## 安全设计

### 1. 数据安全
- 敏感信息加密存储（密码）
- 设置合适的字符集（utf8mb4）
- 使用参数化查询防止SQL注入

### 2. 访问控制
- 设置数据库用户权限
- 限制应用层数据库访问
- 定期备份重要数据

### 3. 审计追踪
- 完整的操作日志记录
- 用户行为追踪
- 数据变更历史保存

## 数据库维护

### 1. 定期维护任务
```sql
-- 清理过期验证码
CALL sp_deactivate_old_unused_captchas(7);

-- 检查数据一致性
SELECT question_id, COUNT(*) as actual_likes, 
       (SELECT likes_count FROM question WHERE id = question_id) as stored_likes
FROM question_likes GROUP BY question_id;
```

### 2. 监控指标
- 数据库连接数
- 查询执行时间
- 存储空间使用
- 日志文件大小

### 3. 备份策略
- 定期全量备份
- 增量备份日志
- 测试恢复流程
- 异地备份存储

## 扩展性考虑

### 1. 水平扩展
- 支持读写分离
- 数据分片策略
- 缓存层设计

### 2. 垂直扩展
- 硬件资源升级
- 存储引擎优化
- 参数调优

### 3. 功能扩展
- 预留扩展字段
- 灵活的表结构设计
- 版本管理支持