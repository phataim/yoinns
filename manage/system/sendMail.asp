<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount

	Action = Request.QueryString("act")
	Select Case Action
		   Case "Save"
		   		Call saveCity()
		   Case Else
				Call Main()
	End Select
	
	Sub SaveCity()
		
		Dream3CLS.showMsg "����ɹ�","S","mail.asp"
		
	End Sub
	

	
	Sub Main()		
		Dim Errors,MailBodyStr
		Dim MailAddress,LoginName,LoginPass,Subject,Sender,Fromer,Email
		MailAddress = "127.0.0.1"
	    MailBodyStr="��ӭ��ע���Ϊ��վ��Ա��" 
		LoginName = "admin"
		LoginPass = "123456"
		Subject = "�ʼ�����"
		Sender = "����"
		Fromer = "unclekang@qq.com"
		Email =  "admin@dream3.cn"
		Errors = Dream3CLS.SendMail( Subject, MailBodyStr, MailAddress, Email, LoginName, LoginPass,  Sender,  Fromer)
	  
		IF Errors="OK" Then
			 Errors="ע��ɹ���ע����֤���ѷ��͵��������� ֻ�м��������ʽ��Ϊ��վ��Ա!"
	    Else
			
	    End if
		response.Write(Errors)
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
