from functools import wraps
from flask import g, redirect, url_for


# 装饰器
# 装饰器会接受一个函数作为参数  万能参数 *args  **kwargs
def login_required(func):
    # 保留func的信息
    @wraps(func)
    # func(1,2,c=3) => 1,2传入args中 c=3传入kwargs
    def inner(*args, **kwargs):
        if g.user:
            return func(*args, **kwargs)
        else:
            return redirect(url_for('auth.login'))
    return inner

# 代码解释
# @login_required
# def public_question(question_id):
#     pass
#
# login_required(public_question)(question_id)
