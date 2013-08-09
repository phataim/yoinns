<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_fso.asp"-->

<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<%              
 Action = Request.QueryString("act")
	Select Case Action
		  
		   Case "delete"
		   		Call DeleteNotice()
	End Select  
				
sub DeleteNotice()
        m_id = Dream3CLS.ChkNumeric(Request("m_id"))
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "Delete  From T_notice Where m_id="&m_id
		Dream3CLS.Exec(sql)
		gMsgArr = "删除成功！"
		gMsgFlag = "S"
		response.Redirect("managenotice.asp")
		  
end sub	 
	
  
	
%>          
<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">管理公告&nbsp;&nbsp;&nbsp;&nbsp;<a href="newnotice.asp"><u>发布新公告</u></a></span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">
				
                <div class="sect">
					<table id="orders-list" cellspacing="0" cellpadding="0" border="0" class="coupons-table">
					<tr>
					<th width="150">标题</th>
					<th width="300">内容</th>
					<th width="80">发布时间</th>
					<th width="80">操作</th>
					</tr>
					    <%
						msql = "Select * From T_notice order by m_id desc"
							Set rs = Dream3CLS.Exec(msql)
						do while not rs.eof
						    m_id=rs("m_id")
							m_title=left(rs("m_title"),15)
							m_content=rs("m_content")
							if len(m_content)>20 then m_content=left(m_content,20)+"..." end if
							m_time=left(rs("m_date"),10)
						
						
						%>
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td nowrap><%=m_title%></td>
						<td nowrap><%=m_content%></td>
						<td nowrap><%=m_time%></td>
						<td class="op" nowrap>
						<a  href="editnotice2.asp?m_id=<%=m_id%>" class="ajaxlink">编辑</a>&nbsp;|&nbsp;
                        <a class="ajaxlink" href="?act=delete&m_id=<%=m_id%>" onclick="return window.confirm('您确定要删除该条记录?')">删除</a>
						</td>
					</tr>
                    <%
                        rs.movenext
						
						loop
					%>
					<%
						'i = i+1
					'Next
					%>
					
                    </table>
				</div>
            
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->
