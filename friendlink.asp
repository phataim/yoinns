<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/header_user.asp"-->

<%
Dim Sql,Rs
Dim PageKey

PageKey = "contact"

Sql = "Select [Description],[Content] From T_Page Where ID='"&PageKey&"'"
Set Rs = Dream3CLS.Exec(Sql)
title = Rs("Description")
content = Rs("content")
%>

<div id="box">	
	<div class="cf">		
		<div id="recent-deals">
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>”—«È¡¥Ω”</h2></div>
						
						<div class="Friendlink">

							<ul>
								<%
								Sql = "Select sitename,siteurl,logo From T_FriendLink Where logo <> '' order by seqno Desc"
								Set Rs = Dream3CLS.Exec(Sql)
								Do While Not Rs.EOF 
								%>
								<li class="img"><a target="_blank" href="<%=Rs("siteurl")%>">
								<img src="<%=Rs("logo")%>" alt="<%=Rs("sitename")%>" /></a>
								</li>
								<%
									Rs.Movenext
								Loop
								%>
								
							</ul>
							<ul>
								<%
								Sql = "Select sitename,siteurl,logo From T_FriendLink Where logo = '' order by seqno Desc"
								Set Rs = Dream3CLS.Exec(Sql)
								Do While Not Rs.EOF 
								%>
								<li><a target="_blank" href="<%=Rs("siteurl")%>"><%=Rs("sitename")%></a></li>
								<%
									Rs.Movenext
								Loop
								%>
							</ul>
						</div>
						
					</div>
					<div class="login-bottom"></div>
			</div>
			<div id="sidebar">
				<!--#include file="common/inc/mail_right.asp"-->
			</div>
		</div>
	</div>	
</div>

<!--#include file="common/inc/footer_user.asp"-->
