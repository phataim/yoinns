<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->
<!--#include file="onlinepay/OnlinePaycode.asp"-->
<!--#include file="common/api/cls_tpl.asp"-->
<!--#include file="common/api/cls_sms.asp"-->
<!--#include file="common/api/cls_xml.asp"-->

<%
'--------��ֹ����------------  
Response.Expires   =   -1   
Response.ExpiresAbsolute   =   Now()   -   1   
Response.cachecontrol   =   "no-cache"   
%>

<%
Dim OnlineNumber
OnlineNumber = 123
out_trade_no = "12061610535904"
r3_Amt = 666
SetOrderState out_trade_no,"yeepay",OnlineNumber,CDBL(r3_Amt)
Set tRs = Dream3product.GetOrderByOrderNo(out_trade_no)
UpdateProductState(tRs("product_id"))
response.Write("success")
	
%>
	
	

<!--#include file="common/inc/header_user.asp"-->
<title><%=Dream3CLS.SiteConfig("SiteName")%>-ȷ�϶���</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="content_wrapper">
	
    <div class="yuding_box">
        
        <div class="part1_bg">
            <ul>
                <li class="num_01"><h2>�ͷ�Ԥ��</h2></li>
                <li class="num_07"><h2>֧������</h2></li>
                <li class="num_08"><h2>���</h2></li>
            </ul>
        </div>
        
        <div class="line_one"></div>
        
        <div class="success"><h2>��Ķ�����֧���ɹ��ˣ�</h2> </div>
        
        <div class="line_one"></div>
        
        <p class="Order_details">����������Ĳ鿴 <a href="#">��������</a> ��</p>
        
        
        
    </div>
    
</div>

<!--#include file="common/inc/footer_user.asp"-->