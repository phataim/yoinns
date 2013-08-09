<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
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
		
		Dream3CLS.showMsg "±£´æ³É¹¦","S","mail.asp"
		
	End Sub
	

	
	Sub Main()		

		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl&"?author=tempuser"
		
		intPageNow = request.QueryString("page")

		intPageSize = 5
		
		
		sql = "select cityId,creationTime,creator from T_Bulletin "
		sqlCount = "SELECT Count([content]) FROM [T_Bulletin]"
	
			
			Set clsRecordInfo = New Cls_PageView
				clsRecordInfo.intRecordCount = 2816
				clsRecordInfo.strSqlCount = sqlCount
				clsRecordInfo.strSql = sql
				clsRecordInfo.intPageSize = intPageSize
				clsRecordInfo.intPageNow = intPageNow
				clsRecordInfo.strPageUrl = strLocalUrl
				clsRecordInfo.strPageVar = "page"
			clsRecordInfo.objConn = Conn		
			arrU = clsRecordInfo.arrRecordInfo
			strPageInfo = clsRecordInfo.strPageInfo
			'response.Write(">><br>"&strPageInfo&"<br>")
			Set clsRecordInfo = nothing
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<table width="100%" border="1">
 <%
	Dim bgColor
	If IsArray(arrU) Then
		For i = 0 to UBound(arrU, 2)

 	%>
  <tr>
    <td><%=arrU(0,i)%></td>
    <td><%=arrU(1,i)%></td>
    <td><%=arrU(2,i)%></td>
    <td>&nbsp;</td>
  </tr>
  <%
  	Next
  End If
  %>
  <tr>
    <td colspan="4"><%= strPageInfo%></td>
    
  </tr>
</table>

<!--#include file="../../common/inc/footer_manage.asp"-->