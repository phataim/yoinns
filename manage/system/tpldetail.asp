<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_fso.asp"-->
<%
Dim Action
Dim fileName,folderPath,content

folderPath = Server.MapPath("../../templates")	

Action = Request.QueryString("act")
Select Case Action
	   Case "save"
	       Call EditFile()
	   Case Else
		   Call Main()
End Select

Sub editFile()
	'filename = Dream3CLS.RParam("filename")
	content  = Dream3CLS.RParam("content")
	'filepath = folderPath &"\"& filename
	'Dream3File.SaveToFile content,filepath
	gMsgArr = gMsgArr&"请手工修改相应的文件"
	gMsgFlag = "E"
End Sub

Sub Main()
	getFile()
End Sub
	
Sub getFile()
	filename= Dream3CLS.RParam("name")
	filepath = folderPath &"\"& filename
	content = Dream3File.LoadFile(filepath)
End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">编辑模板</span><span class="fr">&nbsp;</span></div>
    <div class="say">
		 文件名称：<%=filename%>
    </div>
</div>

<div id="box">
					
				<div class="sect">
					<div>
					
					<form name="myForm" id="myForm" method="post"  action="?act=save">
					<div class="field">
						<div style="float: left;">
						<table>
						<TR id=CommonListCell>
                          <TD vAlign=top>
						  </TD>
						  <input type="hidden" name="filename" id="filename" value="<%=filename%>"/>
                          <TD height="250" width="650" colSpan=2>
						  	<textarea id="content" name="content"  rows="22" cols="150" style="width: 100%"><%=content%></textarea>
						  </TD>
                        </TR>
						</table>
						
						</div>
						<div class="act">
							<input type="submit" class="formbutton" name="commit" value="保存">
						</div>
                	</div>
				</form>
            </div>
           
</div>

<!--#include file="../../common/inc/footer_manage.asp"-->