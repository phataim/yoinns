<div class="nav_sub_menu">
	<ul class="tabcontent">
		
		<li>
			<a <%if instr(paramUrl,"classifier=auditing") then response.Write("class='current'")%> href="index.asp?classifier=auditing"><span>����˷�Դ</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=normal") then response.Write("class='current'")%> href="index.asp?classifier=normal"><span>�����ɹ���Դ</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=pending") then response.Write("class='current'")%> href="index.asp?classifier=pending"><span>�����з�Դ</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=unpass") then response.Write("class='current'")%> href="index.asp?classifier=unpass"><span>δͨ����Դ</span></a>
		</li>
		<li style="display:none ">
			<a <%if instr(paramUrl,"classifier=delete") then response.Write("class='current'")%> href="index.asp?classifier=delete"><span>��ɾ���ķ�Դ</span></a>
		</li>
		<li style="display:none ">
			<a <%if("createProduct.asp"=detailUrl) then response.Write("class='current'")%> href="createProduct.asp"><span>�½���Դ</span></a>
		</li>
		<%
		If instr(detailUrl,"teamDetail.asp") > 0 Then
		%>
		<li class="current">
			<a href="#"><span>��Դ����</span></a>
		</li>
		<%End If%>
		
    </ul>
</div>
