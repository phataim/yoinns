<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_static.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<%
Dim Action
Dim Rs,Sql


Dim userid,product_id , order_id
Dim username,order_realname,order_email,checkintype_display,checkindays,totalmoney,reserve,order_state
Dim order_status_display,order_create_time,order_mobile , order_payway,service,order_pay_time , order_start_time,order_end_time, remark
Dim htitle,hotelname,hid
Action = Request("act")

Select Case Action
	Case "refund"
		Call Refund()
	Case Else
		Call Main()
End Select

Sub Main()		
	
		order_id = Dream3CLS.ChkNumeric(Request("id"))
		Sql = "Select * From T_Order Where id="&order_id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			Response.End()
		End If
		
		user_id = Rs("user_id")
		product_id = Rs("product_id")
		orderState= Rs("state")
		totalmoney = CDBL(Rs("totalmoney"))
		checkindays = Rs("checkindays")
		reserve = Rs("reserve")
		order_state = Rs("state")
		order_create_time = Rs("create_time")
		order_start_time=Rs("start_date")
		order_end_time=Rs("end_date")
		order_mobile = Rs("mobile")
		order_email = Rs("email")
		order_realname = Rs("realname")
		order_pay_time = Rs("pay_time")
		service = Rs("service")
		checkintype= Rs("checkintype")
		
		sql = "select * from t_product where id="&product_id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Dream3CLS.showMsg "您要查询的信息不存在！","S","error.asp"
			Response.End()
		End If
		htitle=Rs("housetitle")
		hid=Rs("hid")
		sql2="select * from T_hotel where h_id="&hid
		Set Rs2 = Dream3CLS.Exec(Sql2)
		If Rs2.EOF Then
			Dream3CLS.showMsg "您要查询的信息不存在！","S","error.asp"
			Response.End()
		End If
		hotelname=Rs2("h_hotelname")
		
		Set rs2=nothing
		
		Set rs = nothing
		
		Select Case checkintype
			Case "perDay"	
				checkintype_display = "日租"
			Case "perWeek"	
				checkintype_display = "周租"
			Case "perMonth"	
				checkintype_display = "月租"
		End Select
		
		Select Case order_state
			Case "unconfirm"
				order_status_display = "待确认"
			Case "unpay"
				order_status_display = "待付款"
			Case "pay"
				order_status_display = "已完成"
			Case "lodgercancel"
				order_status_display = "房客取消"
			Case "ownercancel"
				order_status_display = "房东取消"
			Case "failed"
				order_status_display = "失败"
		End Select
		
		Select Case service
			Case "cash"
				order_payway = "线下现金支付"
			Case "yeepay"
				order_payway = "易宝支付"
			Case "alipay"
				order_payway = "支付宝支付"
			Case "chinabank"
				order_payway = "网银在线支付"
			Case "tenpay"
				order_payway = "财付通支付"
			Case Else
				order_payway = "未定义支付"
		End Select

		
		Set userRs = Dream3Product.GetUserById(user_id)
		username = userRs("username")
		email = userRs("email")
		
		Set productRs = Dream3Product.GetProductById(product_id)
		housetitle = productRs("housetitle")
		
		
		
		
	
		
End Sub

	
	Sub Refund()
		
		refundType = Dream3CLS.RParam("refund")
		
		order_id = Dream3CLS.ChkNumeric(Request("id"))
		If refundType = "" Then 
			gMsgFlag = "E"
			gMsgArr = "请选择退款方式"
			Call Main()
			Exit Sub
		End If

		'退款到其账户
		Sql = "Select * From T_Order Where id="&order_id
		Rs.Open Sql,Conn,1,2
		If Rs("state") <> "pay" then
			gMsgFlag = "E"
			gMsgArr = "只有支付的订单才能退款"
			Call Main()
			Exit Sub
		End If
	
		
		If refundType = "manual" Then
			
			user_id = Rs("user_id")
			product_id = Rs("product_id")
			totalmoney = Rs("totalmoney")
			order_no = Rs("order_No")
			Rs("state") = "refund"
			Rs("pay_time") = null
			Rs.Update
			Rs.Close
			Set Rs = Nothing
			Dream3Product.WriteToFinRecord user_id,Session("_UserID"),product_id,order_no,"income","manualrefund",totalmoney
			'记日志
			
		End If
		
		
		gMsgFlag = "S"
		gMsgArr = "退款成功"
		Call Main()
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="../../common/js/tools.js"></script>

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">订单详情</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">

					
				<div class="sect">
					<table align="center" width="96%" class="coupons-table">
		<tbody>
		
		<tr><td><b>房间标题：</b></td><td ><a href="<%=VirtualPath%>/detail.asp?pid=<%=product_id%>" target=_blank><%=htitle%></a></td>
		    <td><b>所属酒店：</b></td><td><a href="<%=VirtualPath%>/show.asp?hid=<%=hid%>" target="_blank"><%=hotelname%></a></td></tr>
		<tr>
			<td><b>租用类型：</b></td><td><%=checkintype_display%></td>
			<td><b>入住天数：</b></td><td><%=checkindays%>天</td>
		</tr>
		<tr>
			<td><b>总金额：</b></td><td><%=totalmoney%></td>
			<td><b>定金：</b></td><td><%=reserve%>元</td>
		</tr>
		<tr>
			<td><b>订单状态：</b></td><td><font color="red"><%=order_status_display%></font></td>
			<td><b></b></td><td></td>
		</tr>
		<%If order_state="pay" Then%>
		<tr>
		<td><b>付款明细：</b></td>
		<td colspan="3"><%=order_payway%><font color="red"><b><%=totalmoney%></b></font> 元&nbsp;</td>
		</tr>
		<%End If%>
		<tr>
			<td><b>订单时间：</b></td><td><%=order_create_time%></td>
			<td><b>支付时间：</b></td><td><%=order_pay_time%></td>
			
			<!--以下内容为霸爷新增-->
			<br>
			
		</tr>
		<TR>
			<td><b></BR>入住日期：</b></td><td><%=order_start_time%></td>
			<td><b>退房日期：</b></td><td><%=order_end_time%></td>	
		</TR>

		
		<tr>
		<th colspan="4"><hr></th>
		</tr>
		<tr>
			<td width="15%"><b>用户名：</b></td><td><%=order_realname%></td>
			<td width="15%"><b>Email：</b></td><td><%=order_email%></td>
		</tr>
		<tr><td><b>手机号码：</b></td><td><%=order_mobile%> </td></tr>
		
		<tr><td><b>订单附言：</b></td><td><%=remark%></td></tr>
		
		<%If order_state="pay" Then%>
		
		<form method="post" action="orderDetail.asp">
		<tr><th colspan="4"><hr></th>
		</tr><tr><td><b>退款处理：</b></td><td>
		<select id="order-dialog-refund-id" name="refund">
			<option selected="" value="">请选择退款方式</option>
			<option value="manual">通过人工方式已退款</option>
		</select>&nbsp;
		
		<input type="hidden" name="act" value="refund"/>
		<input type="hidden" name="id" value="<%=order_id%>"/>
		
		<input type="submit" value="确定"></td></tr>
		</form>
		<%End If%>
	</tbody></table>
		</div>
				

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->