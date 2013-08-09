<div class="list_tags clearfix">
	<a href="setting.asp" <%if instr(curFullUrl,"/setting.asp") then response.Write("class='hot'")%>><span>个人资料</span></a>
	<a href="pwdsetting.asp" <%if instr(curFullUrl,"pwdsetting.asp") then response.Write("class='hot'")%>>修改密码</a>
</div>