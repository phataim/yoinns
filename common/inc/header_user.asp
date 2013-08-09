<%
Dim cookiesUserID
't(Request.Cookies(DREAM3C)("_UserID"))
If Session("_UserID") = "" AND Request.Cookies(DREAM3C)("_UserID")<>"" Then
	ReLogin()
End If
%>

<%
Dim curUrl ,curPageArr,curPage,arrCount,detailUrl,paramUrl
curFullUrl = CStr(Request.ServerVariables("SCRIPT_NAME"))
curPageArr = split(curFullUrl,"/")
arrCount = UBOUND(curPageArr)
curUrl = curPageArr(arrCount-1)
detailUrl = curPageArr(arrCount)
paramUrl = request.querystring

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<!--
	哈哈，在审查我们网站的代码吧？
	别审查了，看不出来的。
	哈哈哈哈。
	欢迎加入程序猿的世界。
	我们公司希望有着更多的高手加入喔！！
	p.s
	    同时也要运营高手！！！
	    快给我们推荐人，或自荐！！
	-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>
<%If G_Title_Content="" Then
G_Title_Content = Dream3CLS.SiteConfig("SiteName")&"-"&Dream3CLS.SiteConfig("SiteTitle")&"|短租|出租"
End If
Response.Write(G_Title_Content)
%>
</title>
<meta name="keywords" content="<%If G_Keywords_Content="" Then
G_Keywords_Content = Dream3CLS.SiteConfig("SiteName")&"-"&Dream3CLS.SiteConfig("SiteTitle")&"|短租|出租"
End If
Response.Write(G_Keywords_Content)
%>" />

<meta name="description" content="<%If G_Description_Content="" Then
G_Description_Content = Dream3CLS.SiteConfig("SiteName")&"-"&Dream3CLS.SiteConfig("SiteTitle")&"|短租|出租"
End If
Response.Write(G_Description_Content)
%>" />

<!--<link href="<%=VirtualPath%>/common/themes/<%=Dream3CLS.SiteConfig("DefaultSiteStyle")%>/css.css" rel="stylesheet" type="text/css" />-->
<!--<link href="<%=VirtualPath%>/common/themes/<%=Dream3CLS.SiteConfig("DefaultSiteStyle")%>/style.css" rel="stylesheet" type="text/css" />-->

<link href="<%=VirtualPath%>/common/themes/Default/style.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="<%=VirtualPath%>/common/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="<%=VirtualPath%>/common/js/common.js"></script>
<script type="text/javascript" src="<%=VirtualPath%>/common/calender/WdatePicker.js"></script>

</head>



<div class="mainnav">
	<div class="mainnav_wrap">
    	<div class="logo">
        <h2>有旅馆-专注广州大学城 </h2>
        <a href="<%=VirtualPath%>/index.asp" title="有旅馆-专注大学城住宿"><img src="<%=VirtualPath%>/common/themes/<%=Dream3CLS.SiteConfig("DefaultSiteStyle")%>/img/logo.jpg" width="160" height="52" alt="有旅馆-专注大学城住宿" /></a>
    	</div>
		<!--<a href="<%=VirtualPath%>/publish.asp"><h4>免费发布房间</h4></a> -->
        <ul>
			<%If Session("_UserID") = "" Then%>
				<!--<li><a href="<%=VirtualPath%>/user/account/signup.asp">注册</a></li>-->
				<li><a href="javascript:void(0)" onclick="load_regist('')">注册</a></li>
				<li>｜</li>
				<li><a href="<%=VirtualPath%>/user/account/companysignup.asp"><strong>商家注册</strong></a></li>
				<li>｜</li>
				<li><a href="javascript:void(0)" onclick="load_login('')">登录</a></li>
				<!--<li><a href="<%=VirtualPath%>/user/account/login.asp">登陆</a></li>-->
			<%Else%>
					
					<li>您好：<a href="<%=VirtualPath%>/user/account/setting.asp"><%=Session("_UserName")%></a></li>
				
				<li>｜</li>
				<li><a href="<%=VirtualPath%>/user/account/logout.asp">退出</a></li>
			<%End If%>
			<li>｜</li>
            
            <li><a href="/help/index.asp?c=question" target=_blank>如何使用</a></li>
            <li>｜</li>
            <!--
            <li><a href="javascript:window.external.AddFavorite('http://www.yoinns.com', '“有旅馆-专注广州大学城住宿|酒店|租房”')" target="_self" ><strong>加入收藏</strong></a></li>
            -->
            <li><iframe style="line-height: 18px;margin-bottom:-6px;" src="http://widget.weibo.com/relationship/followbutton.php?language=zh_cn&amp;width=230&amp;height=24&amp;uid=2956010022&amp;style=1&amp;btn=red&amp;dpc=1" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" width="70" height="22"></iframe></li>
        </ul>
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
