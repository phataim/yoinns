<div class="nav_sub_menu">
	<ul class="tabcontent">
		
		<li>
			<a <%if instr(paramUrl,"classifier=unconfirm") then response.Write("class='current'")%> href="index.asp?classifier=unconfirm"><span>待确认订单</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=unpay") then response.Write("class='active'")%> href="index.asp?classifier=unpay"><span>待付款订单</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=pay") then response.Write("class='active'")%> href="index.asp?classifier=pay"><span>已完成订单</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=lodgercancel") then response.Write("class='active'")%> href="index.asp?classifier=lodgercancel"><span>房客取消订单</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=ownercancel") then response.Write("class='active'")%> href="index.asp?classifier=ownercancel"><span>房东取消订单</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=failed") then response.Write("class='active'")%> href="index.asp?classifier=failed"><span>失败订单</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=admincancel") then response.Write("class='active'")%> href="index.asp?classifier=admincancel"><span>管理员取消订单</span></a>
		</li>
		<%
		If instr(detailUrl,"orderDetail.asp") > 0 Then
		%>
		<li class="current">
			<a href="#"><span>订单详情</span></a>
		</li>
		<%End If%>
		
    </ul>
</div>