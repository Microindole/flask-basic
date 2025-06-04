function bindEmailCaptchaClick(){
    $('#captcha-btn').click(function (event){
        // 当前按钮的jquery对象
        var $this = $(this);
        event.preventDefault();
        var email = $("input[name='email']").val();
        $.ajax({

            url: "/auth/captcha/email?email="+email,
            method: "GET",
            success:function(result){
                var code = result['code'];
                if (code === 200){
                    var countdown = 5;
                    // 开始倒计时,前取消按钮的点击事件
                    $this.off("click");
                    var timer = setInterval(function (){
                        $this.text(countdown);
                        countdown -= 1;
                        if (countdown <= 0){
                            // 清掉定时器
                            clearInterval(timer);
                            // 将按钮的文字重新修改回来
                            $this.text("获取验证码");
                            // 重新绑定点击事件
                            bindEmailCaptchaClick();
                        }
                    },1000)
                    // alert("邮箱验证码发送成功！")
                }else{
                    alert(result['message']);
                }
            },
            fail: function (error){
                console.log(error);
            }

        })
    });
}


// 文档就绪函数
// 整个网页都加载完毕后再执行改函数
$(function (){
    bindEmailCaptchaClick();
})