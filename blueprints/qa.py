from flask import Blueprint, request, render_template, g, redirect, url_for
from .forms import QuestionForm, AnswerForm
from models import QuestionModel, AnswerModel
from exts import db
from decorators import login_required

bp = Blueprint('qa', __name__, url_prefix='/')


# http://127.0.0.1:5000
@bp.route('/')
def index():
    questions = QuestionModel.query.order_by(QuestionModel.create_time.desc()).all()
    return render_template('index.html', questions=questions)


# 使用装饰器是会把public_qa这个函数传给login_required，从而成为login_required中的func参数
@bp.route('/qa/public', methods=['GET', 'POST'])
@login_required
def public_question():
    # 不具有通用性，仅仅适合这一个页面
    # if not g.user:
    #     return redirect(url_for('auth.login'))
    if request.method == 'GET':
        return render_template("public_question.html")
    else:
        form = QuestionForm(request.form)
        if form.validate():
            title = form.title.data
            content = form.content.data
            question = QuestionModel(title=title, content=content, author=g.user)
            db.session.add(question)
            db.session.commit()
            # todo: 跳转到这篇问答的首页
            return redirect('/')
        else:
            print(form.errors)
            return redirect(url_for('qa.public_question'))


@bp.route("/qa/detail/<qa_id>")
def qa_detail(qa_id):
    question = QuestionModel.query.get(qa_id)
    return render_template("detail.html", question=question)


@bp.route('/answer/public', methods=['POST'])
@login_required
def public_answer():
    form = AnswerForm(request.form)
    if form.validate():
        content = form.content.data
        question_id = form.question_id.data
        answer = AnswerModel(content=content, question_id=question_id, author_id=g.user.id)
        db.session.add(answer)
        db.session.commit()
        return redirect(url_for('qa.qa_detail', qa_id=question_id))
    else:
        print(form.errors)
        return redirect(url_for('qa.qa_detail', qa_id=request.form.get('question_id')))


@bp.route('/search')
def search():
    # 关键字传给视图函数的形式：
    # 1.查询字符串的形式 /search?q=flask
    # 2.关键字固定到路径当中  /search/<q>
    # 3.用POST请求 ，request.form
    q = request.args.get('q')
    questions = QuestionModel.query.filter(QuestionModel.title.contains(q)).all()
    return render_template("index.html", questions=questions)

# url传参
# 邮件发送
# ajax
# orm与数据库
# Jinja2模版
# cookie和session
# 搜索功能

# 前端
# 部署


