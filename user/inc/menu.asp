<div class="layoutleft mt9">
	<div class="leftbox clearfix">
		<div class="left_tag clearfix">
			<ul class="clearfix">
			<li <%if instr(curFullUrl,"account/") then response.Write("class='curr'")%>>
				<a href="<%=VirtualPath%>/user/account/setting.asp">�ʻ�����</a>
				</li>
			<%
			dim states
			Sql = "Select * From T_User Where id = "&session("_UserID")
			Set Rs = Dream3CLS.Exec(Sql)
			states = Rs("state")
			if states=1 then
			%>
			
				
				<li <%if instr(curFullUrl,"lodger/") then response.Write("class='curr'")%>>
				<a href="<%=VirtualPath%>/user/lodger/order.asp">���Ƿ���</a></li>
				<%elseif states=2 then%>
				<li <%if instr(curFullUrl,"owner/") then response.Write("class='curr'")%>>
				<a href="<%=VirtualPath%>/user/owner/order.asp">������</a>
				</li>
				<li <%if instr(curFullUrl,"company/") then response.Write("class='curr'")%>>
				<a href="<%=VirtualPath%>/user/company/myhotel.asp">����Ƶ�/�õ�</a>
				</li>
				<%end if%>
				<li style="display:none "><a href="#">�ҵ�����</a></li>
				<li style="display:none "><a href="#">�ҵ�����</a></li>
			</ul>
		</div>
	</div>
</div>