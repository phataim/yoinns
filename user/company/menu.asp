<div class="list_tags clearfix">
	<a href="myhotel.asp"<%if instr(curFullUrl,"/myhotel.asp") then response.Write("class='hot'")%>>我的酒店/旅店</a>
	<%If zipcode="1" Then %>
	<span></span>
	<%Else %>
	<a href="<%=VirtualPath%>/hotelsend.asp"><span>发布酒店/旅店</span></a>
	<%End If %>
	<a href="myroom.asp"<%if instr(curFullUrl,"/myroom.asp") then response.Write("class='hot'")%>><span>我的房型</span></a>
	<a href="<%=VirtualPath%>/pstep1.asp"><span>发布房型</span></a>
	
</div>
