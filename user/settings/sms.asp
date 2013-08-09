<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_user.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<%
Dim Action
Dim username,email,password,confirm,city_id,mobile,gender,qq,realname,zipcode,address,face

	Action = Request.QueryString("act")
	Select Case Action
		Case "save"
			Call SaveRecord()
		Case Else
				Call Main()
	End Select
	
	Sub SaveRecord()
		id = session("_UserID")
		username = session("_UserName")
		email=  Dream3CLS.RParam("email")
		username=  Dream3CLS.RParam("username")
		password=  Dream3CLS.RParam("password")
		confirm=  Dream3CLS.RParam("confirm")
		mobile=  Dream3CLS.RParam("mobile")
		city_id=  Dream3CLS.RParam("city_id")
		qq=  Dream3CLS.RParam("qq")
		realname=  Dream3CLS.RParam("realname")
		address=  Dream3CLS.RParam("address")
		zipcode=  Dream3CLS.RParam("zipcode")
		gender=  Dream3CLS.RParam("gender")
		face=   Dream3CLS.RParam("src_img_h1")
		


		'validate Form
		If email<>"" and not Dream3CLS.IsValidEmail(email) Then
			gMsgArr = gMsgArr&"|Email���Ϸ���"
		End If
		
		If username<>"" and (Dream3CLS.strLength(username) < 4 or Dream3CLS.strLength(username) > 16) Then
			gMsgArr = gMsgArr&"|�û���������4-16���ַ�֮�䣡"
		elseif InStr(UserName, "=") > 0 Or InStr(UserName, ".") > 0 Or InStr(UserName, "%") > 0 Or InStr(UserName, Chr(32)) > 0 Or InStr(UserName, "?") > 0 Or InStr(UserName, "&") > 0 Or InStr(UserName, ";") > 0 Or InStr(UserName, ",") > 0 Or InStr(UserName, "'") > 0 Or InStr(UserName, ",") > 0 Or InStr(UserName, Chr(34)) > 0 Or InStr(UserName, Chr(9)) > 0 Or InStr(UserName, "��") > 0 Or InStr(UserName, "$") > 0 Or InStr(UserName, "*") Or InStr(UserName, "|") Or InStr(UserName, """") > 0 Then
			gMsgArr = gMsgArr&"|�û����к��зǷ����ַ���"
		End If
		
		If password <> "" Then
			If password <> "" and (password<>confirm) Then
				gMsgArr = gMsgArr&"|�����ȷ�����벻����"
			End If
		End If
		
		If mobile<>"" and not Dream3CLS.validate(mobile,4) Then
			gMsgArr = gMsgArr&"|�ֻ����벻�Ϸ���"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		Set Rs = Server.CreateObject("Adodb.recordset")
		If username <> "" Then
			Sql = "Select * from T_User Where username='"&username&"' and id<>"&id
			Rs.Open Sql,conn,1,1
			If Not Rs.EOF Then
				gMsgArr = gMsgArr&"|�û����Ѵ��ڣ���ѡ�������û�����"
				gMsgFlag = "E"
				Exit Sub
			End If
		End if
		
		If Rs.state = 1 Then Rs.Close
		
		Sql = "Select * from T_User Where id= "&id
		Rs.open Sql,conn,1,2
		If password <> "" Then
			Rs("password") 	= md5(password)
		End If
		Rs("email") 	= email
		Rs("username")  = username
 		Rs("mobile") 	= mobile
		Rs("city_id") 	= city_id
		Rs("address") 	= address
		Rs("qq") 	= qq
		Rs("zipcode") 	= zipcode
		Rs("gender") 	= gender
		Rs("realname") 	= realname
		Rs("face") 	= face
		
		
		Rs.Update
		
		
		
		gMsgFlag = "S"
		
		If username="" Then
			Session("_UserName") = mobile
		Else
			Session("_UserName") = username
		End If
		Session("_UserID") = Rs("id")
		Session("_IsManager") = Rs("manager")

		'Ĭ�ϱ���һ����
		Response.Cookies(DREAM3C).Expires = Date + 30
		If username = "" Then
			Response.Cookies(DREAM3C)("_UserName") = mobile
		Else
			Response.Cookies(DREAM3C)("_UserName") = username
		End if
		Response.Cookies(DREAM3C)("_Password") =  Rs("password")
		Response.Cookies(DREAM3C)("_IsManager") =  Rs("manager")
		Response.Cookies(DREAM3C)("_UserCityID") =  Rs("city_id")
		
		Rs.Close
		Set Rs = Nothing
		
		Dream3CLS.showMsg "�޸ĳɹ���","S","sms.asp"
		
	End Sub
	

	
	Sub Main()
		Sql = "Select * From T_User Where id = "&session("_UserID")
		Set Rs = Dream3CLS.Exec(Sql)
		email = Rs("email")
		username = Rs("username")
		mobile = Rs("mobile")
		qq = Rs("qq")
		realname = Rs("realname")
		address = Rs("address")
		zipcode = Rs("zipcode")
		city_id = Rs("city_id")
		face = Rs("face")
		gender = Rs("gender")
		
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=SiteConfig("SiteName")%>-�û���̨����- �˻�����</title>
<script type="text/javascript" src="../../common/js/tools.js"></script>
<script type="text/javascript" src="../../common/js/prototype.js"></script>

<div id="box">	
	<div class="cf">		
		<div id="credit">
			<div class="login-box" id="content">
					
					<!--#include file="../inc/menu.asp"-->
					
					<div class="login-content">
						<div class="head">
							<h2>�˻�����</h2>
						</div>
						<div class="sect">
							<form id="userForm" name="userForm" method="post" action="?act=save"  class="validator">
						<div class="wholetip clear"><h3>1��������Ϣ</h3></div>
                        <div class="field email">
                            <label>Email</label>
                            <input type="text" size="30" name="email" id="settings-email-address" class="f-input readonly"  value="<%=email%>" />
                        </div>
                        <div class="field">
						<label>�û�ͷ��</label>
						<IMG src="<%If IsNull(face) or face="" Then response.Write("../../images/noimage.gif") else response.Write(face)%>" height=80 align=left name='src_img_1'>
						<span style=cursor:hand onclick="window.open('../../common/upload/upload_image.asp?formname=userForm&amp;ImgSrc=src_img_1&amp;editname=src_img_h1','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')" >&gt;&gt;�ϴ��û�ͷ��......</span> 
                              <INPUT type=hidden name=src_img_h1 value="<%=face%>">
					</div>
                        <div class="field username">
                            <label>�û���</label>
                            <input type="text" size="30" name="username" id="settings-username" class="f-input readonly"  value="<%=username%>" require="true" datatype="limit" min="2" max="16" maxLength="16"  />
                        </div>
                        <div class="field password">
                            <label>��������</label>
                            <input type="password" size="30" name="password" id="settings-password" class="f-input" />
                            <span class="hint">����������޸����룬�뱣�ֿհ�</span>
                        </div>
                        <div class="field password">
                            <label>ȷ������</label>
                            <input type="password" size="30" name="confirm" id="settings-password-confirm" class="f-input" />
                        </div>
                        <div class="field password">
                            <label>�Ա�</label>
							<select name="gender" class="f-city">
								<option value='F' <%If gender="F" Then Response.Write("selected")%>>Ů</option>
								<option value='M' <%If gender="M" Then Response.Write("selected")%>>��</option>
							</select>
                        </div>
						<div class="wholetip clear"><h3>2����ϵ��Ϣ</h3></div>
                        <div class="field mobile">
                            <label>�ֻ�����</label>
                            <input type="text" size="30" name="mobile" id="mobile" class="f-input readonly" value="<%=mobile%>" readonly /><span class="inputtip">�ֻ�������������ϵ������Ҫ�ķ�ʽ����׼ȷ��д</span>
                        </div>
                        <div class="field password">
                            <label>QQ</label>
                            <input type="text" size="30" name="qq" id="settings-qq" class="number" value="<%=qq%>" onkeypress="NumericKeyPress(12,0)" onkeyup="NumericKeyUp(12,0)"
 onblur="NumericKeyUp(12,0)" maxlength="12"/>
                        </div>
						<div class="field city">
                            <label>���ڳ���</label>
							<select name="city_id" class="f-city">
							<%=Dream3Team.getCategory("city",city_id)%>
							<option value='0' <%If city_id=0 Then Response.Write("selected")%>>����</option>
							</select>
                        </div>
						<div class="wholetip clear"><h3>3��������Ϣ</h3></div>
                        <div class="field username">
                            <label>��ʵ����</label>
                            <input type="text" size="30" name="realname" id="realname" class="f-input" value="<%=realname%>" />
							<span class="hint">��ʵ����������Ч֤����������һ�£�������ȡ��Ʒ</span>
                        </div>
                        <div class="field username">
                            <label>�ռ���ַ</label>
                            <input type="text" size="30" name="address" id="address" class="f-input" value="<%=address%>" />
                            <span class="hint">Ϊ���ܼ�ʱ�յ���Ʒ���밴�ո�ʽ��д��_ʡ_��_�أ�����_</span>
                        </div>
						                        <div class="field">
                            <label>��������</label>
                            <input type="text" maxLength=6 size="10" name="zipcode" id="zipcode" class="f-input number" value="<%=zipcode%>" onkeypress="NumericKeyPress(6,0)" onkeyup="NumericKeyUp(6,0)"
 onblur="NumericKeyUp(6,0)" />
                        </div>
                        <div class="clear"></div>
                        <div class="act">
                            <input type="submit" value="����" name="commit" id="settings-submit" class="formbutton"/>
                        </div>
                    </form>
						</div>
					</div>
					<div class="login-bottom"></div>
			</div>
			<div id="sidebar" style="margin-top:28px;">
				<div class="sbox">
					<div class="sbox-top"></div>
					<div class="sbox-content">
						<div class="credit">
							<h2>�ʻ����</h2>
							<p>�����ʻ���<span class="money"><%=SiteConfig("CNYSymbol")%></span><%=Dream3User.getUserMoney(session("_UserID"))%></p>
						</div>
					</div>
					<div class="sbox-bottom"></div>
				</div>
			</div>
			
			<div id="sidebar" style="margin-top:10px;">
				<div class="sbox">
					<div class="sbox-top"></div>
					<div class="sbox-content">
						<div class="side-tip">
							<h3 class="first">ʲô���˻���</h3>
							<p>�˻����������<%=SiteConfig("SiteName")%>�Ź�ʱ������֧���Ľ�</p>
							<h3>�������˻����ֵô��</h3>
							<p>�뵽<a href="../credit/index.asp">�˻����</a>�˵������߳�ֵ��</p>
							<h3>��������������</h3>
							<p>������ѻ�÷�������ֵ���˻����μ��Ź���ɻ�÷�����</p>
						</div>
					</div>
					<div class="sbox-bottom"></div>
				</div>
			</div>
			
		</div>
	</div>	
</div>
<!--#include file="../../common/inc/footer_user.asp"-->
