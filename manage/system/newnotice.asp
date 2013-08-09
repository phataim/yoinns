<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_fso.asp"-->

<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />


<%
dim Action
Action = Request.QueryString("act")
Select Case Action
   Case "save"
	  call save()  
	'Case "showedit"
	'	Call ShowEdit()
	'	
	'Case Else
		'Call Main()
End Select

'sub main()
       ' m_id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		'Sql = "Select * from T_notice Where m_id="&m_id
		'Set Rs = Dream3CLS.Exec(Sql)
		'If Rs.EOF Then
			'Call Dream3CLS.MsgBox2("无法找到资源！"&pid,0,"0")
		'	response.End()
		'End If
		
		'm_id=Rs("m_id")
		'm_title=Rs("m_title")
		'm_content=Rs("m_content")
'end sub

sub save()

  ' m_id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
   m_content = Dream3CLS.RParam("m_content")
   'm_id = Dream3CLS.RParam("m_id")
   m_title = Dream3CLS.RParam("m_title")
   Set tRs = Server.CreateObject("Adodb.recordset")
   Sql = "Select * from T_notice"
    tRs.open Sql,conn,1,2 
	'If pid = 0  Then 
		tRs.AddNew
	'End If
	
	tRs("m_title") = m_title
	tRs("m_date") = now()
	tRs("m_content") = m_content
	
	tRs.Update
	
	tRs.Close
	Set tRs = Nothing


   response.Redirect("managenotice.asp")
end sub

%>
<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">编辑公告</span><span class="fr">&nbsp;</span></div>
    <form class="validator"  action="?act=save" method="post" id="editForm" name="editForm">
    <div class="say">
		公告标题：
        <input type="text" class="radius input" style="width:229px;" value="" name="m_title" id="m_title">
        <textarea id="m_content" name="m_content"  rows="22" cols="150" style="width: 80%"></textarea>
    </div>
</div>

<div id="box">
					
				<div class="sect">
					<div>
					
					<form name="myForm" id="myForm" method="post"  action="?act=save">
					
						<div class="act">
							<input type="submit" class="formbutton" name="commit" value="保存">
						</div>
                	</div>
				</form>
            </div>
           
</div>

<!--#include file="../../common/inc/footer_manage.asp"-->