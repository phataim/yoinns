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
	<li><a class="qq" title="�����ŵ�msn/qq" href="#" onClick="copyShareToClipboard('<%=s_title%><%=share_ori_url%>');"></a></li>
	<li><a class="sina" title="�����ŵ�����" href="<%=share_sina%>" target="_blank"></a></li>
	<li><a class="kaixin" title="�����ŵ�������" href="<%=share_kaixin%>" target="_blank"></a></li>
	<li><a class="renren" title="�����ŵ�������" href="<%=share_renren%>" target="_blank"></a></li>
	<li><a class="douban" title="�����ŵ�����" href="<%=share_douban%>" target="_blank"></a></li>
	<li><a class="email" title="�����ŵ�E-mail" href="<%=share_email%>" target="_blank"></a></li>
</ul>
<script type="text/javascript">
function copyShareToClipboard(txt) 
{ 
window.clipboardData.setData('text', txt); 
alert("��ַ�Ѹ��Ƶ������壡");
} 

</script>
<%
End Sub
%>