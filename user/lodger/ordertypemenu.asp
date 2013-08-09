<ul id="tags">
	<li <%If classifier="" Then%>class=selectTag<%End If%>>
		<a  href="?c=">全部订单</a>
	</li>
	<li <%If classifier="unconfirm" Then%>class=selectTag<%End If%>>
		<a href="?c=unconfirm">待确认订单</a> 
	</li>
	<li <%If classifier="unpay" Then%>class=selectTag<%End If%>>
		<a href="?c=unpay">待付款订单</a> 
	</li>
	<li <%If classifier="pay" Then%>class=selectTag<%End If%>>
		<a href="?c=pay">已完成订单</a> 
	</li>
	<li <%If classifier="lodgercancel" Then%>class=selectTag<%End If%>>
		<a href="?c=lodgercancel">房客取消订单</a> 
	</li>
	<li <%If classifier="ownercancel" Then%>class=selectTag<%End If%>>
		<a href="?c=ownercancel">房东取消订单</a> 
	</li>
	<li <%If classifier="refund" Then%>class=selectTag<%End If%>>
		<a href="?c=refund">退款订单</a> 
	</li>
	<li <%If classifier="failed" Then%>class=selectTag<%End If%>>
		<a href="?c=failed">失败订单</a> 
	</li>
</ul>