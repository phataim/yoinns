<%@ CodePage=936 Language="VBScript"%>
<!--#include file="init.asp"-->
<!--#include file="const.asp"-->

<%
Session.timeout=600
Response.Charset="gb2312"
'Response.Buffer=True
'ȫ�ֳ���ID
Dim G_City_ID
Dim G_City_NAME
Dim G_Show_Classify
Dim G_MENU_TYPE  'ҳ������

sms_open=0 'Ĭ���Ǵ򿪷�����, 0:���� 1:������

Call InitConn()


'On Error GoTo 0
set AutoTerminate=new AutoTerminate_Class
Set Rs = Server.CreateObject("ADODB.Recordset")

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''




'��ʾ��Ϣ��flag=S success,falg=E error
' Msg
Dim gMsgArr,gMsgFlag
Sub showMsg(msgArr,flag)
	If gMsgFlag = "S" Then
		If gMsgArr = "" Then
			gMsgArr = "����ɹ���"
		End If
		response.Write("<div id='sysmsg-success' class='sysmsgw'>")
		response.Write("<div class='sysmsg'><p>"&gMsgArr&"</p><span class='close' onclick=""document.getElementById('sysmsg-success').style.display='none';"">�ر�</span></div>")
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
		response.Write("<span class='close' onclick=""document.getElementById('sysmsg-error').style.display='none';"">�ر�</span>")
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
	'Ĭ�ϱ���һ����
	Response.Cookies(DREAM3C).Expires = Date + 30
	Response.Cookies(DREAM3C)("_UserID") = tRs("id")
	Response.Cookies(DREAM3C)("_UserName") = s_username
	Response.Cookies(DREAM3C)("_IsManager") =  tRs("manager")
	Response.Cookies(DREAM3C)("_UserCityCode") =  tRs("city_code")
End Sub

'����xmlhttp��ȡ��ҳ����
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
'ת������
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

'������Ϣ
Sub t(msg)
	response.Write("<br>print="&msg&"|")
	response.End()
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike


dim comm
dim ps
user_mdb="db.mdb" '���ݿ�

Function js_jump(str1,url) '������ʾ str1: ��ʾ�������� url:�վͷ���ԭ����ҳ��,��ֵ��ֵ��ת
	if url="" then
		Response.Write "<script language=JavaScript>" & chr(13) & "alert('"&str1&"');" & "history.back(1)" & "</script>" 
	else
		Response.Write "<script language=JavaScript>" & chr(13) & "alert('"&str1&"');" & "location.href='"&url&"';" & "</script>" 
	end if
	response.end
End Function


Function IsNum_pro(str) '�ܼ������յ���������
	if str="" then
		IsNum_pro=false
	else
		IsNum_pro=IsNumeric(str)
	end if
End Function


Function no_long(aa) '��ֹ�ظ������Ϣ

	'############   ��ֹ�ظ�����
	session("time")=now()
	const atime=#0:0:05# '�������֮�������
	if session("time2") >0 then
		if session("time2")+atime > session("time") then
			session("time2")=now()
			if aa=1 then
				call js_jump("�r(�s_�t)�q ����Ϣ��Ҫ��ô��Ŷ��","")
			else
				response.Write "4"
			end if
			response.end
		end if 
	end if
	session("time2")=now()
	'############
End Function


Function mdb_name(m_n) '�������ݿ�
	set comm=Server.CreateObject("ADODB.Connection")
	comm.open "Provider=Microsoft.JET.OLEDB.4.0;Data Source= "&server.MapPath (m_n)
	Set ps= Server.CreateObject("ADODB.Recordset")
End Function

function ConvertHTML(str) '�����ַ���
	if str<>"" then
		ConvertHTML=trim(str)
		'ConvertHTML=replace(str, "&", "&#38")
		'ConvertHTML=replace(ConvertHTML, ";", "&#59")
		ConvertHTML=replace(ConvertHTML, "(", "��")
		ConvertHTML=replace(ConvertHTML, ")", "��")
		ConvertHTML=replace(ConvertHTML, "<", "��")
		ConvertHTML=replace(ConvertHTML, ">", "��")
		ConvertHTML=replace(ConvertHTML,chr(34), "��")
		ConvertHTML=replace(ConvertHTML,chr(34),"&quot;")
		ConvertHTML=replace(ConvertHTML,chr(39), "&#39")
		ConvertHTML=replace(convertHTML,vbCrLf, "<br />")
'Ҫ���ӹ���%��
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



Function Rnd_no(n) '����� , n Ϊ����λ
	Randomize '��ʼ�������
	for i=1 to n
		mn = Int((9 * Rnd) + 1)' ���� 1 �� 6 ֮����������
		tt=mn&tt
	next
	Rnd_no=tt
end function

	'sms_save(�绰,��֤��1,��֤��2,��֤��3,����id,��������,�Ƿ���Ҫ���û��ض���) '����
	'call sms_save(owner_mobile,r_no1,r_no2,"",order_id,"T_Order",1) '�̼ұ���


Function sms_save(t_no,r_no1,r_no2,r_no3,sort_id,sort_name,mt,is_back,cn) '���淢�͹��Ķ���
  ' ��ʽ sms_save(�绰,��֤��1,��֤��2,��֤��3,����id,��������,���ŷ�������ִ,�Ƿ���Ҫ���û��ض���) '����
  

	if cn=0 then
		mapurl="user\sms\"&user_mdb '�ڸ�Ŀ¼
	elseif cn=1  then
		mapurl="..\user\sms\"&user_mdb '�ڸ�Ŀ¼��һ�ļ�����, ��user��
	elseif cn=2 then
		mapurl="sms\"&user_mdb '��user�ļ�����
	elseif cn=3  then
		mapurl="..\sms\"&user_mdb '��userĿ¼��һ�ļ�����, ��sms��
	elseif cn=4 then
		mapurl=user_mdb '��sms�ļ�����
	end if

	call mdb_name(mapurl) '��SMS���ݿ�
	
	sql="select * from sms"
	ps.open sql,comm,1,3
	ps.addnew
		ps("t_no")=t_no '�ֻ���
		ps("r_no1")=r_no1 '��֤��1
		ps("r_no2")=r_no2 '��֤��2
		ps("r_no3")=r_no3 '��֤��3
		ps("sort_id")=sort_id '����ID
		ps("sort_name")=sort_name '��������
		ps("mt")=at '���ŷ���������ֵ
		ps("is_back")=is_back '�Ƿ���Ҫ���Żظ�
	ps.update
	ps.close	
	set ps=nothing
	comm.close
	set comm=nothing 
	
end function




%>
