<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_email.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../sms/m_codepublic.asp"-->
<%
Dim Action
Dim mobile,password,email
Dim isCheckCode,checkcode
Dim opFlag,validcode,userid,reg_code 'mike

loginip = Request.ServerVariables("REMOTE_ADDR")

	Action = Request.QueryString("act")
	Select Case Action
		Case "nextstep"
			Call Nextstep()
		Case Else
				Call Main()
	End Select
	
	Sub Nextstep()
	
		mobile =  Dream3CLS.RSQL("mobile")
		checkcode=  Dream3CLS.RParam("checkcode")
		reg_code=  Dream3CLS.RParam("reg_code") 'mike
		'validate Form
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		If mobile = "" Then
			gMsgArr = "请输入手机号！"
		End If
		'如果手机号码必填
		
		If mobile<>"" and not Dream3CLS.validate(mobile,4) Then
			gMsgArr = gMsgArr&"|手机号码不合法！"
		End If
		
		'判断是手机是否存在
		Sql = "select id from T_User Where mobile='"&mobile&"'" '检测手机是否存在 
		rs.open sql,conn,1,1
		if rs.recordcount=0 then '找不到记录
			gMsgArr = gMsgArr&"|"&mobile&"此手机号还未在网站注册过！"
		end if 
		rs.close

		telcode = session("r_no") '读取验证码
		if telcode="" Then
			gMsgArr = gMsgArr&"|您没有填写手机验证码"
		else
			if reg_code <> telcode then
				gMsgArr= gMsgArr&"|您填写的手机验证码"&reg_code&"不正确，请重新输入"
			end if
		end if
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		If checkcode ="" Then
			gMsgArr = gMsgArr&"|请输入验证码！"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		If Not Dream3User.CodeIsTrue Then
			gMsgArr = gMsgArr&"|您输入的认证码和系统产生的不一致，请重新输入!"
			gMsgFlag = "E"
			Exit Sub
		End If


		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike				
		n_pw=Dream3CLS.GetRandomize(6) '新密码
		Sql = "select * from T_User Where mobile='"&mobile&"'"
		Rs.open Sql,conn,1,2
			rs("password")=MD5(n_pw) 'md5加密
		Rs.Update
		
		Rs.Close		
		
		text_r_no1="尊敬的“有旅馆”用户, 我们已经为您随机生成新的密码 "&n_pw&" ,您现在可以使用新密码登录了! 【有旅馆】"
	
		if sms_open=0 then
			at=mt(mobile,text_r_no1,ext,stime,rrid) '给远程地址发短信
		end if

		user_mobile=mobile
		user_r_no1=n_pw
		user_r_no2=""
		user_r_no3=mobile
		user_order_id=0
		user_order_name="forgetPW_send_OK"
		user_is_back=0
				
		call sms_save(user_mobile,user_r_no1,user_r_no2,user_r_no3,user_order_id,user_order_name,at2,user_is_back,3) '用户保存

		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		If gMsgFlag = "E" Then
			Exit Sub
		End If
		opFlag = "showresult"
		
	End Sub

	
	Sub Main()	

	End Sub
	
%>
<!--#include file="../../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<!--mike -->
<script language="javascript" src="../sms/m_js.js"></script>
<!--mike -->


<form class="validator" method="post" action="?act=nextstep" id="loginForm" name="loginForm">
<div class="area">
	
    <div class="reg_cente">
		<%
		If opFlag <> "showresult" Then
		%>
    	<div class="reg_left">
        	<dl>
                <!--mike -->
            	<dt>忘记密码</dt>
                <dd>第一步：请填写您注册时的手机号
				<input type="text" value="<%=mobile%>" class="reg_txt" id="mobile" name="mobile" style="width:215px"> <input name="regcodesub" type="button" value="发送验证码" onclick="send_sms_p()" style="width:80px;height:25px" />
				</dd>
                <dd>第二步：请填写手机收到的验证码
				<input type="text" value="" class="reg_txt" id="reg_code" name="reg_code" style="width:215px" onkeydown="check_r_no();" onkeyup="check_r_no();" onclick="check_r_no();" ><!--mike --><span id="is_ok_reg"></span><!--mike -->
				</dd>
				<dd>第三步：页面随机验证码：
                <!--mike -->
				<input name="checkcode" type="text" class="reg_txt" id="checkcode" size="5" maxlength="4" onFocus="get_checkcode();this.onfocus=null;" onKeyUp="ajaxcheckcode('check_code','checkcode');" style="width:215px"/>
		  <BR><span id="img_checkcode" style="cursor:pointer;" onClick="get_checkcode();">点击获取验证码</span><span id="isok_checkcode"></span>
				</dd>
            </dl>
            
            <p><a class="login_bottom" href="#" onclick="document.loginForm.submit();">下一步!</a></p>
        </div>
		
		<%Else%>
		<div class="reg_left">
        	<dl>
            	<dt>提示</dt>
                <dd>新的密码已发送到您的手机！<br>
				请保管好您的密码，以免造成不必要的损失！<br><br>
				</dd>
				
            </dl>
        </div>
		<%End If%>
        <div class="reg_right">
            <dl>
                <dt class="font18">还没有<%=Dream3CLS.SiteConfig("SiteShortName")%>账户吗？</dt>
                <dd><a class="reg_log" href="signup.asp">注册</a></dd>
            </dl>
        </div>
    </div>
    
</div>
</form>

<script language="javascript">
<!--//
var show_checkcode = false;
function get_checkcode() {
	var chkCodeFile = "../../common/inc/getcode.asp";
	if(!show_checkcode){
		if(document.getElementById("img_checkcode"))
			document.getElementById("img_checkcode").innerHTML = '<img  id="checkcodeimg" src="'+chkCodeFile+'?t='+Math.random()+'" alt="点击刷新验证码" style="cursor:pointer;border:0;vertical-align:middle;height:18px;" onclick="this.src=\''+chkCodeFile+'?t=\'+Math.random()" />'
			show_checkcode = true;

		if(document.getElementById("isok_checkcode"))
			document.getElementById("isok_checkcode").innerHTML = '<a href="javascript://" onclick="setTimeout(function(){ document.getElementById(\'checkcodeimg\').src=\''+chkCodeFile+'?t=\'+Math.random()},100);">看不清<\/a>';
	}
}
//-->
</script>
<!--#include file="../../common/inc/footer_user.asp"-->