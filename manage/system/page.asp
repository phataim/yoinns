<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->

<%
Dim Action,pageRs,Sql
Dim tempPageId, pageId, tempPageDesc, content,title

	Action = Request.QueryString("act")
	Select Case Action
		   Case "changePage"
		   		Call ChangePage()
		   Case "savePage"
		   		Call SavePage()
		   Case Else
				Call Main()
	End Select
	
	Sub ChangePage()
		Call Main()
	End Sub
	
	
	Sub SavePage()

		pageId = Request.Form("pageId")
		content = Request.Form("pageContent")

	
						
		If Len(content) > 10000 then
			gMsgArr = "内容不能超过10000"
			gMsgFlag = "E"
			Exit Sub
		End If
		
		Set Rs = Server.CreateObject("adodb.recordset")
		Sql = "select * from T_Page Where ID='"&pageId&"'"
		Rs.Open Sql, Conn, 1, 3
		Rs("content") 	= content
		Rs.Update
		Rs.Close
		Set Rs = Nothing

		If err.Number = 0 then
			gMsgFlag = "S"
			Call Main()
		Else

		End if
		
	End Sub

	
	Sub Main()
		pageId = Dream3CLS.RParam("pageId")

		Sql = "select id, description, content from T_Page order by id desc"
		Set Rs = Dream3CLS.Exec(Sql)
		If PageId = "" Then
			pageId = Rs("id")
		End If
		Sql = "select id, description, content from T_Page Where id='"&pageId&"'"
		Set cityRs = Dream3CLS.Exec(Sql)
		title = cityRs("description")
		content = cityRs("content")
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="../../common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="../../xheditor/xheditor-zh-cn.min.js"></script>

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">页面编辑</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>
<div id="box">
					
				<div class="sect">
				
					<div>
					  <div align="left">
					    <%
						  Do while not Rs.eof 
							  tempPageId = Rs("id")
							  tempPageDesc = Rs("Description")
					     %>
					  <a href="page.asp?act=changePage&pageId=<%=tempPageId%>">[<%=tempPageDesc%>]</a>&nbsp;&nbsp;&nbsp;&nbsp;
						<%
							  Rs.movenext
						Loop
						%>
					  
					</div>
					
                    
					<div class="wholetip clear"><h3><%=title%></h3></div>
					<form name="form" method="post"  action="page.asp?act=savePage" onSubmit="return CheckForm(this);">
					
					<div class="field">
						
						<div style="float: left;">
						
						  <input type="hidden" name="pageId" id="pageId" value="<%=pageId%>"/>
						  <textarea id="pageContent" name="pageContent" class="xheditor" rows="12" cols="80" style="width: 80%"><%=content%></textarea>
						</div>
						<div class="act">
							<input type="submit" class="formbutton" name="commit" value="保存">
						</div>
                	</div>
				</form>
				
				
            </div>

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->