
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
MAIL_SERVER = 'smtp.qq.com'
MAIL_PORT = 465
MAIL_USE_SSL = True
# MAIL_SSL仅能使用中文
MAIL_USERNAME = '3225340736@qq.com'
MAIL_PASSWORD = 'czpfiqbvaeqhdajd'
MAIL_DEFAULT_SENDER = '3225340736@qq.com'