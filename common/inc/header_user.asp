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
	�����������������վ�Ĵ���ɣ�
	������ˣ����������ġ�
	����������
	��ӭ�������Գ�����硣
	���ǹ�˾ϣ�����Ÿ���ĸ��ּ���ร���
	p.s
	    ͬʱҲҪ��Ӫ���֣�����
	    ��������Ƽ��ˣ����Լ�����
	-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>
<%If G_Title_Content="" Then
G_Title_Content = Dream3CLS.SiteConfig("SiteName")&"-"&Dream3CLS.SiteConfig("SiteTitle")&"|����|����"
End If
Response.Write(G_Title_Content)
%>
</title>
<meta name="keywords" content="<%If G_Keywords_Content="" Then
G_Keywords_Content = Dream3CLS.SiteConfig("SiteName")&"-"&Dream3CLS.SiteConfig("SiteTitle")&"|����|����"
End If
Response.Write(G_Keywords_Content)
%>" />

<meta name="description" content="<%If G_Description_Content="" Then
G_Description_Content = Dream3CLS.SiteConfig("SiteName")&"-"&Dream3CLS.SiteConfig("SiteTitle")&"|����|����"
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
        <h2>���ù�-רע���ݴ�ѧ�� </h2>
        <a href="<%=VirtualPath%>/index.asp" title="���ù�-רע��ѧ��ס��"><img src="<%=VirtualPath%>/common/themes/<%=Dream3CLS.SiteConfig("DefaultSiteStyle")%>/img/logo.jpg" width="160" height="52" alt="���ù�-רע��ѧ��ס��" /></a>
    	</div>
		<!--<a href="<%=VirtualPath%>/publish.asp"><h4>��ѷ�������</h4></a> -->
        <ul>
			<%If Session("_UserID") = "" Then%>
				<!--<li><a href="<%=VirtualPath%>/user/account/signup.asp">ע��</a></li>-->
				<li><a href="javascript:void(0)" onclick="load_regist('')">ע��</a></li>
				<li>��</li>
				<li><a href="<%=VirtualPath%>/user/account/companysignup.asp"><strong>�̼�ע��</strong></a></li>
				<li>��</li>
				<li><a href="javascript:void(0)" onclick="load_login('')">��¼</a></li>
				<!--<li><a href="<%=VirtualPath%>/user/account/login.asp">��½</a></li>-->
			<%Else%>
					
					<li>���ã�<a href="<%=VirtualPath%>/user/account/setting.asp"><%=Session("_UserName")%></a></li>
				
				<li>��</li>
				<li><a href="<%=VirtualPath%>/user/account/logout.asp">�˳�</a></li>
			<%End If%>
			<li>��</li>
            
            <li><a href="/help/index.asp?c=question" target=_blank>���ʹ��</a></li>
            <li>��</li>
            <!--
            <li><a href="javascript:window.external.AddFavorite('http://www.yoinns.com', '�����ù�-רע���ݴ�ѧ��ס��|�Ƶ�|�ⷿ��')" target="_self" ><strong>�����ղ�</strong></a></li>
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
