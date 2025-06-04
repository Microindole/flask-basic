# 配置文件说明

## 概述
本项目使用 `config.py` 文件来管理应用配置信息。由于该文件包含敏感信息（如数据库密码、邮箱密码等），已在 `.gitignore` 中被忽略，不会提交到版本控制系统。

## 配置文件结构

### 必需的配置项
创建 `config.py` 文件并包含以下配置：

```python
# Flask应用密钥
SECRET_KEY = 'your-secret-key-here'

# 数据库配置
HOSTNAME = '127.0.0.1'          # 数据库主机地址
PORT = '3306'                   # 数据库端口
DATABASE = 'flask_basic'        # 数据库名称
USERNAME = 'your-db-username'   # 数据库用户名
PASSWORD = 'your-db-password'   # 数据库密码

# 构建数据库连接URI
DB_URI = 'mysql+pymysql://{}:{}@{}:{}/{}?charset=utf8'.format(
    USERNAME, PASSWORD, HOSTNAME, PORT, DATABASE
)
SQLALCHEMY_DATABASE_URI = DB_URI

# 邮箱服务配置（用于发送验证码）
MAIL_SERVER = 'smtp.qq.com'     # 邮件服务器
MAIL_PORT = 465                 # 邮件服务器端口
MAIL_USE_SSL = True             # 启用SSL
MAIL_USERNAME = 'your-email@qq.com'      # 发送邮箱
MAIL_PASSWORD = 'your-email-auth-code'   # 邮箱授权码（非登录密码）
MAIL_DEFAULT_SENDER = 'your-email@qq.com'
```

## 配置说明

### 1. Flask 密钥配置
- `SECRET_KEY`：用于会话加密和CSRF保护
- 建议使用随机生成的强密钥

### 2. 数据库配置
- 支持 MySQL 数据库
- 使用 PyMySQL 驱动连接
- 默认字符集为 UTF-8

### 3. 邮箱配置
- 支持 QQ 邮箱发送验证码
- 需要开启 SMTP 服务并获取授权码
- `MAIL_PASSWORD` 是邮箱的授权码，不是登录密码

## 环境设置

### 数据库准备
1. 安装 MySQL 8.0
2. 创建数据库：
   ```sql
   CREATE DATABASE flask_basic CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
3. 导入数据库结构：
   ```bash
   mysql -u your-username -p flask_basic < flask_basic.sql
   ```

### 邮箱服务设置（QQ邮箱）
1. 登录 QQ 邮箱
2. 进入"设置" → "账户"
3. 开启 "POP3/SMTP服务"
4. 获取授权码用作 `MAIL_PASSWORD`

## 安全注意事项

### 配置文件安全
- ❌ 绝对不要将 `config.py` 提交到版本控制系统
- ✅ 已在 `.gitignore` 中配置忽略该文件
- ✅ 生产环境建议使用环境变量管理敏感配置

### 密码安全
- 数据库密码应足够复杂
- 邮箱授权码定期更新
- Flask SECRET_KEY 应随机生成

## 示例配置模板

创建配置文件时，可以参考以下模板：

```python
# config.py 模板
SECRET_KEY = 'generate-a-random-secret-key'

# 数据库配置
HOSTNAME = '127.0.0.1'
PORT = '3306'
DATABASE = 'flask_basic'
USERNAME = 'root'
PASSWORD = 'your-database-password'
DB_URI = 'mysql+pymysql://{}:{}@{}:{}/{}?charset=utf8'.format(
    USERNAME, PASSWORD, HOSTNAME, PORT, DATABASE
)
SQLALCHEMY_DATABASE_URI = DB_URI

# 邮箱配置
MAIL_SERVER = 'smtp.qq.com'
MAIL_PORT = 465
MAIL_USE_SSL = True
MAIL_USERNAME = 'your-email@qq.com'
MAIL_PASSWORD = 'your-email-auth-code'
MAIL_DEFAULT_SENDER = 'your-email@qq.com'
```

## 故障排除

### 常见问题
1. **数据库连接失败**
   - 检查数据库服务是否启动
   - 验证用户名密码是否正确
   - 确认数据库名称是否存在

2. **邮件发送失败**
   - 确认邮箱SMTP服务已开启
   - 检查授权码是否正确
   - 验证网络连接是否正常

3. **应用启动失败**
   - 检查 config.py 文件是否存在
   - 验证所有必需配置项是否完整
   - 查看错误日志定位具体问题

## 部署建议

### 开发环境
- 使用本地 MySQL 实例
- 配置测试邮箱账号

### 生产环境
- 使用环境变量管理敏感配置
- 配置专用的邮件服务账号
- 定期更新密钥和密码