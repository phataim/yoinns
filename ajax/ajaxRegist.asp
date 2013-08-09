<!--#include virtual="/conn.asp"-->
<!--#include virtual="/common/api/cls_main.asp"-->
<!--#include virtual="/common/api/cls_product.asp"-->
<!--#include virtual="/common/api/cls_user.asp"-->
<!--#include virtual="/common/api/cls_tpl.asp"-->
<!--#include virtual="/common/api/cls_email.asp"-->
<!--#include virtual="/common/api/MD5.asp"-->
<!--#include virtual="/common/api/cls_sms.asp"-->
<!--#include virtual="/common/api/cls_xml.asp"-->
<%

Dim username,password,confirm,mobile,userid,manager,validcode,affirm,reg_code

Dim regist_r,regist_msg

	Call SaveRecord()
    
    Call reponseRegistResult()
	
	Sub SaveRecord()

		username =  Dream3CLS.RParam("mobile_number")
		password=  Dream3CLS.RParam("l_f_passwd")
		confirm=  Dream3CLS.RParam("l_f_passwd_confirm")
		mobile=  Dream3CLS.RParam("mobile_number")
		affirm=  Dream3CLS.RParam("affirm")
		reg_code= Dream3CLS.RParam("check_code")
		'validate Form
		
		If affirm = "" Then
			regist_msg = "请先接受注册条款！"
			regist_r = 0
			Exit Sub
		End If
		
		If password = "" Then
			regist_msg = "请输入密码！"
			regist_r = 0
			Exit Sub
		End If
		
		If password <> "" and (password<>confirm) Then
			regist_msg = "密码和确认密码不符！"
			regist_r = 0
			Exit Sub
		End If
		
	
		If mobile = "" Then
			regist_msg = "请填写手机号！"
			regist_r = 0
			Exit Sub
		End If
	
		If mobile<>"" and not Dream3CLS.validate(mobile,4) Then
			regist_msg = "手机号码不合法！"
			regist_r = 0
			Exit Sub
		End If
		
		telcode = session("r_no") '读取验证码
		If telcode="" Then
			regist_msg = "请填写手机验证码！"
			regist_r = 0
			Exit Sub
		else
			If reg_code <> telcode then
				regist_msg=  "您填写的手机验证码不正确，请重新输入！"
				regist_r = 0
			    Exit Sub
			End If
		End If
		
		Sql = "select id from T_User Where username='"&username&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			regist_msg = "手机号码已存在！"
			regist_r = 0
			Exit Sub
		End If

		Sql = "select id from T_User Where mobile='"&mobile&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			regist_msg = "手机号码已存在！"
			regist_r = 0
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

		'得到当前用户的ID
		Sql = "Select id From T_User Where username ='"&username&"'"
		Set Rs = Dream3CLS.Exec(Sql)
		userid = Rs(0)

		
		regist_r = "1"
		
		CleanCookies()
		
		Session("_UserName") = username
		Session("_UserID") = userid
		Session("_IsManager") = manager
		If manager = "Y" then
			Session("_IsManagerLogin") = "Y"
		End If
		
		Response.Cookies(DREAM3C)("_UserID") = userid
		
		
	End Sub
	
	
	
	Sub SendSMS()

		'If Cint(Dream3CLS.SiteConfig("SendRegSMS")) <> 1  Then Exit Sub
		'If IsNull(mobile) Or Len(mobile) <=0 Then Exit Sub
		'content = GetSMSRegSuccessContent()

		'result = Dream3SMS.SendSMS(mobile,content)
		''If result <> "success" Then
		'	'gMsgArr = "注册成功短信发送失败！"
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
	
	Sub reponseRegistResult()
		response.Write("{""regist_r"":"""+Cstr(regist_r)+""",""regist_msg"":"""+Cstr(regist_msg)+"""}")
	End Sub
	
%>