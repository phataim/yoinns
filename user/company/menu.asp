<div class="list_tags clearfix">
	<a href="myhotel.asp"<%if instr(curFullUrl,"/myhotel.asp") then response.Write("class='hot'")%>>�ҵľƵ�/�õ�</a>
	<%If zipcode="1" Then %>
	<span></span>
	<%Else %>
	<a href="<%=VirtualPath%>/hotelsend.asp"><span>�����Ƶ�/�õ�</span></a>
	<%End If %>
	<a href="myroom.asp"<%if instr(curFullUrl,"/myroom.asp") then response.Write("class='hot'")%>><span>�ҵķ���</span></a>
	<a href="<%=VirtualPath%>/pstep1.asp"><span>��������</span></a>
	
</div>
