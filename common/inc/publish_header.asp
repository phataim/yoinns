<%
Sql = "Select * From T_User Where id = "&session("_UserID")
Set Rs = Dream3CLS.Exec(Sql)
face = Rs("face")
%>
<div class="layer1">
	<div class="top-side"></div>
	<div class="center-side">
		<dl>
			<dt><img width="119" head="119" src="<%If IsNull(face) or face="" Then response.Write(VirtualPath&"/images/noimage.gif") else response.Write(face)%>"></dt>
			<dd class="tit1"></dd>
			<dd class="txt1">��<%=Dream3CLS.SiteConfig("SiteShortName")%>���ⷢ�����ķ��䣬�����Զ������ţ����ڼ������Ǯ!</dd>
		</dl>
		<div class="clear"></div>
	</div>
	<div class="bottom-side"></div>
</div>