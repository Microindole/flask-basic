# Flask Basic - 数据库项目实践

## 项目概述
本项目是一个基于 Flask 框架的问答系统，实现了用户注册、登录、发布问题、回答问题等核心功能。项目采用 MySQL 数据库，包含完整的数据库设计、存储过程、触发器等高级特性。

## 📚 项目文档

### 核心文档
- **[需求分析文档](require.md)** - 详细的系统需求分析和功能规格说明
- **[数据库设计文档](sql.md)** - 完整的数据库设计、范式分析和优化策略
- **[配置文件说明](config.md)** - 项目配置指南和环境设置说明

### 快速导航
| 文档 | 描述 | 适用人群 |
|------|------|----------|
| [require.md](require.md) | 系统需求分析、功能模块设计 | 产品经理、开发者 |
| [sql.md](sql.md) | 数据库表结构、存储过程、触发器 | 数据库开发者、DBA |
| [config.md](config.md) | 环境配置、部署指南 | 运维工程师、开发者 |

## 项目特色
- ✅ Flask 基础功能学习与实践
- ✅ 完整的用户认证系统（注册、登录、邮箱验证）
- ✅ 问答系统核心功能
- ✅ 数据库高级特性应用
- ✅ 用户行为审计与日志记录
- ✅ 点赞功能与统计
- ✅ 数据库触发器实现自动化日志功能

## 系统需求分析

### 功能需求
1. **用户管理模块**
   - 用户注册（邮箱验证码验证）
   - 用户登录/退出
   - 用户信息管理

2. **问答模块**
   - 发布问题
   - 回答问题
   - 问题点赞功能
   - 问题列表展示

3. **审计模块**
   - 用户登录日志记录
   - 回答操作审计日志
   - 系统行为追踪

### 非功能需求
- 数据一致性保障
- 操作审计追踪
- 系统安全性
- 数据库性能优化

## 系统概念模型设计（E-R图）

### 核心实体
- **用户（User）**：用户基本信息
- **问题（Question）**：用户发布的问题
- **回答（Answer）**：对问题的回答
- **邮箱验证码（EmailCaptcha）**：注册验证码
- **问题点赞（QuestionLikes）**：点赞关系

### 审计实体
- **用户登录日志（UserLoginLog）**：登录行为记录
- **回答审计日志（AnswerAuditLog）**：回答操作记录

## 数据库表设计

### 核心业务表
| 表名 | 描述 | 主要字段 |
|------|------|----------|
| `user` | 用户表 | id, username, password, email, join_time, last_login_time |
| `question` | 问题表 | id, title, content, create_time, author_id, likes_count |
| `answer` | 回答表 | id, content, create_time, question_id, author_id |
| `email_captcha` | 邮箱验证码表 | id, email, captcha, used, create_time |
| `question_likes` | 问题点赞表 | id, question_id, user_id, create_time |

### 审计日志表
| 表名 | 描述 | 主要字段 |
|------|------|----------|
| `user_login_log` | 用户登录日志 | log_id, user_id, login_time, ip_address |
| `answer_audit_log` | 回答审计日志 | log_id, answer_id, operation_type, old_content, new_content |

> 📋 **详细信息**: 完整的数据库设计和范式分析请参考 **[数据库设计文档](sql.md)**

## 存储过程

### 1. 批量失效过期验证码
```sql
CALL sp_deactivate_old_unused_captchas(7); -- 失效7天前的验证码
```

### 2. 获取用户活跃度统计
```sql
CALL sp_get_user_activity_summary(2); -- 获取用户ID为2的活跃度统计
```

## 触发器功能

### 1. 自动化日志记录
- **回答操作日志**：自动记录回答的增删改操作
- **用户登录日志**：自动记录用户登录行为

### 2. 业务逻辑触发
- **问题更新时间**：有新回答时自动更新问题的最后修改时间
- **点赞数统计**：点赞/取消点赞时自动更新问题点赞数

### 3. 数据一致性保障
- 确保点赞数与实际点赞记录一致
- 保证审计日志的完整性

## 项目结构
```
flask-basic/
├── README.md              # 项目说明文档
├── require.md             # 需求分析文档
├── sql.md                 # 数据库设计文档
├── config.md              # 配置文件说明
├── flask_basic.sql        # 数据库结构与数据
├── .gitignore            # Git忽略文件配置
├── requirements.txt       # Python依赖包（需要）
├── app.py                # Flask应用主文件（需要）
├── models/               # 数据模型（需要）
├── templates/            # HTML模板（需要）
├── static/               # 静态文件（需要）
└── migrations/           # 数据库迁移文件
```

## 技术栈
- **后端框架**：Flask
- **数据库**：MySQL 8.0
- **ORM**：Flask-SQLAlchemy
- **数据库迁移**：Flask-Migrate
- **密码加密**：Werkzeug Security
- **邮件发送**：Flask-Mail

## 安装与运行

### 1. 环境准备
```bash
# 创建虚拟环境
python -m venv venv

# 激活虚拟环境
venv\Scripts\activate  # Windows
source venv/bin/activate  # Linux/Mac

# 安装依赖
pip install -r requirements.txt
```

### 2. 数据库配置
```bash
# 导入数据库结构
mysql -u root -p < flask_basic.sql
```

> ⚙️ **配置指南**: 详细的配置步骤请参考 **[配置文件说明](config.md)**

### 3. 运行应用
```bash
python app.py
```

## 数据库特性亮点

### 1. 完整的审计系统
- 所有回答操作都有完整的审计日志
- 用户登录行为全程追踪
- 支持数据恢复和问题追溯

### 2. 自动化触发器
- 业务逻辑自动化处理
- 数据一致性自动保障
- 减少应用层代码复杂度

### 3. 存储过程优化
- 批量数据处理效率高
- 复杂查询逻辑封装
- 数据库层面的业务逻辑

### 4. 规范的表设计
- 符合数据库设计规范
- 完整的外键约束
- 合理的索引设计

## 未来扩展
- [ ] 添加用户权限管理
- [ ] 实现问题分类功能
- [ ] 添加搜索功能
- [ ] 实现消息通知系统
- [ ] 添加文件上传功能
- [ ] 实现API接口

## 项目总结
本项目完整地展示了：
- Flask Web开发的核心概念
- MySQL数据库的高级特性应用
- 存储过程和触发器的实际使用
- 系统审计和日志记录的最佳实践
- 数据库设计的规范性和扩展性

这是一个很好的数据库项目实践案例，涵盖了从系统分析、概念模型设计到具体实现的完整流程。

---

📖 **更多详细信息请查看相关文档**：
- [需求分析](require.md) | [数据库设计](sql.md) | [配置说明](config.md)