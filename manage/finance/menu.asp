<div class="nav_sub_menu">
	<ul class="tabcontent">

		
		<li><a <%If classifier="reserve" Then response.Write("class='current'")%> href="finance.asp?c=reserve">定金</a></li>
		<li><a <%If classifier="cash" Then response.Write("class='current'")%> href="finance.asp?c=cash">现金支付</a></li>
		<li><a <%If classifier="manualrefund" Then response.Write("class='current'")%> href="finance.asp?c=manualrefund">人工退款记录</a></li>										
						

    </ul>
</div>

