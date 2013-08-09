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
			gMsgArr = "请输入合法的整数！"
			gMsgFlag = "E"
			Call ShowEdit()
			Exit Sub
		End If

		If paytype = 1 Then	
			money = - money
			s_direction = "expense"
			s_msg = "扣款成功"
		Else
			s_direction = "income"
			s_msg = "充值成功"
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
		'记录到T_Fin_Record ,这里要补充上当前登录人的session的id，目前暂时用0代替
		'(f_user_id,f_admin_id,f_detail_id,f_direction,f_action,f_money)
		
		
		Dream3Team.WriteToFinRecord pid,session("_UserID"),0,s_direction,"store",money
		Dream3CLS.showMsg s_msg,"S","index.asp"
		
	End Sub
	
	Sub ShowEdit()	
		'operate = "修改"
		pid = Dream3CLS.ChkNumeric(Request("pid"))
		sql = "select * from T_User Where id="&pid
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
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
	<div class="PageTitle"><span class="fl">用户详情</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">

                <div class="sect">
                    <form method="post" action="userDetail.asp?act=save" onsubmit="return ">
						<div class="field">
                            <label>用户Email：</label><%=email%>
						</div>
						<div class="field">
                            <label>用户名：</label><%=username%>
                        </div>
						<div class="field">
                            <label>真实姓名：</label><%=realname%>
                        </div>
						<div class="field">
                            <label>QQ号码：</label><%=qq%>
                        </div>
                        
                        <div class="field">
                            <label>邮政编码：</label><%=zipcode%>
                        </div>
                        <div class="field">
                            <label>配送地址：</label><%=address%>
						</div>
                        <div class="field">
                            <label>手机号码：</label><%=mobile%>
						</div>
						<div class="field" style="display:none ">
                            <label>账户充值：</label>
							
							<input type="text" size="30" name="money" id="money" class="number" value="<%=money%>" maxlength="8" onkeypress="NumericKeyPress(8,0)" onkeyup="NumericKeyUp(8,0)"
 onblur="NumericKeyUp(8,0)" /><select name="paytype">
                              <option value="0" <%If paytype="0" then response.Write("selected") %>>充值</option>
							  <option value="1" <%If paytype="1" then response.Write("selected") %>>扣款</option>
                            </select> 
                        </div>
						
						<div class="act" style="display:none ">
							<input type="hidden" name="pid" value="<%=pid%>"/>
                            <input type="submit" value="确认" name="commit" id="user-submit" class="formbutton" onclick="return window.confirm('您确定要给该账户充值?')"/>
                        </div>
                    </form>
                </div>

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->