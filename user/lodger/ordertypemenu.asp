<ul id="tags">
	<li <%If classifier="" Then%>class=selectTag<%End If%>>
		<a  href="?c=">ȫ������</a>
	</li>
	<li <%If classifier="unconfirm" Then%>class=selectTag<%End If%>>
		<a href="?c=unconfirm">��ȷ�϶���</a> 
	</li>
	<li <%If classifier="unpay" Then%>class=selectTag<%End If%>>
		<a href="?c=unpay">�������</a> 
	</li>
	<li <%If classifier="pay" Then%>class=selectTag<%End If%>>
		<a href="?c=pay">����ɶ���</a> 
	</li>
	<li <%If classifier="lodgercancel" Then%>class=selectTag<%End If%>>
		<a href="?c=lodgercancel">����ȡ������</a> 
	</li>
	<li <%If classifier="ownercancel" Then%>class=selectTag<%End If%>>
		<a href="?c=ownercancel">����ȡ������</a> 
	</li>
	<li <%If classifier="refund" Then%>class=selectTag<%End If%>>
		<a href="?c=refund">�˿��</a> 
	</li>
	<li <%If classifier="failed" Then%>class=selectTag<%End If%>>
		<a href="?c=failed">ʧ�ܶ���</a> 
	</li>
</ul>