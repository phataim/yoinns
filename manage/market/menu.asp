<div class="nav_sub_menu">
	<ul class="tabcontent">
		
		<li>
			<a <%if("email.asp"=detailUrl) then response.Write("class='current'")%> href="email.asp" ><span>邮件群发</span></a>
		</li>
		<li>
			<a <%if("sms.asp"=detailUrl) then response.Write("class='current'")%> href="sms.asp" ><span>短信群发</span></a>
		</li>
		
    </ul>
</div>