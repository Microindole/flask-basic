from flask import Blueprint, render_template, jsonify, request, redirect, url_for, session, flash
from exts import mail, db
from flask_mail import Message
import string
import random
from models import EmailCaptchaModel, UserModel, UserLoginLogModel
from .forms import RegisterForm, LoginForm
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime

# /auth
bp = Blueprint("auth", __name__, url_prefix='/auth')


# 默认是get请求
@bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        form = LoginForm(request.form)
        if form.validate():
            email = form.email.data
            password = form.password.data
            user = UserModel.query.filter_by(email=email).first()
            if not user:
                flash("邮箱在数据库中不存在！")
                return redirect(url_for("auth.login"))
            if check_password_hash(user.password, password):
                session['user_id'] = user.id

                # 更新 last_login_time (如果需要)
                user.last_login_time = datetime.now()

                # 直接记录登录日志
                login_ip = request.remote_addr  # 获取IP地址
                new_login_log = UserLoginLogModel(user_id=user.id, ip_address=login_ip,
                                                   login_time=user.last_login_time)  # 假设有 UserLoginLogModel
                db.session.add(new_login_log)

                db.session.commit()  # 提交对 user.last_login_time 的更改，这将触发上面的触发器

                return redirect("/")
            else:
                flash("密码错误！")
                return redirect(url_for("auth.login"))
        else:
            flash("邮箱或密码格式错误！")
            return redirect(url_for("auth.login"))
    return render_template("login.html")


# GET: 从服务器上获取数据
# POST: 将客户端的数据提交给服务器
@bp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == "GET":
        return render_template('register.html')
    else:
        # 验证用户的邮箱和验证码是否正确
        # 表单验证：flask-wtf:wtforms
        form = RegisterForm(request.form)
        if form.validate():
            email = form.email.data
            username = form.username.data
            password = form.password.data
            user = UserModel(email=email, username=username, password=generate_password_hash(password))
            db.session.add(user)
            db.session.commit()
            return redirect(url_for("auth.login"))
        else:
            print(form.errors)
            return redirect(url_for("auth.register"))


@bp.route('/logout')
def logout():
    session.clear()
    return redirect('/')


@bp.route("/captcha/email")
def get_mail_captcha():
    # /captcha/email/<email>
    # /captcha/email?email=xxx@qq.com
    email = request.args.get("email")
    # 4/6:数组、字母和、数组和字母的结合
    # string.digits*4:0123456789012345678901234567890123456789
    source = string.digits*4
    captcha = random.sample(source, 4)
    # print(captcha)
    captcha = ''.join(captcha)
    # I/O
    message = Message("注册验证码", recipients=[email], body=f"您的验证码是：{captcha}")
    mail.send(message)
    # 将验证码存储在缓存中
    # memcached：直接存在内存中
    # redis：比memcached更强大一点，会存在硬盘当中
    # 用数据库的方式存储
    email_captcha = EmailCaptchaModel(email=email, captcha=captcha)
    db.session.add(email_captcha)
    db.session.commit()
    # RestFul API格式的数据
    # {code: 200/400/500, message: "", data: {}}
    return jsonify({"code": 200, "message": "", "data": None})


@bp.route("/mail/test")
def mail_test():
    # 参数：邮件主题，收件人，发送内容
    message = Message("Test Message", recipients=["3225340736@qq.com"], body="This is a test message")
    mail.send(message)
    return "邮件发送成功"
