from flask import Flask, session, g
import config
from exts import db, mail
from models import UserModel
from blueprints.qa import bp as qa_bp
from blueprints.auth import bp as auth_bp
from blueprints.info import bp as info_bp
from flask_migrate import Migrate


app = Flask(__name__)
# 绑定配置文件
app.config.from_object(config)

db.init_app(app)
mail.init_app(app)

migrate = Migrate(app, db)

# flask db init
# flask db migrate
# flaks db upgrade

# blueprint：用来做模块化
app.register_blueprint(qa_bp)
app.register_blueprint(auth_bp)
app.register_blueprint(info_bp)


# before_request/ before_first_request/ after_request
# hook： 钩子函数
@app.before_request
def my_before_request():
    user_id = session.get('user_id')
    # 在执行每个函数之前查询一下user_id    '过滤器‘
    if user_id:
        user = UserModel.query.get(user_id)
        setattr(g, 'user', user)
    else:
        # 避免g这个对象中没有user，导致报错
        setattr(g, 'user', None)


@app.context_processor
def my_context_processor():
    return {'user': g.user}


if __name__ == '__main__':
    app.run()
