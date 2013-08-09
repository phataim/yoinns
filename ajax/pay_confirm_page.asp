<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<%
Dim order_id,paytype
order_id = Dream3CLS.RParam("order_id")
paytype = Dream3CLS.RParam("paytype")
%>

<div id="order_pay_dialog" >
	<p class="info">请您在新打开的页面上完成付款。</p>
	<p class="notice">付款完成前请不要关闭此窗口。<br>完成付款后请根据您的情况点击下面的按钮：</p>
	<p class="act">
	<input id="order-pay-dialog-succ" class="formbutton" value="已完成付款" type="submit" onclick="location.href= 'pay.asp?order_id=<%=order_id%>&paytype=<%=paytype%>&paytip=pay';" />&nbsp;&nbsp;&nbsp;
	<input id="order-pay-dialog-fail" class="formbutton" value="付款遇到问题" type="submit" onclick="location.href= 'pay.asp?order_id=<%=order_id%>&paytype=<%=paytype%>&paytip=unpay';" />
	</p>
	<p class="retry"><a href="<%=VirtualPath%>/check.asp?id=<%=order_id%>">&raquo;返回选择其他支付方式</a></p>
</div>