<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->

<%
'--------禁止缓存------------  
Response.Expires   =   -1   
Response.ExpiresAbsolute   =   Now()   -   1   
Response.cachecontrol   =   "no-cache"   
%>

<%
Dim Action
Dim order_Id 



Action = Request.QueryString("act")
Select Case Action
	Case "saveorder"
		Call SaveOrder()
	Case Else
		Call Main()
End Select



Sub Main()
		order_id = Dream3CLS.ChkNumeric(Request("order_id"))
		
		Sql = "Select Top 1 * from T_Order Where  id="&order_id
		Rs.open Sql,conn,1,2
			rs("state") = "pay"
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		
		'如果设置审核通过，则记录财务记录
		'If s_state = "normal" Then
			'SetOrderState o_order_no,o_pay_type,o_pay_id,o_money 
		'End If
End Sub
	
%>
	
	

<!--#include file="common/inc/header_user.asp"-->
<title><%=Dream3CLS.SiteConfig("SiteName")%>-确认订单</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="content_wrapper">
	
    <div class="yuding_box">
        
        <div class="part1_bg">
            <ul>
                <li class="num_01"><h2>客房预订</h2></li>
                <li class="num_07"><h2>支付定金</h2></li>
                <li class="num_08"><h2>完成</h2></li>
            </ul>
        </div>
        
        <div class="line_one"></div>
        
        <div class="success"><h2>你的订单，支付成功了！</h2> </div>
        
        <div class="line_one"></div>
        
        <p class="Order_details">进入个人中心查看 <a href="#">订单详情</a> ！</p>
        
        
        
    </div>
    
</div>

<!--#include file="common/inc/footer_user.asp"-->