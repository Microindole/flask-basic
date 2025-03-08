from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql.functions import user
# pip install flask-migrate
from flask_migrate import Migrate

# from sqlalchemy import text

app = Flask(__name__)

# MySQL所在的主机名
HOSTNAME = 'localhost'
# MySQL监听的端口号，默认3306
PORT = 3306
# 连接MySQL的用户 ----自己设置
USERNAME = 'root'
# 连接MySQL的密码 ----自己设置
PASSWORD = 'abcABC369258'
# MySQL上创建的数据库名称
DATABASE = 'database_learn'

app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{USERNAME}:{PASSWORD}@{HOSTNAME}:{
PORT}/{DATABASE}?charset=utf8mb4"

# 在app.config中设置好连接数据库的信息
# 然后使用SQLAlchemy（app）创建一个db对象
# SQLAlchemy会自动读取app.config中连接数据的信息.

db = SQLAlchemy(app)

migrate = Migrate(app, db)

# ORM模型映射成表的三步 （在项目cmd中）,
#         每次更新类（表）之后，只需要执行后两步即可
# 1.flask db init：这步只需要执行一次
# 2.flask db migrate：识别ORM模型的改变，生产一个迁移脚本
# 3.flask db upgrade：将运行迁移脚本同步到数据库中

# 测试是否连接成功
# from sqlalchemy import text
# with app.app_context():
#     with db.engine.connect() as connection:
#         rs = connection.execute(text("select 1"))
#         print(rs.fetchone())


class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    # varchar
    username = db.Column(db.String(20), unique=True, nullable=False)
    password = db.Column(db.String(100), nullable=False)

class Article(db.Model):
    __tablename__ = 'article'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String(100), nullable=False)
    content = db.Column(db.Text, nullable=False)  # String类型长度不够
    # author = db.Column(db.String(100), nullable=False)
    # create_time = db.Column(db.DateTime, nullable=False)
    # update_time = db.Column(db.DateTime, nullable=False)

    # 添加作者外键
    author_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    # author = db.relationship('User', backref=db.backref('articles', lazy='dynamic'))
    author = db.relationship('User', backref='articles')

# article.author_id = user.id
# print(article.author)
# sqlalchemy/flask

# user = User(username="法外狂徒张三", password="123456")
# sql: insert user(username, password) values('法外狂徒张三'，'123456');


with app.app_context():
    db.create_all()

@app.route('/article/add', methods=['GET', 'POST'])
def article_add():
    article1 = Article(title="flask学习",content="nvlksklnfvlkns")
    article2 = Article(title="Django",content="nice")
    db.session.add_all([article1, article2])
    db.session.commit()
    return "success"


@app.route('/')
def hello_world():  # put application's code here
    return 'Hello World!'

@app.route('/user/add')
def add_user():
    # 1创建ORM对象
    user = User(username='fwktzs', password='123456')
    # 2.将ORM对象添加到db.session中
    db.session.add(user)
    # 3.将db.session中的改变同步到数据库中
    db.session.commit()
    return "用户创建成功"

@app.route('/user/query')
def query_user():
    # 1.get查找
    # User.query.get(1)
    # 2.filter_by查找
    # Query : 类数组
    users = User.query.filter_by(username='fwktzs')


@app.route('/user/update')
def update_user():
    user = User.query.filter_by(username='fwktzs').first()
    user.password = '222222'
    db.session.commit()
    return "数据修改成功"

@app.route('/user/delete')
def delete_user():
    # 1.查找
    user = User.query.filter_by(username='fwktzs').first()
    # 2.从db.session中删除
    db.session.delete(user)
    # 3.将db.session中的修改，同步到数据库中
    db.session.commit()
    return "数据删除成功"

if __name__ == '__main__':
    app.run()
