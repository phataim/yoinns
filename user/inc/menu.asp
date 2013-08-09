<div class="layoutleft mt9">
	<div class="leftbox clearfix">
		<div class="left_tag clearfix">
			<ul class="clearfix">
			<li <%if instr(curFullUrl,"account/") then response.Write("class='curr'")%>>
				<a href="<%=VirtualPath%>/user/account/setting.asp">帐户设置</a>
				</li>
			<%
			dim states
			Sql = "Select * From T_User Where id = "&session("_UserID")
			Set Rs = Dream3CLS.Exec(Sql)
			states = Rs("state")
			if states=1 then
			%>
			
				
				<li <%if instr(curFullUrl,"lodger/") then response.Write("class='curr'")%>>
				<a href="<%=VirtualPath%>/user/lodger/order.asp">我是房客</a></li>
				<%elseif states=2 then%>
				<li <%if instr(curFullUrl,"owner/") then response.Write("class='curr'")%>>
				<a href="<%=VirtualPath%>/user/owner/order.asp">管理订单</a>
				</li>
				<li <%if instr(curFullUrl,"company/") then response.Write("class='curr'")%>>
				<a href="<%=VirtualPath%>/user/company/myhotel.asp">管理酒店/旅店</a>
				</li>
				<%end if%>
				<li style="display:none "><a href="#">我的信箱</a></li>
				<li style="display:none "><a href="#">我的评论</a></li>
			</ul>
		</div>
	</div>
</div>