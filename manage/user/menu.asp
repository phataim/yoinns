<div class="nav_sub_menu">
	<ul class="tabcontent">
		
		<li>
			<a <%if("index.asp"=detailUrl) then response.Write("class='active'")%> href="index.asp"><span>用户列表</span></a>
		</li>
		<li>
			<a <%if("manager.asp"=detailUrl) then response.Write("class='active'")%> href="manager.asp"><span>管理员列表</span></a>
		</li>
		<%
		If instr(detailUrl,"userEdit.asp") > 0 Then
		%>
		<li class="current">
			<a href="#"><span>编辑用户</span></a>
		</li>
		<%End If%>
		<%
		If instr(detailUrl,"userDetail.asp") > 0 Then
		%>
		<li class="current">
			<a href="#"><span>用户详情</span></a>
		</li>
		<%End If%>
		<%
		If instr(detailUrl,"userWithdraw.asp") > 0 Then
		%>
		<li class="current">
			<a href="#"><span>用户提现</span></a>
		</li>
		<%End If%>
		
    </ul>
</div>
