<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<%
Dim Action
Dim Rs,Sql
Dim code 
Dim isValid

	Action = Request.QueryString("act")
	Select Case Action
		Case Else
				Call Main()
	End Select

	
	Sub Main()	
	
		code = Dream3CLS.RSQL("code")
		Sql = "Select * From T_Subscribe Where secret ='"&code&"'"
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			isValid = "N"
		Else
			enabled = Rs("enabled")
			If enabled = "Y" Then
				isValid = "E"
			Else
				isValid = "Y"
				Rs("enabled") = "Y"
				Rs.Update
				Rs.Close
				Set Rs = Nothing
			End If
		End If
		
	End Sub
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
	<%
		If isValid="Y" Then
	%>
		��֤�ɹ�
	<%
		Elseif  isValid="E" Then
	%>
		�Ѿ���֤�����벻���ظ��ύ
	<%
		Else
	%>
		��֤ʧ��
	<%
		End If
	%>
<!--#include file="common/inc/footer_user.asp"-->