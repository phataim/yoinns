<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<%
Dim order_id,paytype
order_id = Dream3CLS.RParam("order_id")
paytype = Dream3CLS.RParam("paytype")
%>

<div id="order_pay_dialog" >
	<p class="info">�������´򿪵�ҳ������ɸ��</p>
	<p class="notice">�������ǰ�벻Ҫ�رմ˴��ڡ�<br>��ɸ�����������������������İ�ť��</p>
	<p class="act">
	<input id="order-pay-dialog-succ" class="formbutton" value="����ɸ���" type="submit" onclick="location.href= 'pay.asp?order_id=<%=order_id%>&paytype=<%=paytype%>&paytip=pay';" />&nbsp;&nbsp;&nbsp;
	<input id="order-pay-dialog-fail" class="formbutton" value="������������" type="submit" onclick="location.href= 'pay.asp?order_id=<%=order_id%>&paytype=<%=paytype%>&paytip=unpay';" />
	</p>
	<p class="retry"><a href="<%=VirtualPath%>/check.asp?id=<%=order_id%>">&raquo;����ѡ������֧����ʽ</a></p>
</div>