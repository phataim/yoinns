<%
Const IsSqlDataBase=1	'定义数据库类别，0为Access数据库，1为SQL数据库
Const DREAM3C="Dream3CacheV3.3.0"'系统缓存名称.在一个URL下安装多个DREAM3C请设置不同名称
DREAM3SLSTuanBuild="Beta3.3"

Dim VirtualPath   '虚拟目录，根据程序判断并赋值
Dim Conn

'VirtualPath = ""
Call   SetVirtualPath()


Sub InitConn()
	If IsSqlDataBase=0 Then
	'''''''''''''''''''''''''''''' Access数据库设置 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		'VirtualPath =""'系统安装目录,如在虚拟目录下安装.请填写 /虚拟目录名称
		SqlDataBase	= "data/#duanzu2012.mdb"	'数据库路径
		SqlProvider	= "Microsoft.Jet.OLEDB.4.0"	'驱动程序[ Microsoft.Jet.OLEDB.4.0  Microsoft.ACE.OLEDB.12.0 ]
		Connstr="Provider="&SqlProvider&";Data Source="&Server.MapPath(VirtualPath&"/"&SqlDataBase)
		SqlNowString="Now()"
		SqlChar="'"
		IsSqlVer="ACCESS"
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Else
	'''''''''''''''''''''''''''''' SQL数据库设置 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		SqlLocalName	="127.0.0.1"	'连接IP  [ 本地用 (local) 外地用IP ]
		SqlUserName	="sa"		'SQL用户名
		SqlPassword	="WanG250qi5315205"		'SQL用户密码
		SqlDataBase	="youlvguan"	'数据库名
		SqlProvider	="SQLOLEDB"	'驱动程序 [ SQLOLEDB  SQLNCLI ]
		ConnStr="Provider="&SqlProvider&"; User ID="&SqlUserName&"; Password="&SqlPassword&"; Initial CataLog="&SqlDataBase&"; Data Source="&SqlLocalName&";"
		SqlNowString="GetDate()"
		IsSqlVer="MSSQL"
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	END IF
	
	'On Error Resume Next
	Set Conn=Server.CreateObject("ADODB.Connection")
	Conn.open ConnStr
	If Err Then
		Response.Write ""&IsSqlVer&"数据库连接出错，请检查连接字串。<br><br>"&Err.Source&" ("&Err.Number&")"
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