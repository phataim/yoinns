<div class="nav_sub_menu">
	<ul class="tabcontent">
		<li><a <%if("index.asp"=detailUrl) then response.Write("class='current'")%> href="index.asp">��������</a></li>
		<li><a <%if("style.asp"=detailUrl) then response.Write("class='current'")%> href="managenotice.asp">������</a></li>
		<li><a <%if("option.asp"=detailUrl) then response.Write("class='current'")%> href="option.asp">ѡ������</a></li>
		<li style="display:none "><a <%if("bulletin.asp"=detailUrl) then response.Write("class='current'")%> href="bulletin.asp">����</a></li>
		<li><a <%if("pay.asp"=detailUrl) then response.Write("class='current'")%> href="pay.asp">֧������</a></li>
		<li><a <%if("mail.asp"=detailUrl) then response.Write("class='current'")%> href="mail.asp">�ʼ�����</a></li>
		<li><a <%if("sms.asp"=detailUrl) then response.Write("class='current'")%> href="sms.asp">��������</a></li>
		<li><a <%if("page.asp"=detailUrl) then response.Write("class='current'")%> href="page.asp">ҳ������</a></li>
		<li><a <%if("allowIPs.asp"=detailUrl) then response.Write("class='current'")%> href="allowIPs.asp">IP�޶�</a></li>
		<li><a <%if("template.asp"=detailUrl) then response.Write("class='current'")%> href="template.asp">ģ������</a></li>
		<li><a <%if("ad.asp"=detailUrl) then response.Write("class='current'")%> href="ad.asp"><span>������</span></a></li>
		<li><a <%if("friendlink.asp"=detailUrl) then response.Write("class='current'")%> href="friendlink.asp"><span>��������</span></a></li>
		<li><a <%if("hotelmanage.asp"=detailUrl) then response.Write("class='current'")%> href="hotelmanage.asp"><span>�Ƶ�����</span></a></li>
		<%
		If instr(detailUrl,"tpldetail.asp") > 0 Then
		%>
		<li>
			<a class="current" href="#">�༭ģ��</a>
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