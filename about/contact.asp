<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<%
Dim Sql,Rs
Dim PageKey

PageKey = "contact"

Sql = "Select [Description],[Content] From T_Page Where ID='"&PageKey&"'"
Set Rs = Dream3CLS.Exec(Sql)
title = Rs("Description")
content = Rs("content")
%>
<!--#include file="../common/inc/common_page_title.asp"-->
<!--#include file="../common/inc/header_user.asp"-->
<div id="box">	
	<div class="cf">		
		<div id="credit">
			<div class="login-box" id="content">
					
					<!--#include file="menu.asp"-->
					
					<div class="login-content">
						<div class="head">
							<h2><%=title%></h2>
						</div>
						
						<div class="sect">
						<!--Start-->
						
						<%=content%>
						
						<!--end content-->
						</div>
						
					</div>
					<div class="login-bottom"></div>
			</div>
			<div id="sidebar" style="margin-top:28px;">
			<!--#include file="../common/inc/supply_right.asp"-->
			</div>
			<div class="blank10"></div>
			
			<!--#include file="../common/inc/mail_right.asp"-->
			
				
				
			</div>
		</div>
	</div>	
</div>

<!--#include file="../common/inc/footer_user.asp"-->
