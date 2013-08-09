<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<%
Dim Action
Dim askid,Rs
Dim username,teamTitle,content,comment

	Action = Request.QueryString("act")
	Select Case Action
		   Case "save"
		   		Call Reply()
		   Case Else
				Call Main()
	End Select
	
	Sub Reply()
		askid = Dream3CLS.ChkNumeric(Request("askid"))
		content = Dream3CLS.RParam("content")
		comment = Dream3CLS.RParam("comment")
		
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_Ask  "
		If askid <> "" Then
			Sql = Sql & " Where ID="&askid
		End If
		
		Rs.open Sql,conn,1,2
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			response.End()
		End If
		
		Rs("content") 	= content
		Rs("comment") 	= comment
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		'gMsgFlag = "S"
		Dream3CLS.showMsg "保存成功","S","ask.asp"

	End Sub
	

	
	Sub Main()		
		askid = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		Sql = "Select user_id,team_id,content,comment From T_Ask Where id="&askid
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			response.End()
		End If
		
		content = Rs("content")
		user_id = Rs("user_id")
		team_id = Rs("team_id")
		comment = Rs("comment")
		
		Set Rs = Dream3Team.getUserById(user_id)
		username = Rs("username")
		Set Rs = Dream3Team.getTeamById(team_id)
		
		teamTitle = Rs("title")

	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<div id="box">
<div id="content" class="clear mainwide">
        <div class="clear box">
            <div class="box-top"></div>
            <div class="box-content">
                <div class="head"><h2>答复</h2><span class="headtip"><%=username%>关于（<a href="#" target="_blank"><%=teamTitle%></a>）的咨询</span></div>
                <div class="sect">
                    <form id="myform" method="post" action="reply.asp?act=save">
						<input type="hidden" name="id" value="1" />
                        <div class="field">
                            <label>咨询问题</label>
                            <textarea cols="45" rows="5" name="content" id="content" class="f-textarea"><%=content%></textarea>
                        </div>
                        <div class="field">
                            <label>答复内容</label>
                            <textarea cols="45" rows="5" name="comment" id="comment" class="f-textarea"><%=comment%></textarea>
                        </div>
                        <div class="act">
							<input type="hidden" name="askid" value="<%=askid%>"/>
                            <input type="submit" value="编辑" name="commit" id="misc-submit" class="formbutton"/>
                        </div>
                    </form>
                </div>
            </div>
            <div class="box-bottom"></div>
        </div>
	</div>
<!--#include file="../../common/inc/footer_manage.asp"-->