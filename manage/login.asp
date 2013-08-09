<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_main.asp"-->
<!--#include file="../common/api/cls_user.asp"-->
<!--#include file="../common/api/MD5.asp"-->
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
			gMsgArr = "请输入登录名！"
		End If
		
		If password ="" Then
			gMsgArr = gMsgArr&"|请输入密码！"
		End If
		
		'记录登录次数
		Dream3User.LogIPLoginTimes(loginip)
		
		'判断IP是否允许
		If Dream3CLS.SiteConfig("IPLimit") = "1" Then
			If Not Dream3User.IsIPAllowed(Dream3CLS.SiteConfig("AllowIPs"),loginip) Then
				gMsgArr = gMsgArr&"|您的IP被限定，无法访问！"
			End If
		End If
		
		'记录登录次数
		Dream3User.LogIPLoginTimes(loginip)
		
		If isCheckCode Then
			If Not Dream3User.CodeIsTrue Then
				gMsgArr = gMsgArr&"|您输入的认证码和系统产生的不一致，请重新输入!"
			End If
		End If
		
		isCheckCode = Dream3User.IsCheckCode(loginip)
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		
		'判断是否已经存在记录
		Sql = "select id from T_User Where username='"&username&"' or email='"&username&"' or mobile='"&username&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If  Rs.EOF Then
			gMsgArr = "用户名不存在！"
			username = ""
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		Rs.Close
		
		Sql = "select * from T_User Where (username='"&username&"' or email='"&username&"' or mobile='"&username&"') and password='"&md5(password)&"'"
		
		Rs.open Sql,conn,1,2
		
		If  Rs.EOF Then
			gMsgArr = "用户名密码不匹配！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If  Rs("enabled")="N" Then
			gMsgArr = "您的账号未通过验证或者被锁定，暂时无法登录！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		Rs.Close
		
		Sql = "select * from T_User Where (username='"&username&"' or email='"&username&"' or mobile='"&username&"') and password='"&md5(password)&"' and manager='Y'"
		
		Rs.open Sql,conn,1,2
		
		If  Rs.EOF Then
			gMsgArr = "你不是管理员！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If  Rs("enabled")="N" Then
			gMsgArr = "您的账号未通过验证或者被锁定，暂时无法登录！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		
		Session("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Session("_UserID") = Rs("id")
		Session("_IsManager") = Rs("manager")
		Session("_IsManagerLogin") = "Y"
		'默认保存一天
		Response.Cookies(DREAM3C).Expires = Date + 1
		Response.Cookies(DREAM3C)("_UserID") = Rs("id")
		Response.Cookies(DREAM3C)("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Response.Cookies(DREAM3C)("_Password") =  Rs("password")
		Response.Cookies(DREAM3C)("_IsManager") =  Rs("manager")
		Response.Cookies(DREAM3C)("_IsManagerLogin") =  "Y"
		
		
		'Update Ip and Last_time
		Rs("ip") = loginip
		Rs("last_time") = Now
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		response.Redirect("main/index.asp")
		
	End Sub

	
	Sub Main()	
		If Session("_IsManagerLogin") = "Y" Then
			Response.Redirect(VirtualPath&"/manage/system/index.asp")
		End If
		autologin = "1"
	End Sub
%>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="<%=VirtualPath%>/common/static/style/admin.css" rel="stylesheet" type="text/css" />
<title>后台管理</title>
<link href="admin/admin.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=gb2312"></head>
<script type="text/javascript" language="javascript" >
var show_checkcode = false;
function get_checkcode() {
	var chkCodeFile = "<%=VirtualPath%>/common/inc/getcode.asp";
	if(!show_checkcode){
		if(document.getElementById("img_checkcode"))
			document.getElementById("img_checkcode").innerHTML = '<img  id="checkcodeimg" src="'+chkCodeFile+'?t='+Math.random()+'" alt="点击刷新验证码" style="cursor:pointer;border:0;vertical-align:middle;height:18px;" onclick="this.src=\''+chkCodeFile+'?t=\'+Math.random()" />'
			show_checkcode = true;

		if(document.getElementById("isok_checkcode"))
			document.getElementById("isok_checkcode").innerHTML = '<a href="javascript://" onclick="setTimeout(function(){ document.getElementById(\'checkcodeimg\').src=\''+chkCodeFile+'?t=\'+Math.random()},100);">看不清<\/a>';
	}
}
</script>

<%
Dim remoteMsgArr,remoteMsgFlag
remoteMsgArr = Request("gMessage")
remoteMsgFlag = Request("gMessageFlag")
If remoteMsgArr <> "" Then
	gMsgArr = remoteMsgArr
	gMsgFlag = remoteMsgFlag
End If

Call showMsg(gMsgArr,0)
%>


<div class="leftform">
    <div class="conLeftForm">

    </div>
</div>

<div class="rightform">
    <div class="conRightForm">
		<form id="loginForm" method="post" action="login.asp?act=login" class="validator">
        <div class="dataForm">
            <ul>
                <li class="dataTitle">有旅馆管理员登录</li>
                <li>
                    
                </li>
                <li class="inputstyle"><span>用户名：</span>
				<input type="text"  name="username" id="username" class="input_bg2" value="<%=username%>"/>
                <li class="inputstyle"><span>密码：</span>
				<input type="password"  name="password" id="password" class="input_bg2" />
				</li>
				<%If isCheckCode Then%>
						
						
                <li class="inputstyle"><span>验证码：</span>

                   <input name="checkcode" type="text" class="input_bg3" id="checkcode" size="5" maxlength="4" onFocus="get_checkcode();this.onfocus=null;" onKeyUp="ajaxcheckcode('check_code','checkcode');" />
  <span id="img_checkcode" style="cursor:pointer;" onClick="get_checkcode();">点击获取验证码</span>
						
                </li>
				<%End If%>
               <li class="inputstyle"><span>&nbsp;</span><input type="submit" id="searchBt" value="" class="gobtn"></li>
            </ul>
        </div>
		</form>
    </div>
</div>

<div class="bottomclass">
	<p>Copyright&copy;2012  All Rights Reserved <a href="http://yoinns.com" target="_blank">yoinns.com</a> 梦谷网络 版权所有</p>
</div>

