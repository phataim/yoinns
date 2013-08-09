<%@ CodePage=936 Language="VBScript"%>
<!--#include file="init.asp"-->
<!--#include file="const.asp"-->

<%
Session.timeout=600
Response.Charset="gb2312"
'Response.Buffer=True
'全局城市ID
Dim G_City_ID
Dim G_City_NAME
Dim G_Show_Classify
Dim G_MENU_TYPE  '页面类型

sms_open=0 '默认是打开发短信, 0:发送 1:不发送

Call InitConn()


'On Error GoTo 0
set AutoTerminate=new AutoTerminate_Class
Set Rs = Server.CreateObject("ADODB.Recordset")

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''




'显示消息，flag=S success,falg=E error
' Msg
Dim gMsgArr,gMsgFlag
Sub showMsg(msgArr,flag)
	If gMsgFlag = "S" Then
		If gMsgArr = "" Then
			gMsgArr = "保存成功！"
		End If
		response.Write("<div id='sysmsg-success' class='sysmsgw'>")
		response.Write("<div class='sysmsg'><p>"&gMsgArr&"</p><span class='close' onclick=""document.getElementById('sysmsg-success').style.display='none';"">关闭</span></div>")
		response.Write("</div>")
	Else If gMsgFlag = "E" Then
		response.Write("<div id='sysmsg-error' class='sysmsgw'>")
		response.Write("<div class='sysmsg'>")
		gMsgArray = split(gMsgArr,"|")
		For i = 0 to UBound(gMsgArray)
			If gMsgArray(i) <> "" Then
				response.Write("<p>"&gMsgArray(i)&"</p>")
			End If
		Next
		response.Write("<span class='close' onclick=""document.getElementById('sysmsg-error').style.display='none';"">关闭</span>")
		response.Write("</div>")
		response.Write("</div>")
	End If
	End If
	
End Sub
''''''''''''''''''''''''''''''''''''
Class AutoTerminate_Class
	Private Sub Class_Terminate
		If Err.Number<>995 and Err.Number<>0 then log(""&Err.Source&" ("&Err.Number&")&lt;br&gt;"&Err.Description&"")
		Conn.Close
		set Rs = Nothing
		set Rs1 = Nothing
		set Conn = Nothing
		Set XMLDOM = Nothing
		Set SiteConfigXMLDOM = Nothing
	End Sub
End Class
''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''
Function CleanCookies()

	For Each Cookie in Request.Cookies
		if Not(Request.Cookies(Cookie).HasKeys) then
			Response.Cookies(Cookie) = Empty
		else
			For Each Subkey in Request.Cookies(Cookie)
			Response.Cookies(Cookie)(Subkey) = Empty
			Next
		end if
	Next 

End Function


'''''''''''''''''''''''''''''''''''''''''''
DomainPath=Left(Request.ServerVariables("script_name"),inStrRev(Request.ServerVariables("script_name"),"/"))

GSiteURL="http://"&Request.ServerVariables("server_name")&DomainPath

ReturnUrl=Request.ServerVariables("http_referer")


Call GetCityName()

Sub GetCityName()
	G_City_ID = Request.Cookies(DREAM3C)("_UserCityID")
	'response.Write(">>>>>>>"+G_City_ID)
	'response.End()
	Set hCityRs = Server.CreateObject("adodb.recordset")

	If G_City_ID = ""  Or Not IsNumeric(G_City_ID) Or Cstr(G_City_ID)="0" Then
		
		G_City_ID = 140111
		G_City_NAME = ""
		Exit Sub
		Exit Sub
	Else
		Sql = "Select cityname,citypostcode from T_City Where  citypostcode='"&G_City_ID&"'"

		If hCityRs.state=1 Then hCityRs.Close
		hCityRs.open Sql,conn,1,1
		G_City_ID = hCityRs("citypostcode")
		G_CITY_NAME = hCityRs("cityname")

		hCityRs.Close
		Set hCityRs = Nothing
	End If

End Sub


