<div class="nav_sub_menu">
	<ul class="tabcontent">
		<li><a <%if("index.asp"=detailUrl) then response.Write("class='current'")%> href="index.asp">基本设置</a></li>
		<li><a <%if("style.asp"=detailUrl) then response.Write("class='current'")%> href="managenotice.asp">管理公告</a></li>
		<li><a <%if("option.asp"=detailUrl) then response.Write("class='current'")%> href="option.asp">选项设置</a></li>
		<li style="display:none "><a <%if("bulletin.asp"=detailUrl) then response.Write("class='current'")%> href="bulletin.asp">公告</a></li>
		<li><a <%if("pay.asp"=detailUrl) then response.Write("class='current'")%> href="pay.asp">支付设置</a></li>
		<li><a <%if("mail.asp"=detailUrl) then response.Write("class='current'")%> href="mail.asp">邮件设置</a></li>
		<li><a <%if("sms.asp"=detailUrl) then response.Write("class='current'")%> href="sms.asp">短信设置</a></li>
		<li><a <%if("page.asp"=detailUrl) then response.Write("class='current'")%> href="page.asp">页面设置</a></li>
		<li><a <%if("allowIPs.asp"=detailUrl) then response.Write("class='current'")%> href="allowIPs.asp">IP限定</a></li>
		<li><a <%if("template.asp"=detailUrl) then response.Write("class='current'")%> href="template.asp">模板设置</a></li>
		<li><a <%if("ad.asp"=detailUrl) then response.Write("class='current'")%> href="ad.asp"><span>广告管理</span></a></li>
		<li><a <%if("friendlink.asp"=detailUrl) then response.Write("class='current'")%> href="friendlink.asp"><span>友情链接</span></a></li>
		<li><a <%if("hotelmanage.asp"=detailUrl) then response.Write("class='current'")%> href="hotelmanage.asp"><span>酒店设置</span></a></li>
		<%
		If instr(detailUrl,"tpldetail.asp") > 0 Then
		%>
		<li>
			<a class="current" href="#">编辑模板</a>
		</li>
		<%End If%>
		
		<%
		If instr(detailUrl,"friendlinkEdit.asp") > 0 Then
		%>
		<li>
			<a class="current" href="#"><%=operate%><%=title%></a>
		</li>
		<%
		End If
		%>
		
	</ul>
</div>