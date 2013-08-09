<div class="list_tags clearfix">
	<a href="order.asp"<%if instr(curFullUrl,"/order.asp") then response.Write("class='hot'")%>><span>我的订单</span></a>
	<a href="#"<%if instr(curFullUrl,"/record.asp") then response.Write("class='hot'")%> style="display:none "><span>交易记录</span></a>
</div>

