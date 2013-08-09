<!--#include virtual="/conn.asp"-->
<!--#include virtual="/common/api/cls_Main.asp"-->
<!--#include virtual="/common/api/cls_product.asp"-->
<!--#include virtual="/common/api/cls_user.asp"-->
<!--#include virtual="/common/api/MD5.asp"-->
<%
Dim username,password,autologin
Dim isCheckCode,loginip,loginTimes
Dim login_r,login_msg,checkcode_r

loginip = Request.ServerVariables("REMOTE_ADDR")

loginTimes=Request.Cookies("loginTimes")

If loginTimes="" Then
    loginTimes=0
    isCheckCode=0
Else 
    If loginTimes>3 Then
        isCheckCode=1
    End If    
End If

	Call Login()
	Call reponseLoginResult()
	
	Sub Login()
	    
		username =  Dream3CLS.RSQL("l_f_username")
		password=  Dream3CLS.RParam("l_f_passwd")
		autologin=  Dream3CLS.RParam("autologin")

		If (username = "" or password ="") Then
			login_msg = "请输入用户名或密码！"
			login_r=0
			Exit Sub
		End If
		
		'记录登录次数
		'Dream3User.LogIPLoginTimes(loginip)
		
		If isCheckCode Then
			If Not Dream3User.CodeIsTrue Then
				login_msg="|您输入的认证码和系统产生的不一致，请重新输入!"
				login_r=0
				checkcode_r=0
				Exit Sub
			End If
		End If
		
		'isCheckCode = Dream3User.IsCheckCode(loginip)
		
		
		'判断是否已经存在记录
		Sql = "select id from T_User Where username='"&username&"' or email='"&username&"'or mobile='"&username&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If  Rs.EOF Then
			login_msg = "用户名不存在！"
			login_r=0
			loginTimes=loginTimes+1
			checkcode_r=loginTimes
			Response.Cookies("loginTimes") = loginTimes
			Response.Cookies("loginTimes").Expires = Date + 1
			Rs.Close
			Exit Sub
		End If
		
		Rs.Close
		
		Sql = "select * from T_User Where (username='"&username&"' or email='"&username&"' or mobile='"&username&"') and password='"&md5(password)&"'"
		
		
		Rs.open Sql,conn,1,2
		
		If  Rs.EOF Then
			login_msg = "用户名密码不匹配！"
			login_r=0
			loginTimes=loginTimes+1
			checkcode_r=loginTimes
			Response.Cookies("loginTimes") = loginTimes
			Response.Cookies("loginTimes").Expires = Date + 1
			Rs.Close
			Exit Sub
		End If
		
		If  Rs("enabled")="N" Then
			login_msg = "您的账号未通过验证或者被锁定，暂时无法登录！"
			login_r=0
			loginTimes=loginTimes+1
			checkcode_r=loginTimes
			Response.Cookies("loginTimes") = loginTimes
			Response.Cookies("loginTimes").Expires = Date + 1
			Rs.Close
			Exit Sub
		End If
		
		'Update Ip and Last_time
		Rs("ip") = loginip
		Rs("last_time") = Now
		Rs.Update
		
		login_r=1
		loginTimes=0
		
		'读取订单信息，并显示在首页
		If Dream3Product.IsUserOrder(Rs("id"))  Then
		Response.Cookies(DREAM3C)("_UserOrderFlag") = "Y"
		Else
			Response.Cookies(DREAM3C)("_UserOrderFlag") = "N"
		End If
		
		Session("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Session("_UserID") = Rs("id")
		Session("_IsManager") = Rs("manager")
		Session("_UserFace") = Rs("face")
       
        Response.Cookies("loginTimes").Expires = Date + 1 
        Response.Cookies("loginTimes") = loginTimes
       
		'默认保存一个月
		Response.Cookies(DREAM3C).Expires = Date + 30
		Response.Cookies(DREAM3C)("_UserID") = Rs("id")
		Response.Cookies(DREAM3C)("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Response.Cookies(DREAM3C)("_Password") =  Rs("password")
		Response.Cookies(DREAM3C)("_IsManager") =  Rs("manager")
		Response.Cookies(DREAM3C)("_UserCityCode") =  Rs("city_code")
		
		Rs.Close
		Set Rs = Nothing
		
	End Sub
	
	Sub reponseLoginResult()
		response.Write("{""login_r"":"""+Cstr(login_r)+""",""login_msg"":"""+Cstr(login_msg)+""",""checkcode_r"":"""+Cstr(checkcode_r)+"""}")
	End Sub

%>