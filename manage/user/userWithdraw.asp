<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<%
Dim Action
Dim email,username,realname,qq,password,zipcode,address,mobile,validcode,manager,user_money
Dim money
Dim pid

	Action = Request.QueryString("act")
	Select Case Action
		Case "save"
			Call SaveRecord()
		Case "showAdd"
			Call Main()
		Case "showEdit"
			Call ShowEdit()
		Case Else
				Call Main()
	End Select
	
	Sub SaveRecord()
	
		pid = Dream3CLS.RParam("pid")
		money =  Dream3CLS.RParam("money")
		
		'validate Form
		If Not Dream3CLS.isInteger(money)  Then
			gMsgArr = "������Ϸ���������"
			gMsgFlag = "E"
			Call ShowEdit()
			Exit Sub
		End If


		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_User Where id="&pid
		
		Rs.open Sql,conn,1,2
		
		If money > CDBL(Rs("money")) then
			gMsgArr = "������Ľ������û����˻���"
			gMsgFlag = "E"
			Rs.Close
			Set Rs = Nothing
			Call ShowEdit()
			Exit Sub
		End If
		
		Rs("money") = CDBL(Rs("money")) - money
		Rs.Update
		Rs.Close
		Set Rs = Nothing

		'��¼��T_Fin_Record ,����Ҫ�����ϵ�ǰ��¼�˵�session��id��Ŀǰ��ʱ��0����
		Dream3Team.WriteToFinRecord pid,session("_UserID"),0,"income","withdraw", money
		Dream3CLS.showMsg "�˻��۳��ɹ�����ȷ����ͨ���ֹ���ʽ���ͻ��˿","S","index.asp"
		
	End Sub
	
	Sub ShowEdit()	
		'operate = "�޸�"
		pid = Dream3CLS.ChkNumeric(Request("pid"))
		sql = "select * from T_User Where id="&pid
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ����û���",0,"0")
			response.End()
		End If
		email = Rs("email")
		username = Rs("username")
		realname = Rs("realname")
		qq = Rs("qq")
		zipcode = Rs("zipcode")
		address = Rs("address")
		mobile = Rs("mobile")
		user_money = Rs("money")
		money = 0
	
	End Sub

	
	Sub Main()	
	
		money = 0

	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="../../common/js/tools.js"></script>
<div id="box">
<div class="clear mainwide" id="content">
        <div class="clear box">
            
            <div class="box-content">
                <div class="head"><h2>�û�����</h2></div>
                <div class="sect">
                    <form method="post" action="?act=save" onsubmit="return ">
						<div class="field">
                            <label>�û���</label><%=username%>
                        </div>
						<div class="field">
                            <label>�˻����</label><%=user_money%>Ԫ
						</div>
						<div class="field">
                            <label>�ֻ�����</label><%=mobile%>
						</div>
						<div class="field">
                            <label>�û�Email</label><%=email%>
						</div>
						<div class="field">
                            <label>��ʵ����</label><%=realname%>
                        </div>
						<div class="field">
                            <label>QQ����</label><%=qq%>
                        </div>
                        
                        <div class="field">
                            <label>��������</label><%=zipcode%>
                        </div>
                        <div class="field">
                            <label>���͵�ַ</label><%=address%>
						</div>
                        
						<div class="field">
                            <label>���ֽ��</label>
                            <input type="text" size="30" name="money" id="money" class="number" value="<%=money%>" maxlength="8" onkeypress="NumericKeyPress(8,0)" onkeyup="NumericKeyUp(8,0)"
 onblur="NumericKeyUp(8,0)" /> �벻Ҫ����<%=user_money%>Ԫ
                        </div>
						
						<div class="act">
							<input type="hidden" name="pid" value="<%=pid%>"/>
                            <input type="submit" value="ȷ��" name="commit" id="user-submit" class="formbutton" onclick="return window.confirm('��ȷ��Ҫ�����˻��۳��ý����?')"/>
                        </div>
                    </form>
                </div>
            </div>
	</div>
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->