
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=Dream3CLS.SiteConfig("SiteName")%>-�����̨</title>
<link href="<%=VirtualPath%>/common/static/style/iframe.css" rel="stylesheet" type="text/css" />
</head>

<%
'--------��ֹ����------------  
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

<div id="top_logo">
    <div id="logo"></div>
    <div id="logoCenterBG"></div>
    <div id="logoRightEditor">
    	<span>��ӭ����<b> <%=session("_UserName")%></b>��<a href="../logout.asp">��ȫ�˳�</a>! �����ǣ�<%=Dream3CLS.Formatdate(now(),7)%></span>
    </div>
</div>

<div class="nav">
    <ul id="navTxt" class="navTxt">  
       
		<li class="navLi1 <%if("main"=curUrl) then response.Write("default")%>"><a href="<%=VirtualPath%>/manage/main/index.asp"><b class="navLi-Lbg"></b><span>��ҳ</span><b class="navLi-Rbg"></b></a></li>
		<li class="navLi1 <%if("system"=curUrl) then response.Write("default")%>"><a href="<%=VirtualPath%>/manage/system/index.asp"><b class="navLi-Lbg"></b><span>��վ����</span><b class="navLi-Rbg"></b></a></li>
		<li class="navLi1 <%if("product"=curUrl) then response.Write("default")%>"><a href="<%=VirtualPath%>/manage/product/index.asp?classifier=auditing"><b class="navLi-Lbg"></b><span>��Դ����</span><b class="navLi-Rbg"></b></a></li>
		<li class="navLi1 <%if("user"=curUrl) then response.Write("default")%>"><a href="<%=VirtualPath%>/manage/user/index.asp"><b class="navLi-Lbg"></b><span>�ͻ�����</span><b class="navLi-Rbg"></b></a></li>
		<li class="navLi1 <%if("order"=curUrl) then response.Write("default")%>"><a href="<%=VirtualPath%>/manage/order/index.asp?classifier=pay"><b class="navLi-Lbg"></b><span>��������</span><b class="navLi-Rbg"></b></a></li>
		<li class="navLi1 <%if("market"=curUrl) then response.Write("default")%>"><a href="<%=VirtualPath%>/manage/market/email.asp"><b class="navLi-Lbg"></b><span>Ӫ������</span><b class="navLi-Rbg"></b></a></li>
		<li class="navLi1 <%if("category"=curUrl) then response.Write("default")%>"><a href="<%=VirtualPath%>/manage/category/province.asp"><b class="navLi-Lbg"></b><span>������</span><b class="navLi-Rbg"></b></a></li>
		<li class="navLi1 <%if("finance"=curUrl) then response.Write("default")%>"><a href="<%=VirtualPath%>/manage/finance/finance.asp"><b class="navLi-Lbg"></b><span>���񱨱�</span><b class="navLi-Rbg"></b></a></li>
		<li class="navLi1 <%if("comments"=curUrl) then response.Write("default")%>"><a href="<%=VirtualPath%>/manage/comments/comments.asp"><b class="navLi-Lbg"></b><span>���۹���</span><b class="navLi-Rbg"></b></a></li>
		
    </ul>
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