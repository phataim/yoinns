<%
Response.Charset="gb2312"
Function RParam(param) 
	Dim oriValue 
	oriValue = Trim(Request(param))
			
	RParam = oriValue
End Function
Dim isCheckCode,loginip,to_be_submit_f,loginTimes

loginTimes=Request.Cookies("loginTimes")

If loginTimes="" Then
    loginTimes=0
    isCheckCode=0
Else 
    If loginTimes>3 Then
        isCheckCode=1
    End If    
End If

to_be_submit_f=RParam("to_be_submit_f")

%>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<div id="l_f_inner_container" >
	<div id="l_f_head">
    </div>    
    <div id="l_f_select">
    	<ul id="l_f_tab">
        	<li>登  录</li>
            <li><a href="javascript:void(0);" onclick="f_clear('l_f_login');load_regist('<%=to_be_submit_f%>')">注  册</a></li>
        </ul>
		<span class="l_f_close" onclick="f_clear('l_f_login')"></span>
    </div >
    <div id="l_f_form_div">
    <form action="/user/account/normallogin.asp?act=login" id="l_f_form" name="l_f_form" onsubmit="return l_f_login(this,'<%=to_be_submit_f%>')">
    	<div class="l_f_item">
    		<span class="l_f_label">账户名：</span>
    		<div class="l_f_input">
        		<input type="text" class="text_blank" id="l_f_username" name="l_f_username" onblur="if(this.value==''){this.value='邮箱/手机号/用户名';this.style.color='#999'}" onfocus="if(this.value=='邮箱/手机号/用户名'){this.value='';this.style.color='#333'}" value="邮箱/手机号/用户名" autocomplete="off" style="color: rgb(153, 153, 153); " />
        	</div>
        </div>
        <div class="l_f_item">
    		<span class="l_f_label">密  码：</span>
    		<div class="l_f_input">
            	<input type="password" class="text_blank" id="l_f_passwd" name="l_f_passwd"  onfocus="var n=this.nextSibling.nextSibling;n.innerHTML=''" onblur="if(this.value==''){var n=this.nextSibling.nextSibling;n.innerHTML=n.getAttribute('default_text')}"/>
            	<label class="ps_label" for="l_f_passwd" default_text="请输入密码">请输入密码</label>
            </div>
            <span class="l_f_label" style="width:90px;"><a href="/user/account/forgetpwd.asp">找回密码</a></span>
        </div>
		
		<%If isCheckCode Then%>
		<div class="l_f_item">
        	<span class="l_f_label">验证码：</span>
            <div class="l_f_input">
            	<input type="text" class="text_blank"  name="checkcode" id="checkcode" style="width:90px;"/>
            </div>
			<label>
				<img id="checkcode_img" src="/common/inc/getcode.asp?t=<%=time%>" title="点击刷新验证码" onclick="this.src='/common/inc/getcode.asp?t='+Math.random()" style="cursor:pointer"/>
			</label>
			&nbsp;&nbsp;&nbsp;&nbsp;看不清?<a href="javascript:void(0)" onclick="document.getElementById('checkcode_img').src='/common/inc/getcode.asp?t='+Math.random();">换一张</a>
        </div>
		<%End If%>
		
        <div class="l_f_item">
        	<span class="l_f_label">&nbsp;</span>
            <label>
            	<input type="checkbox" class="checkbox" checked="checked" name="autologin" />
                        自动登录
            </label>
        </div>
        <div class="l_f_item">
        	<span class="l_f_label">&nbsp;</span>
            <input type="submit" class="login_bottom" value="登  录" style="margin-top:0"/>
            <label style="line-height:43px">&nbsp;&nbsp;&nbsp;&nbsp;新用户?<a href="javascript:void(0);" onclick="f_clear('l_f_login');load_regist('<%=to_be_submit_f%>')">立即注册</a></label>
        </div>
    </form>
    </div>
</div>
