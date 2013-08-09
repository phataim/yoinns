<div class="list_tags clearfix">
	<a href="order.asp"<%if instr(curFullUrl,"/order.asp") then response.Write("class='hot'")%>>订单管理</a>
	<a href="myroom.asp"<%if instr(curFullUrl,"/myroom.asp") then response.Write("class='hot'")%>><span>我的房间</span></a>
	<a href="<%=VirtualPath%>/publish.asp"><span>发布房间</span></a>
	<a href="我是房东-我的收款.html" style="display:none ">我的收款</a>
</div>

