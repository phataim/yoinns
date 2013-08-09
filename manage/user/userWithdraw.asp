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
			gMsgArr = "请输入合法的整数！"
			gMsgFlag = "E"
			Call ShowEdit()
			Exit Sub
		End If


		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_User Where id="&pid
		
		Rs.open Sql,conn,1,2
		
		If money > CDBL(Rs("money")) then
			gMsgArr = "您输入的金额大于用户的账户！"
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

		'记录到T_Fin_Record ,这里要补充上当前登录人的session的id，目前暂时用0代替
		Dream3Team.WriteToFinRecord pid,session("_UserID"),0,"income","withdraw", money
		Dream3CLS.showMsg "账户扣除成功，请确保您通过手工方式给客户退款！","S","index.asp"
		
	End Sub
	
	Sub ShowEdit()	
		'operate = "修改"
		pid = Dream3CLS.ChkNumeric(Request("pid"))
		sql = "select * from T_User Where id="&pid
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到该用户！",0,"0")
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
                <div class="head"><h2>用户提现</h2></div>
                <div class="sect">
                    <form method="post" action="?act=save" onsubmit="return ">
						<div class="field">
                            <label>用户名</label><%=username%>
                        </div>
						<div class="field">
                            <label>账户余额</label><%=user_money%>元
						</div>
						<div class="field">
                            <label>手机号码</label><%=mobile%>
						</div>
						<div class="field">
                            <label>用户Email</label><%=email%>
						</div>
						<div class="field">
                            <label>真实姓名</label><%=realname%>
                        </div>
						<div class="field">
                            <label>QQ号码</label><%=qq%>
                        </div>
                        
                        <div class="field">
                            <label>邮政编码</label><%=zipcode%>
                        </div>
                        <div class="field">
                            <label>配送地址</label><%=address%>
						</div>
                        
						<div class="field">
                            <label>提现金额</label>
                            <input type="text" size="30" name="money" id="money" class="number" value="<%=money%>" maxlength="8" onkeypress="NumericKeyPress(8,0)" onkeyup="NumericKeyUp(8,0)"
 onblur="NumericKeyUp(8,0)" /> 请不要超过<%=user_money%>元
                        </div>
						
						<div class="act">
							<input type="hidden" name="pid" value="<%=pid%>"/>
                            <input type="submit" value="确认" name="commit" id="user-submit" class="formbutton" onclick="return window.confirm('您确定要给从账户扣除该金额吗?')"/>
                        </div>
                    </form>
                </div>
            </div>
	</div>
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->