<%
Const IsSqlDataBase=1	'�������ݿ����0ΪAccess���ݿ⣬1ΪSQL���ݿ�
Const DREAM3C="Dream3CacheV3.3.0"'ϵͳ��������.��һ��URL�°�װ���DREAM3C�����ò�ͬ����
DREAM3SLSTuanBuild="Beta3.3"

Dim VirtualPath   '����Ŀ¼�����ݳ����жϲ���ֵ
Dim Conn

'VirtualPath = ""
Call   SetVirtualPath()


Sub InitConn()
	If IsSqlDataBase=0 Then
	'''''''''''''''''''''''''''''' Access���ݿ����� '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		'VirtualPath =""'ϵͳ��װĿ¼,��������Ŀ¼�°�װ.����д /����Ŀ¼����
		SqlDataBase	= "data/#duanzu2012.mdb"	'���ݿ�·��
		SqlProvider	= "Microsoft.Jet.OLEDB.4.0"	'��������[ Microsoft.Jet.OLEDB.4.0  Microsoft.ACE.OLEDB.12.0 ]
		Connstr="Provider="&SqlProvider&";Data Source="&Server.MapPath(VirtualPath&"/"&SqlDataBase)
		SqlNowString="Now()"
		SqlChar="'"
		IsSqlVer="ACCESS"
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Else
	'''''''''''''''''''''''''''''' SQL���ݿ����� ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		SqlLocalName	="127.0.0.1"	'����IP  [ ������ (local) �����IP ]
		SqlUserName	="sa"		'SQL�û���
		SqlPassword	="WanG250qi5315205"		'SQL�û�����
		SqlDataBase	="youlvguan"	'���ݿ���
		SqlProvider	="SQLOLEDB"	'�������� [ SQLOLEDB  SQLNCLI ]
		ConnStr="Provider="&SqlProvider&"; User ID="&SqlUserName&"; Password="&SqlPassword&"; Initial CataLog="&SqlDataBase&"; Data Source="&SqlLocalName&";"
		SqlNowString="GetDate()"
		IsSqlVer="MSSQL"
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	END IF
	
	'On Error Resume Next
	Set Conn=Server.CreateObject("ADODB.Connection")
	Conn.open ConnStr
	If Err Then
		Response.Write ""&IsSqlVer&"���ݿ����ӳ������������ִ���<br><br>"&Err.Source&" ("&Err.Number&")"
		Set Conn = Nothing
		err.Clear
		Response.End
	End If
	
End Sub

Sub SetVirtualPath()
	On Error Resume Next 
	If Application(DREAM3C&"_"&"G_IsVirtualPathSet") = "Y" Then
		VirtualPath = Application(DREAM3C&"_"&"G_VirtualPath") 
		Exit Sub
	End If
	s_rqeusturl = Request.ServerVariables("URL") 
	s_curPageArr = split(s_rqeusturl,"/")
	s_arrCount = UBOUND(s_curPageArr)
	
	If IsArray(s_curPageArr) Then
		If IsVerifyVirtualPath("") Then
			VirtualPath = ""
			Application(DREAM3C&"_"&"G_IsVirtualPathSet") = "Y"
			Application(DREAM3C&"_"&"G_VirtualPath") = VirtualPath
			Exit Sub
		End If
		For i = 0 to UBound(s_curPageArr)
			If IsVerifyVirtualPath(s_curPageArr(i)) Then
				VirtualPath = "/"&s_curPageArr(i)
				Application(DREAM3C&"_"&"G_IsVirtualPathSet") = "Y"
				Application(DREAM3C&"_"&"G_VirtualPath") = VirtualPath
				Exit Sub
			End If
		Next
	End If

End Sub
%>