<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../../common/api/cls_email.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<!--#include file="../../common/api/cls_sms.asp"-->
<!--#include file="../../common/api/cls_xml.asp"-->
<%
Dim Action
Dim username,email,password,confirm,city_id,mobile,subscribe,userid,manager,validcode,affirm,reg_code,hotelname,headname

	Action = Request.QueryString("act")
	Select Case Action
		Case "save"
			Call SaveRecord()
		Case Else
			Call Main()
	End Select
	
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

		
		
		If email<>"" and not Dream3CLS.IsValidEmail(email) Then
			gMsgArr = gMsgArr&"|Email���Ϸ���"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		
		'�ж��Ƿ��Ѿ����ڼ�¼
		If email<>"" Then
		Sql = "select id from T_User Where email='"&email&"'"
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "Email�Ѿ����ڣ�"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
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
		Rs("state")= 2
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
	
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
	Sub SendSMS()

		'If Cint(Dream3CLS.SiteConfig("SendRegSMS")) <> 1  Then Exit Sub
		'If IsNull(mobile) Or Len(mobile) <=0 Then Exit Sub
		'content = GetSMSRegSuccessContent()

		'result = Dream3SMS.SendSMS(mobile,content)
		''If result <> "success" Then
		'	'gMsgArr = "ע��ɹ����ŷ���ʧ�ܣ�"
		'	'gMsgFlag = "E"
		''End If

	End Sub
	
	Function GetSMSRegSuccessContent()
		
		'Dim HtmlSMS
		'HtmlSMS = Dream3Tpl.LoadTemplate("sms_signup_success_content")
		'HtmlSMS = Replace(HtmlSMS, "{$SiteName}",Dream3CLS.SiteConfig("SiteName"))
		'HtmlSMS = Replace(HtmlSMS, "{$UserName}",username)
		'GetSMSRegSuccessContent = HtmlSMS
	End Function
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
	
	Sub Main()	
		subscribe = "1"
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=Dream3CLS.SiteConfig("SiteName")%>-�û�ע��</title>
<!--mike -->
<script language="javascript" src="../sms/m_js.js"></script>
<!--mike -->
<form class="validator" action="?act=save" method="post" id="signupForm" name="signupForm">
<div class="area">
	
    <div class="reg_cente">
    	<div class="reg_left">
        	<dl>
            	<dt>�̼��û�ע��</dt>
				<dd>�û���/�ǳƣ�
				<input type="text" value="����ʹ���õ�����" class="reg_txt" id="username" name="username" onclick="this.value=''">
				<span class="validatorMsg"><br />��д4-16���ַ���һ������Ϊ�����ַ���</span>
				</dd>
                
                
				
                <dd>���룺
				<input type="password" value="" class="reg_txt" id="password" name="password">
				<span class="validatorMsg"><br />Ϊ�������ʺŰ�ȫ������������������Ϊ6���ַ����ϡ�</span>
				</dd>
                
                <dd>ȷ�����룺
				<input type="password" value="" class="reg_txt" id="confirm" name="confirm">
				<span class="validatorMsg"><br />���ٴ�������������</span>
				</dd>
                
                <dd>���䣺
				<input type="text" name="email" id="email" class="reg_txt" value="<%=email%>"/>
				<span class="validatorMsg"><br />���ڵ�¼���һ����룬���ṫ�����������д��</span></dd>
                
                
                <dd>�ֻ����룺
				<input type="text" value="<%=mobile%>" class="reg_txt2" id="mobile" name="mobile"  maxlength="13" />
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
            �����Ķ���ͬ��<%=Dream3CLS.SiteConfig("SiteShortName")%>�ķ�������<a href="#">��<%=Dream3CLS.SiteConfig("SiteShortName")%>�������</a>
            </p>
            <p id="register"><a class="reg_button" href="#" onclick="document.signupForm.submit();">����ע��!</a></p>
        </div>
        <div class="reg_right">
            <dl>
                <dt class="font18">����<%=Dream3CLS.SiteConfig("SiteShortName")%>��Ա����ֱ�ӵ�¼</dt>
                <dd><a class="reg_log" href="login.asp">��½</a></dd>
            </dl>
        </div>
    </div>
    
</div>

</form>
<script language="javascript">
	function runcodes(sum){
		var rr="";
		var str="";
		for(k=0;k<sum;k++){
			aa=runcode();
			rr=aa+""+rr;
			//alert(rr);
		}		
		document.cookie='telcode=' + escape(rr);
		str = document.getElementById("reg_code");
		str.value=rr;
	}
	function runcode(){
		arr = new Array(9);
		for(i=0;i<arr.length;i++){
			arr[i]=i;
		}
		var r=parseInt(arr.length*Math.random()); 
		return r;
		��
	}

</script>


<!--#include file="../../common/inc/footer_user.asp"-->
