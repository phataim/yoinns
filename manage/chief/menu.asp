<div class="tabs_header">
	<ul class="tabs">
		<li <%if("index.asp"=detailUrl) then response.Write("class='active'")%>>
			<a href="index.asp"><span>��ҳ</span></a>
		</li>
		<li <%if("message.asp"=detailUrl) then response.Write("class='active'")%>  style="display:none ">
			<a href="message.asp"><span>���԰�</span></a>
		</li>
		<li <%if("ad.asp"=detailUrl) then response.Write("class='active'")%>>
			<a href="ad.asp"><span>���ͼƬ</span></a>
		</li>
		<li <%if("friendlink.asp"=detailUrl) then response.Write("class='active'")%>>
			<a href="friendlink.asp"><span>��������</span></a>
		</li>
		<li <%if("finance.asp"=detailUrl) then response.Write("class='active'")%>>
			<a href="finance.asp"><span>����</span></a>
		</li>
		<%
		If instr(detailUrl,"friendlinkEdit.asp") > 0 Then
		%>
		<li class="active">
			<a href="#"><span><%=operate%><%=title%></span></a>
		</li>
		<%
		End If
		%>
		<%
		If instr(detailUrl,"reply.asp") > 0 Then
		%>
		<li class="active">
			<a href="#"><span>��</span></a>
		</li>
		<%
		End If
		%>
		<%
		If instr(detailUrl,"messageReply.asp") > 0 Then
		%>
		<li class="active">
			<a href="#"><span>���Դ�</span></a>
		</li>
		<%
		End If
		%>
	</ul>
</div>