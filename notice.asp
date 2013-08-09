
<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->
<!--#include file="common/inc/city_common.asp"-->
<!--#include file="common/inc/index_ad_show.asp"-->
<!--#include file="common/api/cls_quartz.asp"-->



<%

        m_id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		
		Sql = "Select * from T_notice Where m_id="&m_id
		
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			response.Redirect("error.html")
			Response.End()
		End If
	%>	
		
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<html>
<head>
<meta name="keywords" content="有旅馆,大学城住宿,广州大学城网上订房"

</head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=rs("m_title")%></title>
<body>
<style>
.title{ width:800 font-family:"微软雅黑"; font-size:24px; color:#666666;}
.k{height:auto; width:800; color:#666666; margin-left:250; margin-left:250; font-size:15px; color:#666666; font-family:"微软雅黑"; background-color:#F9F9F9; }
.k2{height:auto; width:800; color:#666666; margin-left:250; margin-left:250; font-size:12px; color:#666666; font-family:"微软雅黑"}
.height{height:100; margin-left:250}
a:link { text-decoration: none; color: blue}
p{text-indent:2em}
</style>



<div class="mayi_wrapper" >
<div class="k" >
<h1 align="center" ><%=rs("m_title")%></h1>
 <%=rs("m_content")%>
</div>
<div class="height"></div>
<!--#include file="common/inc/footer_user.asp"-->

</body>
</html>

