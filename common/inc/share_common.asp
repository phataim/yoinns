<%
Sub GetShare(s_team_id,s_title,s_content)
share_title = Server.URLEncode(s_title)
share_content = Server.URLEncode(s_content)
share_ori_url = GSiteURL&"team.asp?id="&s_team_id
share_url = Server.URLEncode(share_ori_url)
utf_8_title = Dream3CLS.encodeUrl(s_title,936,65001)
share_kaixin = "http://www.kaixin001.com/repaste/share.php?rurl="&share_url&"&rtitle="&utf_8_title&"&rcontent="&share_url
share_renren = "http://share.renren.com/share/buttonshare.do?link="&share_url&"&title="&utf_8_title
share_douban = "http://www.douban.com/recommend/?url="&share_url&"&title="&utf_8_title
share_sina = "http://v.t.sina.com.cn/share/share.php?url="&share_url&"&title="&share_title
share_email = "mailto:?subject="&share_title&"&body="&s_content
%>
<ul>
	<li><a class="qq" title="分享本团到msn/qq" href="#" onClick="copyShareToClipboard('<%=s_title%><%=share_ori_url%>');"></a></li>
	<li><a class="sina" title="分享本团到新浪" href="<%=share_sina%>" target="_blank"></a></li>
	<li><a class="kaixin" title="分享本团到开心网" href="<%=share_kaixin%>" target="_blank"></a></li>
	<li><a class="renren" title="分享本团到人人网" href="<%=share_renren%>" target="_blank"></a></li>
	<li><a class="douban" title="分享本团到豆瓣" href="<%=share_douban%>" target="_blank"></a></li>
	<li><a class="email" title="分享本团到E-mail" href="<%=share_email%>" target="_blank"></a></li>
</ul>
<script type="text/javascript">
function copyShareToClipboard(txt) 
{ 
window.clipboardData.setData('text', txt); 
alert("地址已复制到剪贴板！");
} 

</script>
<%
End Sub
%>