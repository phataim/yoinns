<div class="nav_sub_menu">
	<ul class="tabcontent">
		
		<li>
			<a <%if("email.asp"=detailUrl) then response.Write("class='current'")%> href="email.asp" ><span>�ʼ�Ⱥ��</span></a>
		</li>
		<li>
			<a <%if("sms.asp"=detailUrl) then response.Write("class='current'")%> href="sms.asp" ><span>����Ⱥ��</span></a>
		</li>
		
    </ul>
</div>