Sub ReLogin()
	t_user_id = Request.Cookies(DREAM3C)("_UserID")
	t_password = Request.Cookies(DREAM3C)("_Password")
	
	t_Sql = "select * from T_User Where id="&t_user_id&" and password='"&t_password&"'"
	Set tRs = Server.CreateObject("adodb.recordset")			
	tRs.open t_sql,conn,1,2
	
	If  tRs.EOF Then
		Exit Sub
	End If
	
	
	If Not IsNull(tRs("username")) Or Trim(tRs("username")) = "" Then
		s_username = tRs("username")
	Else
		s_username = tRs("mobile")
	End If
		
	Session("_UserName") = s_username
	Session("_UserID") = tRs("id")
	Session("_IsManager") = tRs("manager")
	'默认保存一个月
	Response.Cookies(DREAM3C).Expires = Date + 30
	Response.Cookies(DREAM3C)("_UserID") = tRs("id")
	Response.Cookies(DREAM3C)("_UserName") = s_username
	Response.Cookies(DREAM3C)("_IsManager") =  tRs("manager")
	Response.Cookies(DREAM3C)("_UserCityCode") =  tRs("city_code")
End Sub

'利用xmlhttp读取网页代码
Function GetURL(URL)
Set http=Server.CreateObject("Microsoft.XMLHTTP") 
     On Error Resume Next
     http.Open "post",URL,False 
     http.send()
     if Err then
     Err.Clear
     GetURL = "NOTFOUND"
     exit function
     End if
     getHTTPPage=bytesToBSTR(Http.responseBody,"gb2312")
set http=nothing 
GetURL=getHTTPPage
End Function
'转换编码
Function BytesToBstr(body,Cset) 
dim objstream 
set objstream = Server.CreateObject("adodb.stream") 
objstream.Type = 1 
objstream.Mode =3 
objstream.Open 
objstream.Write body 
objstream.Position = 0 
objstream.Type = 2 
objstream.Charset = Cset 
BytesToBstr = objstream.ReadText 
objstream.Close 
set objstream = nothing 
End Function


Function IsVerifyVirtualPath(f_virtualpath)
	If LCase(Request.ServerVariables("HTTPS")) = "off" Then 
	 strTemp = "http://"
	Else 
	 strTemp = "https://"
	End If 
	strTemp = strTemp & Request.ServerVariables("SERVER_NAME") 
	If Request.ServerVariables("SERVER_PORT") <> 80 Then 
	 strTemp = strTemp & ":" & Request.ServerVariables("SERVER_PORT") 
	End if
	
	If(f_virtualpath = "") Then
		f_virtualurl = strTemp&"/virtualPathVerify.asp"
	Else
		f_virtualurl = strTemp&"/"&f_virtualpath&"/virtualPathVerify.asp"
	End if
	
	content = GetURL(f_virtualurl)
	if instr(content,"dream3verifycode") Then
		IsVerifyVirtualPath = true
	Else
		IsVerifyVirtualPath = false
	End if
End Function

Function GetSiteUrl()
	If LCase(Request.ServerVariables("HTTPS")) = "off" Then 
	 strTemp = "http://"
	Else 
	 strTemp = "https://"
	End If 
	strTemp = strTemp & Request.ServerVariables("SERVER_NAME") 
	If Request.ServerVariables("SERVER_PORT") <> 80 Then 
	 strTemp = strTemp & ":" & Request.ServerVariables("SERVER_PORT") 
	End if
	GetSiteUrl = strTemp&VirtualPath
	
End Function

Function GetStylePath()
	
	GetStylePath = VirtualPath &"/common/themes/" & Dream3CLS.SiteConfig("DefaultSiteStyle")
	
End Function

'调试信息
Sub t(msg)
	response.Write("<br>print="&msg&"|")
	response.End()
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike


dim comm
dim ps
user_mdb="db.mdb" '数据库

Function js_jump(str1,url) '错误提示 str1: 显示数据内容 url:空就返回原来的页面,有值就值跳转
	if url="" then
		Response.Write "<script language=JavaScript>" & chr(13) & "alert('"&str1&"');" & "history.back(1)" & "</script>" 
	else
		Response.Write "<script language=JavaScript>" & chr(13) & "alert('"&str1&"');" & "location.href='"&url&"';" & "</script>" 
	end if
	response.end
End Function


Function IsNum_pro(str) '能检测包括空的数字类型
	if str="" then
		IsNum_pro=false
	else
		IsNum_pro=IsNumeric(str)
	end if
