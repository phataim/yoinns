<div class="nav_sub_menu">
	<ul class="tabcontent">
		
		<li>
		<a <%if("province.asp"=detailUrl) then response.Write("class='current'")%> href="province.asp" ><span>����</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=grade") then response.Write("class='current'")%> href="index.asp?classifier=grade"><span>�û��ȼ�</span></a>
		</li>
		<li>
		<a <%if("facility.asp"=detailUrl) then response.Write("class='current'")%> href="facility.asp" ><span>������ʩ</span></a>
		</li>
		<li>
		<a <%if("hotelfacility.asp"=detailUrl) then response.Write("class='current'")%> href="hotelfacility.asp" ><span>�Ƶ���ʩ</span></a>
		</li>

		<%
		If instr(detailUrl,"categoryEdit.asp") > 0 Then
		%>
		<li>
			<%
				'classifier = Request.QueryString("classifier")
				If classifier <> "express" and  classifier <> "grade" and classifier <> "group"   Then classifier = "city"
			%>
			<a class="current" href="#"><span><%=operate%><%=title%></span></a>
		</li>
		<%End If%>
		
    </ul>
</div>