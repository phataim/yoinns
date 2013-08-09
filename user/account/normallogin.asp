<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<%
Dim Action
Dim username,password,autologin
Dim isCheckCode,loginip

loginip = Request.ServerVariables("REMOTE_ADDR")

isCheckCode = Dream3User.IsCheckCode(loginip)
	Action = Request.QueryString("act")
	Select Case Action
		Case "login"
			Call Login()
		Case Else
			Call Main()
	End Select
	
	Sub Login()
	
		username =  Dream3CLS.RSQL("username")
		password=  Dream3CLS.RParam("password")
		autologin=  Dream3CLS.RParam("autologin")

		'validate Form
		If username = "" Then
			gMsgArr = "�������û�����ע�������ע���ֻ����룡"
		End If
		
		If password ="" Then
			gMsgArr = gMsgArr&"|���������룡"
		End If
		
		'��¼��¼����
		Dream3User.LogIPLoginTimes(loginip)
		
		If isCheckCode Then
			If Not Dream3User.CodeIsTrue Then
				gMsgArr = gMsgArr&"|���������֤���ϵͳ�����Ĳ�һ�£�����������!"
			End If
		End If
		
		isCheckCode = Dream3User.IsCheckCode(loginip)
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		
		'�ж��Ƿ��Ѿ����ڼ�¼
		Sql = "select id from T_User Where username='"&username&"' or email='"&username&"'or mobile='"&username&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If  Rs.EOF Then
			gMsgArr = "�û��������ڣ�"
			username = ""
			gMsgFlag = "E"
			Rs.Close
			Call Main()
			Exit Sub
		End If
		
		Rs.Close
		
		Sql = "select * from T_User Where (username='"&username&"' or email='"&username&"' or mobile='"&username&"') and password='"&md5(password)&"'"
		
		
		Rs.open Sql,conn,1,2
		
		If  Rs.EOF Then
			gMsgArr = "�û������벻ƥ�䣡"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If  Rs("enabled")="N" Then
			gMsgArr = "�����˺�δͨ����֤���߱���������ʱ�޷���¼��"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		'Update Ip and Last_time
		Rs("ip") = loginip
		Rs("last_time") = Now
		Rs.Update
		
		'��ȡ������Ϣ������ʾ����ҳ
		If Dream3Product.IsUserOrder(Rs("id"))  Then
		Response.Cookies(DREAM3C)("_UserOrderFlag") = "Y"
		Else
			Response.Cookies(DREAM3C)("_UserOrderFlag") = "N"
		End If
		
		Session("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Session("_UserID") = Rs("id")
		Session("_IsManager") = Rs("manager")
		Session("_UserFace") = Rs("face")

		'Ĭ�ϱ���һ����
		Response.Cookies(DREAM3C).Expires = Date + 30
		Response.Cookies(DREAM3C)("_UserID") = Rs("id")
		Response.Cookies(DREAM3C)("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Response.Cookies(DREAM3C)("_Password") =  Rs("password")
		Response.Cookies(DREAM3C)("_IsManager") =  Rs("manager")
		Response.Cookies(DREAM3C)("_UserCityCode") =  Rs("city_code")
		
		Rs.Close
		Set Rs = Nothing
		

		
		response.Redirect("../../index.asp")
		
	End Sub

	
	Sub Main()	
		autologin = "1"
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<form class="validator" method="post" action="?act=login" id="loginForm" name="loginForm">
<div class="area">
	
    <div class="reg_cente">
    	<div class="reg_left">
        	<dl>
            	<dt>��¼</dt>
                <dd>����/��¼��/�ֻ��ţ�
				<input type="text" value="<%=username%>" class="reg_txt" id="username" name="username">
				</dd>
                <dd>���룺
				<input type="password" value="" class="reg_txt" id="password" name="password">
				</dd>
				<BR><span class="validatorMsg"><a href="forgetpwd.asp">�������룿</a></span>
				<%If isCheckCode Then%>
				<dd>��֤�룺
				<input name="checkcode" type="text" class="reg_txt" id="checkcode" size="5" maxlength="4" onFocus="get_checkcode();this.onfocus=null;" onKeyUp="ajaxcheckcode('check_code','checkcode');" />
		  <BR><span id="img_checkcode" style="cursor:pointer;" onClick="get_checkcode();">�����ȡ��֤��</span><span id="isok_checkcode"></span>
				</dd>
				<%End If%>
                
            </dl>
            <p style="width:340px;float:left;margin-top:20px;" class="validatorMsg">
			<input type="checkbox" value="1" name="autologin" id="autologin" class="f-check" <%If autologin = "1" Then response.Write("checked")%> />
			&nbsp;
            �´��Զ���¼
            </p>
            <p>
			<input type="submit" value="���ϵ�¼!" name="commit" class="login_bottom">
			</p>
        </div>
        <div class="reg_right">
            <dl>
                <dt class="font18">��û��<%=Dream3CLS.SiteConfig("SiteShortName")%>�˻���</dt>
                <dd><a class="reg_log" href="signup.asp">ע��</a></dd>
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
			document.getElementById("img_checkcode").innerHTML = '<img  id="checkcodeimg" src="'+chkCodeFile+'?t='+Math.random()+'" alt="���ˢ����֤��" style="cursor:pointer;border:0;vertical-align:middle;height:18px;" onclick="this.src=\''+chkCodeFile+'?t=\'+Math.random()" />'
			show_checkcode = true;

		if(document.getElementById("isok_checkcode"))
			document.getElementById("isok_checkcode").innerHTML = '<a href="javascript://" onclick="setTimeout(function(){ document.getElementById(\'checkcodeimg\').src=\''+chkCodeFile+'?t=\'+Math.random()},100);">������<\/a>';
	}
}
//-->
</script>
<!--#include file="../../common/inc/footer_user.asp"-->