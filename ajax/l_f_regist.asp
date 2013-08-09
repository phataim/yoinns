<%
Response.Charset="gb2312"
Function RParam(param) 
	Dim oriValue 
	oriValue = Trim(Request(param))
			
	RParam = oriValue
End Function
Dim to_be_submit_f
to_be_submit_f=RParam("to_be_submit_f")

%>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<div id="l_f_inner_container" >
	<div id="l_f_head">
    </div>    
    <div id="l_f_select">
    	<ul id="l_f_tab">
        	<li><a href="javascript:void(0)" onclick="f_clear('l_f_regist');load_login('<%=to_be_submit_f%>')">登  录</a></li>
            <li>注  册</li>
        </ul>
		<span class="l_f_close" onclick="f_clear('l_f_regist')"></span>
    </div >
    <div id="l_f_form_div">
    <form id="l_f_form" action="/user/account/normalsignup.asp?act=save" name="l_f_form" onsubmit="return l_f_regist(this,'<%=to_be_submit_f%>')">
    	<div class="l_f_item">
    		<span class="l_f_label">手机号：</span>
    		<div class="l_f_input">
            	<input type="text" class="text_blank" id="mobile_number" name="mobile_number" onblur="if(this.value==''){this.value='请输入您的手机号';this.style.color='#999'}" onfocus="if(this.value=='请输入您的手机号'){this.value='';this.style.color='#333'}" value="请输入您的手机号" autocomplete="off" style="color: rgb(153, 153, 153); " />
        	</div>
            <span class="l_f_label" style="width:90px;"><a href="javascript:void(0)" onclick="l_f_send_sms('mobile_number','check_code')">发送验证码</a></span>
        </div>
        <div class="l_f_item" >
    		<span class="l_f_label">验证码：</span>
    		<div class="l_f_input">
            	<input type="text" class="text_blank" id="check_code" name="check_code" disabled="disabled" onblur="if(this.value==''){this.value='请输入您收到的验证码';this.style.color='#999'}" onfocus="if(this.value=='请输入您收到的验证码'){this.value='';this.style.color='#333'}" value="请输入您收到的验证码" style="color: rgb(153, 153, 153); " />
        	</div>
        </div>
        <div class="l_f_item">
    		<span class="l_f_label">密  码：</span>
    		<div class="l_f_input">
            	<input type="password" class="text_blank " id="l_f_passwd" name="l_f_passwd" onfocus="var n=this.nextSibling.nextSibling;n.innerHTML=''" onblur="if(this.value==''){var n=this.nextSibling.nextSibling;n.innerHTML=n.getAttribute('default_text')}"/>
            	<label class="ps_label" for="l_f_passwd" default_text="至少6个字符">至少6个字符</label>
            </div>
            <span class="l_f_label" style="width:90px;"></span>
        </div>
		<div class="l_f_item">
    		<span class="l_f_label">确认密码：</span>
    		<div class="l_f_input">
            	<input type="password" class="text_blank " id="l_f_passwd_confirm" name="l_f_passwd_confirm" onfocus="var n=this.nextSibling.nextSibling;n.innerHTML=''" onblur="if(this.value==''){var n=this.nextSibling.nextSibling;n.innerHTML=n.getAttribute('default_text')}"/>
            	<label class="ps_label" for="l_f_passwd_confirm" default_text="请再次输入密码">请再次输入密码</label>
            </div>
            <span class="l_f_label" style="width:90px;"></span>
        </div>
        <div class="l_f_item">
            <span class="l_f_label">&nbsp;</span>
            <div class="l_f_input">
                <label><input type="checkbox" id="affirm" name="affirm" checked="checked"/>&nbsp;我已阅读并接受</label><a href="/help/index.asp?c=terms" target="_blank">《有旅馆服务条款》</a>
            </div>
        </div>
        <div class="l_f_item">
        	<span class="l_f_label">&nbsp;</span>
            <input type="submit" class="login_bottom" value="注  册" style="margin-top:0"/>
            <label style="line-height:43px">&nbsp;&nbsp;&nbsp;&nbsp;已注册?<a href="javascript:void(0)" onclick="f_clear('l_f_regist');load_login('<%=to_be_submit_f%>')">立即登录</a></label>
        </div>
    </form>
    </div>
</div>
