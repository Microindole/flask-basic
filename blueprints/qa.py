from flask import Blueprint, request, render_template, g, redirect, url_for
from .forms import QuestionForm, AnswerForm
from models import UserModel, QuestionModel, AnswerModel, QuestionLikeModel
from exts import db
from decorators import login_required
from flask import jsonify

bp = Blueprint('qa', __name__, url_prefix='/')


# http://127.0.0.1:5000
@bp.route('/')
def index():
    questions = QuestionModel.query.order_by(QuestionModel.create_time.desc()).all()
    
    # 如果用户已登录，查询用户的点赞状态
    user_likes = {}
    if g.user:
        likes = QuestionLikeModel.query.filter_by(user_id=g.user.id).all()
        user_likes = {like.question_id: True for like in likes}
    
    return render_template('index.html', questions=questions, user_likes=user_likes)


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


@bp.route("/qa/detail/<int:qa_id>")
def qa_detail(qa_id):
    question = QuestionModel.query.get(qa_id)
    
    # 检查当前用户是否已点赞
    user_liked = False
    if g.user:
        user_liked = QuestionLikeModel.query.filter_by(
            question_id=qa_id, 
            user_id=g.user.id
        ).first() is not None
    
    return render_template('detail.html', question=question, user_liked=user_liked)


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
    
    # 搜索结果为空时，传递提示信息
    search_info = None
    if q:
        if not questions:
            search_info = {
                "keyword": q,
                "count": 0,
                "message": f"没有找到与 '{q}' 相关的问题"
            }
        else:
            search_info = {
                "keyword": q,
                "count": len(questions),
                "message": f"找到 {len(questions)} 个与 '{q}' 相关的问题"
            }
    
    return render_template("index.html", questions=questions, search_info=search_info)

@bp.route('/qa/like', methods=['POST'])
@login_required
def like_question():
    """点赞/取消点赞问题"""
    question_id = request.form.get('question_id')
    if not question_id:
        return jsonify({'success': False, 'message': '问题ID不能为空'})
    
    question = QuestionModel.query.get(question_id)
    if not question:
        return jsonify({'success': False, 'message': '问题不存在'})
    
    # 检查用户是否已经点赞过
    existing_like = QuestionLikeModel.query.filter_by(
        question_id=question_id, 
        user_id=g.user.id
    ).first()
    
    if existing_like:
        # 已点赞，则取消点赞
        db.session.delete(existing_like)
        db.session.commit()
        # 更新点赞数（由于有触发器，这里可以直接查询最新数据）
        db.session.refresh(question)
        return jsonify({
            'success': True, 
            'action': 'unliked',
            'likes_count': question.likes_count,
            'message': '取消点赞成功'
        })
    else:
        # 未点赞，则添加点赞
        new_like = QuestionLikeModel(question_id=question_id, user_id=g.user.id)
        db.session.add(new_like)
        db.session.commit()
        # 更新点赞数
        db.session.refresh(question)
        return jsonify({
            'success': True, 
            'action': 'liked',
            'likes_count': question.likes_count,
            'message': '点赞成功'
        })

# url传参
# 邮件发送
# ajax
# orm与数据库
# Jinja2模版
# cookie和session
# 搜索功能

# 前端
# 部署


