from flask import Blueprint, render_template, request, flash, redirect, url_for, g
from sqlalchemy import text
from exts import db
from models import UserModel

bp = Blueprint("info", __name__, url_prefix='/info')

# 调用用户活跃度统计存储过程
def get_user_activity(user_id):
    try:
        sql_query = text("CALL sp_get_user_activity_summary(:user_id_param)")
        result = db.session.execute(sql_query, {"user_id_param": user_id})
        activity_summary = result.fetchone()
        if activity_summary:
            return {"total_questions": activity_summary[0], "total_answers": activity_summary[1]}
        else:
            return None
    except Exception as e:
        db.session.rollback()
        return None

# 调用验证码失效存储过程
def deactivate_old_captchas(days_threshold):
    try:
        sql_query = text("CALL sp_deactivate_old_unused_captchas(:days_threshold_param)")
        db.session.execute(sql_query, {"days_threshold_param": days_threshold})
        db.session.commit()
        return True
    except Exception as e:
        db.session.rollback()
        return False

# 用户活跃度页面
@bp.route('/user/<int:user_id>/activity')
def user_activity(user_id):
    user = UserModel.query.get(user_id)
    if not user:
        flash("用户不存在")
        return redirect(url_for('qa.index'))
    activity = get_user_activity(user_id)
    return render_template('info/user_activity.html', user=user, activity=activity)

# 管理员操作验证码失效
@bp.route('/admin/captcha', methods=['GET', 'POST'])
def admin_captcha():
    if request.method == 'POST':
        days = int(request.form.get('days', 7))
        success = deactivate_old_captchas(days)
        if success:
            flash(f"{days}天前未使用的验证码已被失效处理", "success")
        else:
            flash("操作失败", "danger")
        return redirect(url_for('info.admin_captcha'))
    return render_template('info/admin_captcha.html')