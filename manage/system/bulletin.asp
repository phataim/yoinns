<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->

<%
Dim Action,bulletinRs,Sql
Dim tempPageId, pageId, tempPageDesc, content,title,cityId

	Action = Request.QueryString("act")
	Select Case Action
		   Case "changeCity"
		   		Call ChangeCity()
		   Case "saveBulletin"
		   		Call SaveBulletin()
		   Case Else
				Call Main()
	End Select
	
	Sub saveBulletin()
		cityId = Request.Form("cityId")
		content = Request.Form("bulletinContent")

		
		If Len(content) > 2000 then
			gMsgArr = "内容不能超过2000"
			gMsgFlag = "E"
			Exit Sub
		End If
		
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_Bulletin where city_id="&cityId
		Rs.open Sql,conn,1,2
		
		If Rs.EOF Then 
			Rs.AddNew
		End If
			Rs("city_id") 	= cityId
			Rs("admin_id") 	= Session("_UserID")
			Rs("content") 	= content
			Rs("create_time")= Now()
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		if err.Number = 0 then
			gMsgFlag = "S"
			Call Main()
		else

		end if
		
	End Sub
	
	Sub ChangeCity()

		'cityId = Dream3CLS.ChkNumeric(Request.QueryString("cityId"))
		'Sql = "select content from T_Bulletin Where cityId="&cityId
		'Set Rs = Dream3CLS.Exec(Sql)
		
		Call Main()
		
	End Sub

	
	Sub Main()
		cityId = Dream3CLS.ChkNumeric(Request("cityId"))

		Sql = "select id,category,cname from T_CATEGORY Where classifier='city' and enabled='Y' order by classifier"
		Set Rs = Dream3CLS.Exec(Sql)
		If cityId=0 Then
			cityId = "0"
		End If
		
		'得到城市中文名
		If cityId = 0  Then 
			title = "全部"
		Else
			Sql = "select id,category,cname from T_CATEGORY Where classifier='city' and enabled='Y' and id="&cityId
			Set titleRs = Dream3CLS.Exec(Sql)
			If titleRs.EOF Then
				Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
				response.End()
			End If
			title = titleRs("cname")
		End If
		
		Sql = "select content from T_Bulletin Where  city_id="&cityId
		Set bulletinRs = Dream3CLS.Exec(Sql)
		If  bulletinRs.EOF  Then
			content = ""
		else 
		
			content = bulletinRs("content")
		End If
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="../../common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="../../xheditor/xheditor-zh-cn.min.js"></script>
<script type="text/javascript">
$(pageInit);
function pageInit()
{
	$('#bulletinContent').xheditor({upImgUrl:"../../common/upload/upload.asp",upImgExt:"jpg,jpeg,gif,png",shortcuts:{'ctrl+enter':submitForm}});
}
function submitForm(){$('#myForm').submit();}
</script>
<div id="box">
<div class="clear mainwide" id="content">
        <div class="clear box">
            
            <div class="box-content">
                <div class="head"><h2>系统公告</h2></div> 
					
				<div class="sect">
				
					<div>
					<div align="left">
					  <a href="bulletin.asp?act=changeCity&cityId=0">[全部]</a>&nbsp;&nbsp;&nbsp;&nbsp;
					</div>
					  <div align="left">
					    <%
						  Do while not Rs.eof 
							  tempCityId = Rs("id")
							  cname = Rs("cname")
					     %>
					  <a href="bulletin.asp?act=changeCity&cityId=<%=tempCityId%>">[<%=cname%>]</a>&nbsp;&nbsp;&nbsp;&nbsp;
						<%
							  Rs.movenext
						Loop
						%>
					  
					</div>
					
                    
					<div class="wholetip clear"><h3><%=title%></h3></div>
					<form name="myForm" id="myForm" method="post"  action="bulletin.asp?act=saveBulletin" onSubmit="return CheckForm(this);">
					
					<div class="field">
						
						<div style="float: left;">
						
							<table>

								<TR id=CommonListCell>
                          <TD vAlign=top>
						 
							<span id=UpFile></span>
		    			
						  </TD>
						  <input type="hidden" name="cityId" id="cityId" value="<%=cityId%>"/>
                          <TD height="250" width="650" colSpan=2>
						  	<textarea id="bulletinContent" name="bulletinContent"  rows="12" cols="80" style="width: 80%"><%=content%></textarea>
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
	</div>
</div>

<!--#include file="../../common/inc/footer_manage.asp"-->