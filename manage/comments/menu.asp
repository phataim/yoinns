<div class="nav_sub_menu">
	<ul class="tabcontent">

		
		<li><a <%If classifier="reserve" Then response.Write("class='current'")%> href="comments.asp?c=reserve">待审核评论</a></li>
		<li><a <%If classifier="cash" Then response.Write("class='current'")%> href="comments.asp?c=cash">已审核评论</a></li>
		<li><a <%If classifier="manualrefund" Then response.Write("class='current'")%> href="comments.asp?c=manualrefund">全部评论</a></li>										
						

    </ul>
</div>

