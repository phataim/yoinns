<div class="nav_sub_menu">
	<ul class="tabcontent">
		
		<li>
			<a <%if instr(paramUrl,"classifier=auditing") then response.Write("class='current'")%> href="index.asp?classifier=auditing"><span>待审核房源</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=normal") then response.Write("class='current'")%> href="index.asp?classifier=normal"><span>发布成功房源</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=pending") then response.Write("class='current'")%> href="index.asp?classifier=pending"><span>创建中房源</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=unpass") then response.Write("class='current'")%> href="index.asp?classifier=unpass"><span>未通过房源</span></a>
		</li>
		<li style="display:none ">
			<a <%if instr(paramUrl,"classifier=delete") then response.Write("class='current'")%> href="index.asp?classifier=delete"><span>已删除的房源</span></a>
		</li>
		<li style="display:none ">
			<a <%if("createProduct.asp"=detailUrl) then response.Write("class='current'")%> href="createProduct.asp"><span>新建房源</span></a>
		</li>
		<%
		If instr(detailUrl,"teamDetail.asp") > 0 Then
		%>
		<li class="current">
			<a href="#"><span>房源详情</span></a>
		</li>
		<%End If%>
		
    </ul>
</div>
