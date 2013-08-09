<div class="tabs_headermy">
	<ul class="tabs">
		<li <%if instr(curFullUrl,"about/us.asp") then response.Write("class='active'")%>>
		<a href="us.asp"><span>关于<%=SiteConfig("SiteShortName")%></span></a>
		</li>
		<li <%if instr(curFullUrl,"about/contact.asp") then response.Write("class='active'")%>>
		<a href="contact.asp"><span>联系方式</span></a>
		</li>
		<li <%if instr(curFullUrl,"about/terms.asp") then response.Write("class='active'")%>>
		<a href="terms.asp"><span>用户协议</span></a>
		</li>
		<li <%if instr(curFullUrl,"about/privacy.asp") then response.Write("class='active'")%>>
		<a href="privacy.asp"><span>隐私声明</span></a>
		</li>
	</ul>
</div>