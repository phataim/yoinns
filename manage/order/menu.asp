<div class="nav_sub_menu">
	<ul class="tabcontent">
		
		<li>
			<a <%if instr(paramUrl,"classifier=unconfirm") then response.Write("class='current'")%> href="index.asp?classifier=unconfirm"><span>��ȷ�϶���</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=unpay") then response.Write("class='active'")%> href="index.asp?classifier=unpay"><span>�������</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=pay") then response.Write("class='active'")%> href="index.asp?classifier=pay"><span>����ɶ���</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=lodgercancel") then response.Write("class='active'")%> href="index.asp?classifier=lodgercancel"><span>����ȡ������</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=ownercancel") then response.Write("class='active'")%> href="index.asp?classifier=ownercancel"><span>����ȡ������</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=failed") then response.Write("class='active'")%> href="index.asp?classifier=failed"><span>ʧ�ܶ���</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=admincancel") then response.Write("class='active'")%> href="index.asp?classifier=admincancel"><span>����Աȡ������</span></a>
		</li>
		<%
		If instr(detailUrl,"orderDetail.asp") > 0 Then
		%>
		<li class="current">
			<a href="#"><span>��������</span></a>
		</li>
		<%End If%>
		
    </ul>
</div>