
SECRET_KEY = 'iloveluotianyiverymuch'

# 数据库配置信息
HOSTNAME    = '127.0.0.1'
PORT        = '3306'
DATABASE    = 'flask_basic'
USERNAME    = 'root'
PASSWORD    = 'abcABC369258'
DB_URI = 'mysql+pymysql://{}:{}@{}:{}/{}?charset=utf8'.format(USERNAME, PASSWORD, HOSTNAME, PORT, DATABASE)
SQLALCHEMY_DATABASE_URI = DB_URI


# czpfiqbvaeqhdajd
# 记得关掉 POP3/SMTP

# 邮箱配置
# 邮箱类型
MAIL_SERVER = 'smtp.qq.com'
MAIL_PORT = 465
# MAIL_SSL仅能使用中文
MAIL_USE_SSL = True
# 邮箱名
MAIL_USERNAME = 'xxxxxxxxxx@qq.com'
# POP3/SMTP打开后的密码
MAIL_PASSWORD = '..........'
# 发送邮邮件者
MAIL_DEFAULT_SENDER = 'xxxxxxxxxx@qq.com'
