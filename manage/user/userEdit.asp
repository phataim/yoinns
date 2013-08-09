<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<%
Dim Action
Dim email,username,realname,qq,password,zipcode,address,mobile,validcode,manager
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
		email =  Dream3CLS.RParam("email")
		username =  Dream3CLS.RParam("username")
		realname =  Dream3CLS.RParam("realname")
		qq=  Dream3CLS.RParam("qq")
		password=  Dream3CLS.RParam("password")
		zipcode=  Dream3CLS.RParam("zipcode")
		address=  Dream3CLS.RParam("address")
		mobile=  Dream3CLS.RParam("mobile")
		validcode=  Dream3CLS.RParam("validcode")
		manager=  Dream3CLS.RParam("manager")
		
		
		'validate Form
		If len(realname) >32 Then
			gMsgArr = "真实姓名不能超过32位！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If


		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_User Where id="&pid
		

		
		Rs.open Sql,conn,1,2
		Rs("realname") 	= realname
		Rs("qq") 	= qq
		Rs("zipcode") 	= zipcode
		Rs("address")= address
		Rs("mobile")= mobile
		Rs("validcode")= validcode
		Rs("manager")= manager
		If password <> "" Then
			Rs("password")= md5(password)
		End If
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		'gMsgFlag = "S"
		Dream3CLS.showMsg "保存成功","S","index.asp"
		
	End Sub
	
	Sub ShowEdit()	
		'operate = "修改"
		pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
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
		validcode = Rs("validcode")
		manager = Rs("manager")
	End Sub

	
	Sub Main()	

	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="../../common/js/tools.js"></script>

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">编辑用户</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">
                <div class="sect">
                    <form method="post" action="userEdit.asp?act=save">
						<div class="field">
                            <label>用户Email</label>
                            <input type="text" size="30" name="email" id="email" class="f-input" value="<%=email%>" readonly />
						</div>
						<div class="field">
                            <label>用户名</label>
                            <input type="text" size="30" name="username" id="username" class="f-input" value="<%=username%>" readonly />
                        </div>
						<div class="field">
                            <label>真实姓名</label>
                            <input type="text" size="30" name="realname" id="realname" class="f-input" value="<%=realname%>" />
                        </div>
						<div class="field">
                            <label>QQ号码</label>
                            <input type="text" size="30" name="qq" id="qq" class="number" value="<%=qq%>" maxlength="14" />
                        </div>
                        <div class="field password">
                            <label>登录密码</label>
                            <input type="text" size="30" name="password" id="password" class="f-input" />
                            <span class="hint">如果不想修改密码，请保持空白</span>
                        </div>
						<div class="wholetip clear"><h3>2、基本信息</h3></div>
                        <div class="field">
                            <label>邮政编码</label>
                            <input type="text" size="30" name="zipcode" id="zipcode" class="f-input" value="<%=zipcode%>" onkeypress="NumericKeyPress(6,0)" onkeyup="NumericKeyUp(6,0)"
 onblur="NumericKeyUp(6,0)" maxlength="6"/>
                        </div>
                        <div class="field">
                            <label>配送地址</label>
                            <input type="text" size="30" name="address" id="address" class="f-input" value="<%=address%>"/>
						</div>
                        <div class="field">
                            <label>手机号码</label>
                            <input type="text" size="30" name="mobile" id="mobile" class="number" value="<%=mobile%>" maxLength="11" />
						</div>
						<div class="wholetip clear"><h3>3、附加信息</h3></div>
                        <div class="field">
                            <label>验证码</label>
                            <input type="text" size="30" name="validcode" id="validcode" class="f-input" value="<%=validcode%>"/>
                            <span class="hint">通过验证，请清空该字段</span>
                        </div>
						                        <div class="field">
                            <label>管理员</label>
                            <select name="manager">
                              <option value="Y" <%If manager="Y" then response.Write("selected") %>>是</option>
							  <option value="N" <%If manager="N" then response.Write("selected") %>>否</option>
                            </select>
						</div>
						<div class="act">
							<input type="hidden" name="pid" value="<%=pid%>"/>
                            <input type="submit" value="编辑" name="commit" id="user-submit" class="formbutton"/>
                        </div>
                    </form>
                </div>
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->