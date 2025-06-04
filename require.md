## 需求分析文档

### 1. 项目概述

**项目名称**: 知识问答系统 (Flask Q&A Platform)
**项目描述**: 基于 Flask 框架开发的在线知识问答平台，用户可以发布问题、回答问题、点赞互动
**技术栈**: Python Flask + MySQL + SQLAlchemy + Flask-Mail + Bootstrap

### 2. 系统角色定义

#### 2.1 访客 (Visitor)

- 未登录的系统访问者
- 可以浏览问题列表和详情
- 可以搜索问题
- 可以注册和登录

#### 2.2 注册用户 (User)

- 已注册并登录的用户
- 继承访客的所有权限
- 可以发布问题、回答问题、点赞操作

### 3. 功能性需求

#### 3.1 访客功能模块

**1 浏览问题列表**

- 查看所有问题，按创建时间倒序排列
- 显示问题标题、作者用户名、创建时间、点赞数
- 支持分页浏览

**2 查看问题详情**

- 查看完整问题内容和所有回答
- 显示问题的详细信息（标题、内容、作者、创建时间、修改时间）
- 显示所有回答，按创建时间倒序排列
- 未登录用户只能查看，不能进行交互操作

**3 搜索问题**

- 根据关键词搜索问题标题
- 实时显示搜索结果
- 支持模糊匹配

**4 用户注册**

- 邮箱验证码注册机制
- 用户名和邮箱唯一性校验
- 密码安全加密存储
- 自动记录注册时间

**5 用户登录**

- 支持邮箱或用户名登录
- 密码验证
- 登录状态保持（Session管理）
- 记录最后登录时间

#### 3.2 注册用户功能模块

**6 发布问题**

- 输入问题标题（3-100字符限制）
- 输入问题详细内容（最少3字符）
- 表单验证和错误提示
- 自动关联当前登录用户为作者
- 自动设置创建时间和修改时间

**7 回答问题**

- 对指定问题发布回答
- 回答内容验证（最少3字符）
- 自动关联回答作者和对应问题
- 回答列表按时间倒序显示

**8 点赞问题**

- AJAX异步点赞功能
- 实时更新点赞数量显示
- 防重复点赞（每用户每问题只能点赞一次）
- 点赞状态实时反馈

**9 取消点赞**

- 已点赞用户可取消点赞
- 实时更新点赞数量
- AJAX异步操作

**10 用户注销**

- 安全退出系统
- 清除用户会话信息
- 重定向到首页

**11 获取邮箱验证码**

- 发送验证码到指定邮箱
- 验证码有效期管理
- 防重复发送机制
- 验证码使用状态追踪

### 4. 数据模型设计

#### 4.1 核心数据表

**UserModel (用户表)**

- id: 主键，自增
- username: 用户名，非空
- password: 密码，加密存储
- email: 邮箱，唯一约束
- join_time: 注册时间
- last_login_time: 最后登录时间

**QuestionModel (问题表)**

- id: 主键，自增
- title: 问题标题
- content: 问题内容
- create_time: 创建时间
- last_modified_time: 最后修改时间
- likes_count: 点赞数统计
- author_id: 作者外键

**AnswerModel (回答表)**

- id: 主键，自增
- content: 回答内容
- create_time: 创建时间
- question_id: 问题外键
- author_id: 作者外键

**QuestionLikeModel (问题点赞表)**

- id: 主键，自增
- question_id: 问题外键
- user_id: 用户外键
- create_time: 点赞时间
- 唯一约束: (question_id, user_id)

**EmailCaptchaModel (邮箱验证码表)**

- id: 主键，自增
- email: 邮箱地址
- captcha: 验证码
- used: 是否已使用
- create_time: 创建时间

**AnswerAuditLogModel (回答审计日志表)**

- log_id: 主键，自增
- answer_id: 回答外键
- operation_type: 操作类型（INSERT/UPDATE/DELETE）
- old_content: 旧内容
- new_content: 新内容
- operation_time: 操作时间
- operated_by_user_id: 操作用户

**UserLoginLogModel (用户登录日志表)**

- log_id: 主键，自增
- user_id: 用户外键
- login_time: 登录时间
- ip_address: IP地址

### 5. 非功能性需求

#### 5.1 性能需求

- 页面响应时间 < 3秒
- 支持50+并发用户访问
- 数据库查询优化

#### 5.2 安全需求

- 用户密码加密存储
- SQL注入防护（使用SQLAlchemy ORM）
- XSS攻击防护
- 登录权限控制装饰器 `@login_required`
- Session安全管理

#### 5.3 可用性需求

- 响应式设计，支持移动端访问
- 友好的用户界面
- 明确的错误提示信息
- 操作反馈机制

#### 5.4 可维护性需求

- 模块化设计（Blueprint蓝图架构）
- 代码注释完整
- 数据库迁移支持（Flask-Migrate）
- 审计日志完整

### 6. 系统架构

#### 6.1 应用架构

Flask应用

├── app.py - 主应用入口

├── models.py - 数据模型

├── config.py - 配置文件

├── exts.py - 扩展初始化

├── decorators.py - 装饰器

└── blueprints/

  ├── auth.py - 认证模块

  ├── qa.py - 问答模块

  └── info.py - 信息模块

#### 6.2 核心功能流程

1. **用户注册流程**: 邮箱验证 → 信息填写 → 账户创建
2. **问题发布流程**: 登录验证 → 内容填写 → 数据保存
3. **回答问题流程**: 登录验证 → 回答提交 → 关联存储
4. **点赞功能流程**: 登录验证 → 重复检查 → 点赞记录 → 计数更新

### 7. 接口设计

#### 7.1 主要路由端点

- `GET /` - 首页问题列表
- `GET /qa/detail/<id>` - 问题详情页
- `POST /qa/public` - 发布问题
- `POST /answer/public` - 发布回答
- `POST /qa/like` - 点赞/取消点赞
- `GET /search` - 搜索功能

#### 7.2 认证相关接口

- `GET /auth/register` - 注册页面
- `POST /auth/register` - 处理注册
- `GET /auth/login` - 登录页面
- `POST /auth/login` - 处理登录
- `GET /auth/logout` - 用户注销
- `POST /auth/captcha/email` - 发送验证码
