<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_fso.asp"-->
<%
Dim Action
Dim path,fileListArray,f,i
i = 0
folderPath = Server.MapPath("../../templates")	
't(folderpath)
'fileListArray= Dream3File.getFileList(path)
FSOClassID = "Scripting.FileSystemObject"
Set fso = Dream3CLS.CreateAXObject(FSOClassID)
If fso.FolderExists(folderPath) Then
	Set f = fso.GetFolder(folderPath)
Else
	Response.Write("模板路径未找到")
	response.End()
End If

%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">模板设置</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">
				
                <div class="sect">
					<table id="orders-list" cellspacing="0" cellpadding="0" border="0" class="coupons-table">
					<tr>
					<th width="350">文件名称</th>
					<th width="80">大小</th>
					<th width="80">文件类型</th>
					<th width="350">修改日期</th>
					<th width="80">操作</th>
					</tr>
					<%
					For Each fileItem In f.Files
					%>
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td nowrap><%=fileItem.Name%></td>
						<td nowrap><%=fileItem.size/1000%>KB</td>
						<td nowrap>html</td>
						<td nowrap><%=fileItem.DateLastModified%></td>
						<td class="op" nowrap>
						<a  href="tpldetail.asp?name=<%=fileItem.Name%>" class="ajaxlink">编辑</a>
						</td>
					</tr>
					<%
						i = i+1
					Next
					%>
					
                    </table>
				</div>
            
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->
