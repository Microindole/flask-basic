# 从flask这个包中导入Flask类
from flask import Flask, render_template

# 使用Flask类创建一个app对象
# __name__：代表当前app.py这个模块
# 1.以后出现bug，他可以帮助我们快速定位
# 2.对于寻找模版文件，有一个相对路径

app = Flask(__name__)

# 创建一个路由和视图函数的映射
# http://www.bilibili.com


@app.route('/')
def hello_world():  # put application's code here

    user1 = User('John', 'Doe')
    return render_template('index.html', user=user1)

# 1.debug模式

# 2.host
# 让其他电脑能访问本机项目.

# 3.修改端口号

# url:http[80]/https[443]
@app.route('/main')
def main_page():
    user2 = User('ohJn', 'Doe')
    return render_template('main.html', user=user2)

class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age



@app.route('/hello')
def line():
    return "alfnlsndv"

@app.route('/hello/<int:blog_id>')
def blog_details(blog_id):
    return "hello " + str(blog_id)

@app.route('/fliter')
def filter_demo():
    user = User(age= 18,name='fna')
    return render_template('fliter.html', user=user)

@app.route('/control')
def control_demo():
    age = 19
    return render_template("control.html", age=age)

@app.route('/child1')
def child1():
    return render_template("child1.html")

@app.route('/sta')
def sta():
    return render_template("sta.html")
















if __name__ == '__main__':
    app.run()
# debug=True