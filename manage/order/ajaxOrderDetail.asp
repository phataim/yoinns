<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_team.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<%
Dim Action
Dim Rs,Sql
Dim order_id
Dim quantity,orderState,realname,ordermobile,orderaddress,create_time,remark,express
Dim credit,origin,money,service
Dim user_id,username,email
Dim team_id,title
Dim express_id,express_no

	Action = Request("act")
	Select Case Action
		Case Else
				Call Main()
	End Select
	
	
	
	Sub Main()	
		order_id = Dream3CLS.ChkNumeric(Request("id"))
		Sql = "Select * From T_Order Where id="&order_id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
			Response.End()
		End If
		
		user_id = Rs("user_id")
		team_id = Rs("team_id")
		quantity = Rs("quantity")
		orderState= Rs("state")
		realname = Rs("realname")
		ordermobile = Rs("mobile")
		orderaddress = Rs("address")
		create_time = Rs("create_time")
		remark = Rs("remark")
		express = Rs("express")
		credit = CDBL(Rs("credit"))
		origin = CDBL(Rs("origin"))
		money = CDBL(Rs("money"))
		express_id = Dream3CLS.ChkNumeric(Rs("express_id"))
		express_no = Rs("express_no")
		service = Rs("service")
		
		Set userRs = Dream3Team.GetUserById(user_id)
		username = userRs("username")
		email = userRs("email")
		
		Set teamRs = Dream3Team.GetTeamById(team_id)
		title = teamRs("title")
		
	End Sub
%>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<div  id="content">
        <div class="clear box">
            
            <div>
					
				<div class="sect">
					<table align="left"  class="coupons-table">
		<tbody><tr><td width="80"><b>�û�����</b></td><td><%=username%></td></tr>
		<tr><td><b>Email��</b></td><td><%=email%></td></tr>
		<tr><td><b>�Ź���Ŀ��</b></td><td><%=title%> </td></tr>
		<tr><td><b>����������</b></td><td><%=quantity%></td></tr>
		<tr><td><b>����״̬��</b></td><td><font color="red"><%If orderState="pay" Then%>�Ѹ���<%Else%>δ����<%End if%></font></td></tr>
		<tr>
		<td><b>������ϸ��</b></td>
		<td>
		<%If credit<> 0 Then%>
		���֧�� <b><%=credit%></b> Ԫ&nbsp;
		<%End If%>
		<%
		If money<> 0 Then
			Select Case service
				Case "cash"
					payway = "����֧��"
				Case "yeepay"
					payway = "�ױ�֧��"
				Case "alipay"
					payway = "֧����֧��"
				Case "chinabank"
					payway = "��������֧��"
				Case "tenpay"
					payway = "�Ƹ�֧ͨ��"
				Case Else
					payway = "δ����֧��"
			End Select
		%>
		 <%=payway%><b><%=money%></b> Ԫ&nbsp;
		<%End If%>
		</td>
		</tr>
		<tr><td><b>����ʱ�䣺</b></td><td><%=create_time%></td></tr>

		
		<tr>
		<th colspan="2"><hr></th>
		</tr>
		<%If express = "Y" Then%>
		<tr><td width="80"><b>�ռ��ˣ�</b></td><td><%=realname%></td></tr>
		<%End If%>
		<tr><td><b>�ֻ����룺</b></td><td><%=ordermobile%> </td></tr>
		<%If express = "Y" Then%>
		<tr><td><b>�ռ���ַ��</b></td><td><%=orderaddress%></td></tr>
		<%End If%>
		<tr><td><b>�������ԣ�</b></td><td><%=remark%></td></tr>
		
		

	
	</tbody></table>
				</div>
				
            </div>
            
        </div>
	</div>