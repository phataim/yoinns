<div class="nav_sub_menu">
	<ul class="tabcontent">
		
		<li>
			<a <%if("index.asp"=detailUrl) then response.Write("class='active'")%> href="index.asp"><span>�û��б�</span></a>
		</li>
		<li>
			<a <%if("manager.asp"=detailUrl) then response.Write("class='active'")%> href="manager.asp"><span>����Ա�б�</span></a>
		</li>
		<%
		If instr(detailUrl,"userEdit.asp") > 0 Then
		%>
		<li class="current">
			<a href="#"><span>�༭�û�</span></a>
		</li>
		<%End If%>
		<%
		If instr(detailUrl,"userDetail.asp") > 0 Then
		%>
		<li class="current">
			<a href="#"><span>�û�����</span></a>
		</li>
		<%End If%>
		<%
		If instr(detailUrl,"userWithdraw.asp") > 0 Then
		%>
		<li class="current">
			<a href="#"><span>�û�����</span></a>
		</li>
		<%End If%>
		
    </ul>
</div>
