<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<%
Dim Action
Dim email,username,realname,qq,password,zipcode,address,mobile,validcode,manager,paytype
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
		paytype =  Dream3CLS.RParam("paytype")

		'validate Form
		If Not Dream3CLS.isInteger(money)  Then
			gMsgArr = "������Ϸ���������"
			gMsgFlag = "E"
			Call ShowEdit()
			Exit Sub
		End If

		If paytype = 1 Then	
			money = - money
			s_direction = "expense"
			s_msg = "�ۿ�ɹ�"
		Else
			s_direction = "income"
			s_msg = "��ֵ�ɹ�"
		End If
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_User Where id="&pid
		
		Rs.open Sql,conn,1,2
		Rs("money") = CDBL(Rs("money")) + money
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		't("dd")
		'gMsgFlag = "S"
		'��¼��T_Fin_Record ,����Ҫ�����ϵ�ǰ��¼�˵�session��id��Ŀǰ��ʱ��0����
		'(f_user_id,f_admin_id,f_detail_id,f_direction,f_action,f_money)
		
		
		Dream3Team.WriteToFinRecord pid,session("_UserID"),0,s_direction,"store",money
		Dream3CLS.showMsg s_msg,"S","index.asp"
		
	End Sub
	
	Sub ShowEdit()	
		'operate = "�޸�"
		pid = Dream3CLS.ChkNumeric(Request("pid"))
		sql = "select * from T_User Where id="&pid
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
			response.End()
		End If
		email = Rs("email")
		username = Rs("username")
		realname = Rs("realname")
		qq = Rs("qq")
		zipcode = Rs("zipcode")
		address = Rs("address")
		mobile = Rs("mobile")
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

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">�û�����</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">

                <div class="sect">
                    <form method="post" action="userDetail.asp?act=save" onsubmit="return ">
						<div class="field">
                            <label>�û�Email��</label><%=email%>
						</div>
						<div class="field">
                            <label>�û�����</label><%=username%>
                        </div>
						<div class="field">
                            <label>��ʵ������</label><%=realname%>
                        </div>
						<div class="field">
                            <label>QQ���룺</label><%=qq%>
                        </div>
                        
                        <div class="field">
                            <label>�������룺</label><%=zipcode%>
                        </div>
                        <div class="field">
                            <label>���͵�ַ��</label><%=address%>
						</div>
                        <div class="field">
                            <label>�ֻ����룺</label><%=mobile%>
						</div>
						<div class="field" style="display:none ">
                            <label>�˻���ֵ��</label>
							
							<input type="text" size="30" name="money" id="money" class="number" value="<%=money%>" maxlength="8" onkeypress="NumericKeyPress(8,0)" onkeyup="NumericKeyUp(8,0)"
 onblur="NumericKeyUp(8,0)" /><select name="paytype">
                              <option value="0" <%If paytype="0" then response.Write("selected") %>>��ֵ</option>
							  <option value="1" <%If paytype="1" then response.Write("selected") %>>�ۿ�</option>
                            </select> 
                        </div>
						
						<div class="act" style="display:none ">
							<input type="hidden" name="pid" value="<%=pid%>"/>
                            <input type="submit" value="ȷ��" name="commit" id="user-submit" class="formbutton" onclick="return window.confirm('��ȷ��Ҫ�����˻���ֵ?')"/>
                        </div>
                    </form>
                </div>

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->