End Function


Function no_long(aa) '防止重复添加信息

	'############   防止重复留言
	session("time")=now()
	const atime=#0:0:05# '定义相隔之间的秒数
	if session("time2") >0 then
		if session("time2")+atime > session("time") then
			session("time2")=now()
			if aa=1 then
				call js_jump("╮(╯_╰)╭ 发信息不要这么快哦～","")
			else
				response.Write "4"
			end if
			response.end
		end if 
	end if
	session("time2")=now()
	'############
End Function


Function mdb_name(m_n) '连接数据库
	set comm=Server.CreateObject("ADODB.Connection")
	comm.open "Provider=Microsoft.JET.OLEDB.4.0;Data Source= "&server.MapPath (m_n)
	Set ps= Server.CreateObject("ADODB.Recordset")
End Function

function ConvertHTML(str) '过滤字符串
	if str<>"" then
		ConvertHTML=trim(str)
		'ConvertHTML=replace(str, "&", "&#38")
		'ConvertHTML=replace(ConvertHTML, ";", "&#59")
		ConvertHTML=replace(ConvertHTML, "(", "（")
		ConvertHTML=replace(ConvertHTML, ")", "）")
		ConvertHTML=replace(ConvertHTML, "<", "＜")
		ConvertHTML=replace(ConvertHTML, ">", "＞")
		ConvertHTML=replace(ConvertHTML,chr(34), "＂")
		ConvertHTML=replace(ConvertHTML,chr(34),"&quot;")
		ConvertHTML=replace(ConvertHTML,chr(39), "&#39")
		ConvertHTML=replace(convertHTML,vbCrLf, "<br />")
'要增加过滤%号
		'ConvertHTML=replace(convertHTML," ", "&nbsp;")
		if len(ConvertHTML)< 30 then
			ConvertHTML=replace(ConvertHTML, "	", "______")
		else
			ConvertHTML=replace(ConvertHTML, "	", "&nbsp;&nbsp;")
		end if
		'ConvertHTML=replace(ConvertHTML, "&", "&amp;")
		'ConvertHTML=replace(str, vbCrLf, "<br>")
	'else
	'	ConvertHTML="??"
	end if
end function



Function Rnd_no(n) '随机数 , n 为多少位
	Randomize '初始化随机数
	for i=1 to n
		mn = Int((9 * Rnd) + 1)' 产生 1 到 6 之间的随机数。
		tt=mn&tt
	next
	Rnd_no=tt
end function

	'sms_save(电话,验证码1,验证码2,验证码3,类型id,类型名称,是否需要收用户回短信) '保存
	'call sms_save(owner_mobile,r_no1,r_no2,"",order_id,"T_Order",1) '商家保存


Function sms_save(t_no,r_no1,r_no2,r_no3,sort_id,sort_name,mt,is_back,cn) '保存发送过的短信
  ' 格式 sms_save(电话,验证码1,验证码2,验证码3,类型id,类型名称,短信服务器回执,是否需要收用户回短信) '保存
  

	if cn=0 then
		mapurl="user\sms\"&user_mdb '在根目录
	elseif cn=1  then
		mapurl="..\user\sms\"&user_mdb '在根目录任一文件夹里, 除user外
	elseif cn=2 then
		mapurl="sms\"&user_mdb '在user文件夹里
	elseif cn=3  then
		mapurl="..\sms\"&user_mdb '在user目录任一文件夹里, 除sms外
	elseif cn=4 then
		mapurl=user_mdb '在sms文件夹里
	end if

	call mdb_name(mapurl) '打开SMS数据库
	
	sql="select * from sms"
	ps.open sql,comm,1,3
	ps.addnew
		ps("t_no")=t_no '手机号
		ps("r_no1")=r_no1 '验证码1
		ps("r_no2")=r_no2 '验证码2
		ps("r_no3")=r_no3 '验证码3
		ps("sort_id")=sort_id '类型ID
		ps("sort_name")=sort_name '类型名称
		ps("mt")=at '短信服务器返回值
		ps("is_back")=is_back '是否需要短信回复
	ps.update
	ps.close	
	set ps=nothing
	comm.close
	set comm=nothing 
	
end function




%>
