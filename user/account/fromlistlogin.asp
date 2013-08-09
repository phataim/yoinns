<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<!--#include file="../../common/api/cls_sms.asp"-->
<%
Dim Action
Dim username,password,autologin
Dim email,confirm,city_id,mobile,subscribe,userid,manager,validcode,affirm,reg_code
Dim isCheckCode,loginip

loginip = Request.ServerVariables("REMOTE_ADDR")

isCheckCode = Dream3User.IsCheckCode(loginip)
	Action = Request.QueryString("act")
	Select Case Action
		Case "login"
			Call Login()
		Case "save"
			Call SaveRecord()
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

	Sub SaveRecord()

		email=  Dream3CLS.RParam("email")
		username =  Dream3CLS.RParam("username")
		password=  Dream3CLS.RParam("password")
		confirm=  Dream3CLS.RParam("confirm")
		mobile=  Dream3CLS.RParam("mobile")
		city_id=  Dream3CLS.RParam("city_id")
		subscribe=  Dream3CLS.RParam("subscribe")
		affirm=  Dream3CLS.RParam("affirm")
		reg_code= Dream3CLS.RParam("reg_code")
		'validate Form
		
		If affirm = "" Then
			gMsgArr = "����ͬ��ע�����"
			gMsgFlag = "E"
			Exit Sub
		End If
		
		If username = "" Then
			gMsgArr = gMsgArr&"|�û�������Ϊ�գ�"
		End If
		If username<>"" and (Dream3CLS.strLength(username) < 4 or Dream3CLS.strLength(username) > 16) Then
			gMsgArr = gMsgArr&"|�û���������4-16���ַ�֮�䣡"
		elseif InStr(UserName, "=") > 0 Or InStr(UserName, ".") > 0 Or InStr(UserName, "%") > 0 Or InStr(UserName, Chr(32)) > 0 Or InStr(UserName, "?") > 0 Or InStr(UserName, "&") > 0 Or InStr(UserName, ";") > 0 Or InStr(UserName, ",") > 0 Or InStr(UserName, "'") > 0 Or InStr(UserName, ",") > 0 Or InStr(UserName, Chr(34)) > 0 Or InStr(UserName, Chr(9)) > 0 Or InStr(UserName, "��") > 0 Or InStr(UserName, "$") > 0 Or InStr(UserName, "*") Or InStr(UserName, "|") Or InStr(UserName, """") > 0 Then
			gMsgArr = gMsgArr&"|�û����к��зǷ����ַ���"
		End If
		
		'email��Ϊ����
		'If email = "" Then
		'	gMsgArr = gMsgArr&"|�ʼ���ַ����Ϊ�գ� "
		'End If
		
		If email<>"" and not Dream3CLS.IsValidEmail(email) Then
			gMsgArr = gMsgArr&"|Email���Ϸ���"
		End If
		
		
			
		
		If password = "" Then
			gMsgArr = gMsgArr&"|���벻��Ϊ�գ�"
		End If
		
		If password <> "" and (password<>confirm) Then
			gMsgArr = gMsgArr&"|�����ȷ�����벻����"
		End If
		
		'����ֻ��������
		If Dream3CLS.SiteConfig("IsForceMobile") = "1" Then
			If mobile = "" Then
				gMsgArr = gMsgArr&"|�ֻ�������"
			End If
		End If	
		
		
		If mobile<>"" and not Dream3CLS.validate(mobile,4) Then
			gMsgArr = gMsgArr&"|�ֻ����벻�Ϸ���"
		End If
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		telcode = session("r_no") '��ȡ��֤��
		if telcode="" Then
			gMsgArr = gMsgArr&"|��û����д�ֻ���֤��"
		else
			if reg_code <> telcode then
				gMsgArr= gMsgArr&"|����д���ֻ���֤��"&reg_code&"����ȷ������������"
			end if
		end if
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		
		'�ж��Ƿ��Ѿ����ڼ�¼
		Sql = "select id from T_User Where email='"&email&"'"
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "Email�Ѿ����ڣ�"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		Sql = "select id from T_User Where username='"&username&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "�û����Ѿ����ڣ�"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		Sql = "select id from T_User Where mobile='"&mobile&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "�ֻ������Ѵ��ڣ�"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		validcode = Dream3CLS.GetRandomize(32)
		
		Sql = "select count(id) from T_User"
		
		Set Rs = Dream3CLS.Exec(Sql)
		userCount = Rs(0)
		
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_User "
		Rs.open Sql,conn,1,2
		Rs.AddNew
		Rs("username") = username
		Rs("password") 	= md5(password)
		Rs("email") 	= email
		Rs("mobile") 	= mobile
		
		Rs("ip") = Request.ServerVariables("REMOTE_ADDR")
		Rs("validcode") = validcode
		Rs("create_time")= now()
		Rs("state")= 1
		If userCount = 0 Then
			manager = "Y"
		Else
			manager = "N"
		End If
		Rs("manager") 	= manager
		If Dream3CLS.SiteConfig("IsMailVaild") = "1" Then
			enabled = "N"
		Else
			enabled = "Y"
		End If
		Rs("enabled") 	= enabled
		
		citysql = "select * from T_City where depth = 3 order by citypostcode "
		Set cityRs = Dream3CLS.Exec(citysql)
		If Not cityRs.EOF Then
			Rs("city_code") 	= cityRs("citypostcode")
		Else
			Rs("city_code") = "0"
		End If

		Rs.Update
		Rs.Close
		Set Rs = Nothing

		'�õ���ǰ�û���ID
		Sql = "Select id From T_User Where username ='"&username&"'"
		Set Rs = Dream3CLS.Exec(Sql)
		userid = Rs(0)
		
		

		'�����Ҫ��֤��������֤�ʼ�
		If Dream3CLS.SiteConfig("IsMailVaild") = "1" Then
			Call SendRegMail()
			If gMsgFlag = "E" Then
				Exit Sub
			Else
				response.Redirect("signupresult.asp")
				response.End()
			End If
		End If
		
		gMsgFlag = "S"
		'Dream3CLS.showMsg "����ɹ�","S","index.asp"
		'���Session����ʱ������cookies��
		
		CleanCookies()
		
		Session("_UserName") = username
		Session("_UserID") = userid
		Session("_IsManager") = manager
		If manager = "Y" then
			Session("_IsManagerLogin") = "Y"
		End If
		
		Response.Cookies(DREAM3C)("_UserID") = userid
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		'ȡ��ע��ɹ�������
		'����ע��ɹ�����
		'Call SendSMS() 
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		
		response.Redirect("../../index.asp")
		
	End Sub
	
	Sub SendRegMail()
		Dim HtmlTitle,HtmlContent,regConfirmUrl
		'title
		HtmlTitle = Dream3Tpl.LoadTemplate("mail_reg_title")
		HtmlTitle = Replace(HtmlTitle, "{$SiteShortName}", Dream3CLS.SiteConfig("SiteShortName"))
		'content
		HtmlContent = Dream3Tpl.LoadTemplate("mail_reg_content")
		HtmlContent = Replace(HtmlContent, "{$SiteName}", Dream3CLS.SiteConfig("SiteName"))
		HtmlContent = Replace(HtmlContent, "{$UserName}", username)
		regConfirmUrl = GetSiteUrl() & "/user/account/reg.asp?id="&userid&"&code="&validcode
		HtmlContent = Replace(HtmlContent, "{$Reg_Confirm_Url}",regConfirmUrl )
		
		cmEmail.SendMail email,HtmlTitle,HtmlContent
		If cmEmail.Count>0 Then
			'���ͳɹ�
		Else
			gMsgArr = "��֤�ʼ�����ʧ�ܣ��������Ա��ϵ��"
			gMsgFlag = "E"
		End If

	End Sub
	
	Sub Main()	
		autologin = "1"
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<script language="javascript" src="../sms/m_js.js"></script>

<div class="area">
	
    <div class="reg_cente">
	<form class="validator" method="post" action="?act=login" id="loginForm" name="loginForm">
    	<div class="reg_left">
        	<dl>
            	<dt>��½</dt>
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
			<input type="submit" value="���ϵ�½!" name="commit" class="login_bottom">
			</p>
        </div>
		 </form>
       <form class="validator" action="?act=save" method="post" id="signupForm" name="signupForm">
	   <div class="login_right">
        	<dl>
            	<dt>��ͨ�û�ע��</dt>
				<dd>�û���/�ǳƣ�
				<input type="text" value="�ֻ�����/����/�û���" class="reg_txt" id="Text1" name="username"onclick="value='';focus()"
>  <font color="ff0000">*</font>             <span class="validatorMsg"><br />��д4-16���ַ���һ������Ϊ�����ַ���</span>
				</dd>

                <dd>���룺
				<input type="password" value="" class="reg_txt" id="password1" name="password"> <font color="ff0000">*</font> 
				<span class="validatorMsg"><br />Ϊ�������ʺŰ�ȫ������������������Ϊ6���ַ����ϡ�</span>			
				</dd>
                
                <dd>ȷ�����룺
				<input type="password" value="" class="reg_txt" id="confirm" name="confirm"> <font color="ff0000">*</font> 
				<span class="validatorMsg"><br />���ٴ�������������</span>
				</dd>
               
                <dd>���䣺
				<input type="text" name="email" id="email" class="reg_txt" value="<%=email%>"/> 
				<span class="validatorMsg"><br />���ڵ�¼���һ����룬���ṫ�����������д��</span>
				</dd>
                
                
                
                <dd>�ֻ����룺
				<input type="text" value="<%=mobile%>" class="reg_txt2" id="mobile" name="mobile"  maxlength="13" /> <font color="ff0000">*</font> 
                <!--mike -->
				<br /><span class="validatorMsg">����������ֻ�����</span>
                <input name="regcodesub" type="button" value="������֤��" onclick="send_sms()" />
                <!--mike -->

				</dd>
                
				<dd>��֤��:
				<br />
                <!--mike -->
                <input type="text" value="<%=reg_code%>" class="reg_txt3"  name="reg_code" id="reg_code"  onkeydown="check_r_no();" onkeyup="check_r_no();" onclick="check_r_no();" ><!--mike --><span id="is_ok_reg"></span><!--mike -->
                <!--mike -->
                <span class="validatorMsg"><br />����������ֻ���֤��</span>
				</dd>
            </dl>
            <p style="width:340px;float:left;margin-top:20px;">
            <input type="checkbox" id="affirm" name="affirm" checked="" autocomplete="off">&nbsp;
            �����Ķ���ͬ��<%=Dream3CLS.SiteConfig("SiteShortName")%>�ķ�������<a href="../../help/index.asp?c=terms" target=_blank>��<%=Dream3CLS.SiteConfig("SiteShortName")%>�������</a>
            </p>
            <p id="register"><a class="reg_button" href="#" onclick="document.signupForm.submit();">����ע��!</a></p>
        </div>
	  
	   
    </div>
    
	
	
</div>


 
 
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