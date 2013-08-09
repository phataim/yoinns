<%
Sub Index_AD_Show()
%>
<div id="fcbx">
	<ul id="fcimg">     
		<%
		sql = "select * from t_ad where enabled='Y' order by seqno desc"
		Set Rs = Dream3CLS.Exec(sql)
		Do While Not Rs.EOF 
			s_image =  Dream3Product.FilterContentImage(Rs("image"))
			s_image = GetSiteUrl & "/" & s_image
			s_title = Rs("title")
			s_url = Rs("url")
		%>
		</item>
		<li><a href="<%=s_url%>"><img src="<%=s_image%>" width="740" height="230" border="0"/></a></li>
		<%
			Rs.Movenext
		Loop
		%> 
	</ul> 
</div>
<%
End Sub
%>