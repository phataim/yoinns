<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=SiteConfig("SiteName")%>-商家后台</title>
<link href="<%=VirtualPath%>/common/static/style/css/admin.css" rel="stylesheet" type="text/css" />
</head>

<%
'--------禁止缓存------------  
Response.Expires   =   -1   
Response.ExpiresAbsolute   =   Now()   -   1   
Response.cachecontrol   =   "no-cache"   
%>

<%
Dim curUrl ,curPageArr,curPage,arrCount,detailUrl,paramUrl
curUrl = CStr(Request.ServerVariables("SCRIPT_NAME"))
curPageArr = split(curUrl,"/")
arrCount = UBOUND(curPageArr)
curUrl = curPageArr(arrCount-1)
detailUrl = curPageArr(arrCount)
paramUrl = request.querystring

%>

<div id="top">
	<div id="hd">
	
		<div id="logo">
			<a class="link" href="../../index.asp"><img src="<%=VirtualPath%>/images/logo/logo.jpg" /></a>
		</div>
		
		<div class="change_city">
			<div class="current_city" style="margin-top:10px;">
				<h3>商户后台管理</h3>
			</div>
		</div>
		
		<ul class="nav cf">
		<li <%if("team"=curUrl) then response.Write("class='current'")%>><a href="<%=VirtualPath%>/biz/team/index.asp">首页</a></li>
		<li <%if("settings"=curUrl) then response.Write("class='current'")%>><a href="<%=VirtualPath%>/biz/settings/index.asp">商户资料</a></li>
		<li <%if("coupon"=curUrl) then response.Write("class='current'")%>><a href="<%=VirtualPath%>/biz/coupon/index.asp">优惠券</a></li>
		<li <%if("ask"=curUrl) then response.Write("class='current'")%>><a href="<%=VirtualPath%>/biz/ask/index.asp">答疑</a></li>
		</ul>
		
		<div class="r Mlogout">
			<a href="<%=VirtualPath%>/biz/logout.asp">退出</a>
		</div>
				
	</div>
</div>

<%
Dim remoteMsgArr,remoteMsgFlag
remoteMsgArr = Request("gMessage")
remoteMsgFlag = Request("gMessageFlag")
If remoteMsgArr <> "" Then
	gMsgArr = remoteMsgArr
	gMsgFlag = remoteMsgFlag
End If

Call showMsg(gMsgArr,0)
%>
<div class="blank20"></div>