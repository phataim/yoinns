<div class="tabs_headermy">
	<ul class="tabs">
		<li <%if instr(curFullUrl,"about/us.asp") then response.Write("class='active'")%>>
		<a href="us.asp"><span>����<%=SiteConfig("SiteShortName")%></span></a>
		</li>
		<li <%if instr(curFullUrl,"about/contact.asp") then response.Write("class='active'")%>>
		<a href="contact.asp"><span>��ϵ��ʽ</span></a>
		</li>
		<li <%if instr(curFullUrl,"about/terms.asp") then response.Write("class='active'")%>>
		<a href="terms.asp"><span>�û�Э��</span></a>
		</li>
		<li <%if instr(curFullUrl,"about/privacy.asp") then response.Write("class='active'")%>>
		<a href="privacy.asp"><span>��˽����</span></a>
		</li>
	</ul>
</div>