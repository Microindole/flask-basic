from exts import db
from datetime import datetime


class UserModel(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(100), nullable=False)
    password = db.Column(db.String(200), nullable=False)
    email = db.Column(db.String(100), nullable=False, unique=True)
    join_time = db.Column(db.DateTime, default=datetime.now)
    last_login_time = db.Column(db.DateTime, nullable=True)  # 新增字段


class EmailCaptchaModel(db.Model):
    __tablename__ = 'email_captcha'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(100), nullable=False)
    captcha = db.Column(db.String(100), nullable=False)
    used = db.Column(db.Boolean, nullable=False, default=False)
    create_time = db.Column(db.DateTime, default=datetime.now)


class QuestionModel(db.Model):
    __tablename__ = 'question'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String(100), nullable=False)
    content = db.Column(db.Text, nullable=False)
    create_time = db.Column(db.DateTime, default=datetime.now)
    last_modified_time = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now)
    likes_count = db.Column(db.Integer, nullable=False, default=0)  # 新增点赞数字段

    # 外键
    author_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    # 反向引用
    author = db.relationship(UserModel, backref='questions')


class AnswerModel(db.Model):
    __tablename__ = 'answer'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    content = db.Column(db.Text, nullable=False)
    create_time = db.Column(db.DateTime, default=datetime.now)
    # 增加两个外键
    question_id = db.Column(db.Integer, db.ForeignKey('question.id'))
    author_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    # 定义两个关系
    question = db.relationship(QuestionModel,
                               backref=db.backref('answers', order_by=create_time.desc()))
    author = db.relationship(UserModel, backref='answers')


class QuestionLikeModel(db.Model):
    __tablename__ = 'question_likes'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    question_id = db.Column(db.Integer, db.ForeignKey('question.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    create_time = db.Column(db.DateTime, default=datetime.now)
    
    # 定义关系
    question = db.relationship(QuestionModel, backref=db.backref('likes', lazy='dynamic'))
    user = db.relationship(UserModel, backref=db.backref('liked_questions', lazy='dynamic'))
    
    # 确保每个用户对每个问题只能点赞一次
    __table_args__ = (db.UniqueConstraint('question_id', 'user_id', name='question_user_like'),)


class AnswerAuditLogModel(db.Model):
    __tablename__ = 'answer_audit_log'
    log_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    answer_id = db.Column(db.Integer, db.ForeignKey('answer.id'), nullable=False)
    operation_type = db.Column(db.String(10), nullable=False)  # 'INSERT', 'UPDATE', 'DELETE'
    old_content = db.Column(db.Text, nullable=True)
    new_content = db.Column(db.Text, nullable=True)
    operation_time = db.Column(db.DateTime, nullable=False, default=datetime.now)
    operated_by_user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)

    answer = db.relationship(AnswerModel, backref=db.backref('audit_logs', lazy='dynamic'))
    operator = db.relationship(UserModel, backref=db.backref('answer_audit_actions', lazy='dynamic'))


class UserLoginLogModel(db.Model):
    __tablename__ = 'user_login_log'
    log_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    login_time = db.Column(db.DateTime, nullable=False, default=datetime.now)
    ip_address = db.Column(db.String(45), nullable=True)

    user = db.relationship(UserModel, backref=db.backref('login_logs', lazy='dynamic'))
