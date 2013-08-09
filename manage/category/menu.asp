<div class="nav_sub_menu">
	<ul class="tabcontent">
		
		<li>
		<a <%if("province.asp"=detailUrl) then response.Write("class='current'")%> href="province.asp" ><span>城市</span></a>
		</li>
		<li>
			<a <%if instr(paramUrl,"classifier=grade") then response.Write("class='current'")%> href="index.asp?classifier=grade"><span>用户等级</span></a>
		</li>
		<li>
		<a <%if("facility.asp"=detailUrl) then response.Write("class='current'")%> href="facility.asp" ><span>房间设施</span></a>
		</li>
		<li>
		<a <%if("hotelfacility.asp"=detailUrl) then response.Write("class='current'")%> href="hotelfacility.asp" ><span>酒店设施</span></a>
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