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
			login_msg = "�������û��������룡"
			login_r=0
			Exit Sub
		End If
		
		'��¼��¼����
		'Dream3User.LogIPLoginTimes(loginip)
		
		If isCheckCode Then
			If Not Dream3User.CodeIsTrue Then
				login_msg="|���������֤���ϵͳ�����Ĳ�һ�£�����������!"
				login_r=0
				checkcode_r=0
				Exit Sub
			End If
		End If
		
		'isCheckCode = Dream3User.IsCheckCode(loginip)
		
		
		'�ж��Ƿ��Ѿ����ڼ�¼
		Sql = "select id from T_User Where username='"&username&"' or email='"&username&"'or mobile='"&username&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If  Rs.EOF Then
			login_msg = "�û��������ڣ�"
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
			login_msg = "�û������벻ƥ�䣡"
			login_r=0
			loginTimes=loginTimes+1
			checkcode_r=loginTimes
			Response.Cookies("loginTimes") = loginTimes
			Response.Cookies("loginTimes").Expires = Date + 1
			Rs.Close
			Exit Sub
		End If
		
		If  Rs("enabled")="N" Then
			login_msg = "�����˺�δͨ����֤���߱���������ʱ�޷���¼��"
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
       
        Response.Cookies("loginTimes").Expires = Date + 1 
        Response.Cookies("loginTimes") = loginTimes
       
		'Ĭ�ϱ���һ����
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