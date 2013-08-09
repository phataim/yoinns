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
		
		If password <> "" Then
			If password <> "" and (password<>confirm) Then
				gMsgArr = gMsgArr&"|密码和确认密码不符！"
			End If
		End If
		
		If mobile<>"" and not Dream3CLS.validate(mobile,4) Then
			gMsgArr = gMsgArr&"|手机号码不合法！"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		

		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_User Where id= "&id
		Rs.open Sql,conn,1,2
		If password <> "" Then
			Rs("password") 	= md5(password)
		End If
		Rs("mobile") 	= mobile
		Rs("city_id") 	= city_id
		Rs("address") 	= address
		Rs("qq") 	= qq
		Rs("zipcode") 	= zipcode
		Rs("gender") 	= gender
		Rs("realname") 	= realname
		Rs("face") 	= face
		
		
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		
		gMsgFlag = "S"
		'Response.Redirect("index.asp")
		Dream3CLS.showMsg "保存成功","S","normal.asp"
		
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
<title><%=SiteConfig("SiteName")%>-用户后台管理- 账户设置</title>
<script type="text/javascript" src="../../common/js/tools.js"></script>
<script type="text/javascript" src="../../common/js/prototype.js"></script>

<div id="box">	
	<div class="cf">		
		<div id="credit">
			<div class="login-box" id="content">
					
					<!--#include file="../inc/menu.asp"-->
					
					<div class="login-content">
						<div class="head">
							<h2>账户设置</h2>
						</div>
						<div class="sect">
							<form id="userForm" name="userForm" method="post" action="?act=save"  class="validator">
						<div class="wholetip clear"><h3>1、基本信息</h3></div>
                        <div class="field email">
                            <label>Email</label>
                            <input type="text" size="30" name="email" id="settings-email-address" class="f-input readonly" readonly value="<%=email%>" />
                        </div>
                        <div class="field">
						<label>用户头像</label>
						<IMG src="<%If IsNull(face) or face="" Then response.Write("../../images/noimage.gif") else response.Write(face)%>" height=80 align=left name='src_img_1'>
						<span style=cursor:hand onclick="window.open('../../common/upload/upload_image.asp?formname=userForm&amp;ImgSrc=src_img_1&amp;editname=src_img_h1','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')" >&gt;&gt;上传用户头像......</span> 
                              <INPUT type=hidden name=src_img_h1 value="<%=face%>">
					</div>
                        <div class="field username">
                            <label>用户名</label>
                            <input type="text" size="30" name="username" id="settings-username" class="f-input readonly"  value="<%=username%>" require="true" datatype="limit" min="2" max="16" maxLength="16" readonly />
                        </div>
                        <div class="field password">
                            <label>更改密码</label>
                            <input type="password" size="30" name="password" id="settings-password" class="f-input" />
                            <span class="hint">如果您不想修改密码，请保持空白</span>
                        </div>
                        <div class="field password">
                            <label>确认密码</label>
                            <input type="password" size="30" name="confirm" id="settings-password-confirm" class="f-input" />
                        </div>
                        <div class="field password">
                            <label>性别</label>
							<select name="gender" class="f-city">
								<option value='F' <%If gender="F" Then Response.Write("selected")%>>女</option>
								<option value='M' <%If gender="M" Then Response.Write("selected")%>>男</option>
							</select>
                        </div>
						<div class="wholetip clear"><h3>2、联系信息</h3></div>
                        <div class="field mobile">
                            <label>手机号码</label>
                            <input type="text" size="30" name="mobile" id="mobile" class="number" value="<%=mobile%>" /><span class="inputtip">手机号码是我们联系您最重要的方式，请准确填写</span>
                        </div>
                        <div class="field password">
                            <label>QQ</label>
                            <input type="text" size="30" name="qq" id="settings-qq" class="number" value="<%=qq%>" onkeypress="NumericKeyPress(12,0)" onkeyup="NumericKeyUp(12,0)"
 onblur="NumericKeyUp(12,0)" maxlength="12"/>
                        </div>
						<div class="field city">
                            <label>所在城市</label>
							<select name="city_id" class="f-city">
							<%=Dream3Team.getCategory("city",city_id)%>
							<option value='0' <%If city_id=0 Then Response.Write("selected")%>>其他</option>
							</select>
                        </div>
						<div class="wholetip clear"><h3>3、派送信息</h3></div>
                        <div class="field username">
                            <label>真实姓名</label>
                            <input type="text" size="30" name="realname" id="realname" class="f-input" value="<%=realname%>" />
							<span class="hint">真实姓名请与有效证件姓名保持一致，便于收取物品</span>
                        </div>
                        <div class="field username">
                            <label>收件地址</label>
                            <input type="text" size="30" name="address" id="address" class="f-input" value="<%=address%>" />
                            <span class="hint">为了能及时收到物品，请按照格式填写：_省_市_县（区）_</span>
                        </div>
						                        <div class="field">
                            <label>邮政编码</label>
                            <input type="text" maxLength=6 size="10" name="zipcode" id="zipcode" class="f-input number" value="<%=zipcode%>" onkeypress="NumericKeyPress(6,0)" onkeyup="NumericKeyUp(6,0)"
 onblur="NumericKeyUp(6,0)" />
                        </div>
                        <div class="clear"></div>
                        <div class="act">
                            <input type="submit" value="更改" name="commit" id="settings-submit" class="formbutton"/>
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
							<h2>帐户余额</h2>
							<p>您的帐户余额：<span class="money"><%=SiteConfig("CNYSymbol")%></span><%=Dream3User.getUserMoney(session("_UserID"))%></p>
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
							<h3 class="first">什么是账户余额？</h3>
							<p>账户余额是你在<%=SiteConfig("SiteName")%>团购时可用于支付的金额。</p>
							<h3>可以往账户里充值么？</h3>
							<p>请到<a href="../credit/index.asp">账户余额</a>菜单，在线充值。</p>
							<h3>那怎样才能有余额？</h3>
							<p>邀请好友获得返利将充值到账户余额，参加团购亦可获得返利。</p>
						</div>
					</div>
					<div class="sbox-bottom"></div>
				</div>
			</div>
			
		</div>
	</div>	
</div>
<!--#include file="../../common/inc/footer_user.asp"-->
