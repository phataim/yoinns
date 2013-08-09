<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_user.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<%
Dim Action
Dim default_province,default_city,default_town
Dim username,nickname,email,password,confirm,city_id,mobile,gender,qq,realname,zipcode,address,face

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
		nickname=  Dream3CLS.RParam("nickname")
		email=  Dream3CLS.RParam("email")
		password=  Dream3CLS.RParam("password")
		confirm=  Dream3CLS.RParam("confirm")
		city_id=  Dream3CLS.RParam("city_id")
		qq=  Dream3CLS.RParam("qq")
		realname=  Dream3CLS.RParam("realname")
		address=  Dream3CLS.RParam("address")
		zipcode=  Dream3CLS.RParam("zipcode")
		gender=  Dream3CLS.RParam("gender")
		face=   Dream3CLS.RParam("src_img_h1")
		
		default_province = Dream3CLS.RParam("province_select")
		default_city = Dream3CLS.RParam("city_select")
		default_town = Dream3CLS.RParam("town_select")


		'validate Form
		
		If password <> "" Then
			If password <> "" and (password<>confirm) Then
				gMsgArr = gMsgArr&"|密码和确认密码不符！"
			End If
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
		Rs("city_code") 	= default_town
		Rs("address") 	= address
		Rs("qq") 	= qq
		Rs("zipcode") 	= zipcode
		Rs("gender") 	= gender
		Rs("realname") 	= realname
		Rs("nickname") 	= nickname
		Rs("face") 	= face
		
		Session("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Session("_UserID") = Rs("id")
		Session("_IsManager") = Rs("manager")
		Session("_UserFace") = Rs("face")

		'默认保存一个月
		Response.Cookies(DREAM3C).Expires = Date + 30
		Response.Cookies(DREAM3C)("_UserID") = Rs("id")
		Response.Cookies(DREAM3C)("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Response.Cookies(DREAM3C)("_Password") =  Rs("password")
		Response.Cookies(DREAM3C)("_IsManager") =  Rs("manager")
		Response.Cookies(DREAM3C)("_UserCityCode") =  Rs("city_code")
		
		
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		Session("_UserFace") = face
		
		gMsgFlag = "S"
		
		'Response.Redirect("index.asp")
		Dream3CLS.showMsg "保存成功","S","setting.asp"
		
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
		city_code = Rs("city_code")
		face = Rs("face")
		gender = Rs("gender")
		nickname  = Rs("nickname")
		
		If IsNull(city_code) Then city_code = ""
		If city_code <> "" Then
			default_province = mid(cstr(city_code),1,2) & "0000"
			default_city = mid(cstr(city_code),1,4) & "00"
			default_town = city_code
		Else
			default_province = "110000"
			default_city = "110100"
			default_town = "110101"
		End If
		
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=Dream3CLS.SiteConfig("SiteName")%>-用户后台管理- 账户设置</title>
<script type="text/javascript" src="../../common/js/tools.js"></script>
<script type="text/javascript" src="../../common/js/prototype.js"></script>
<script type="text/javascript" src="../../common/js/city_common.js"></script>

<form id="userForm" name="userForm" method="post" action="?act=save"  class="validator">
<div class="area">
	
    
    <!--#include file="../inc/top.asp"-->
    
    
	<!--#include file="../inc/menu.asp"-->
	
    
    
    <div class="layoutright mt9">
    	<div class="bor">
        	<div class="innr">
            	
                <div class="discbox"><p>修改个人资料</p>
                  
            </div>
            	
                <div class="sortbox">
                    <div class="sort_innr">
                        <div class="tags">
                            <!--#include file="menu.asp"-->
                        </div>                   
                    </div>
                </div>
                
                <div class="search_con clearfix">
                	
                     <div class="search_con_left">
                     	<span class="wdxx_conl">
                            <p><a href="#"><img name='src_img_1' width="150" height="150" src="<%If IsNull(face) or face="" Then response.Write("../../images/noimage.gif") else response.Write("../../"&face)%>"></a></p>
                            <h3>
                                
                              <INPUT type=hidden name=src_img_h1 value="<%=face%>">
                            </h3>
                        </span>
                     </div>
                     
                     <div class="search_con_right">
                     	<ul class="wdxx_conr">
							<li><h3>邮 &nbsp;&nbsp;&nbsp;箱：</h3><input value="<%=email%>" name="email" id="email" class="input_bg2" readonly="true"></li>
                            <li><h3>用 户 名：</h3><input value="<%=username%>" name="username" id="username" class="input_bg2" readonly="true"></li>
                            <li><h3>昵&nbsp;&nbsp;&nbsp;称：</h3><input type="text" value="<%=nickname%>" name="nickname" id="nickname" class="input_bg2"></li>
                            <li><h3>真实姓名：</h3><input type="text" value="<%=realname%>" name="realname" id="realname" class="input_bg2"></li>
                        </ul>
                        
                        <ul class="wdxx_conr2">
           
                            <li class="sst"><h3>性 &nbsp;&nbsp;&nbsp;别：</h3>
							<select name="gender" class="select_bg">
								<option value='F' <%If gender="F" Then Response.Write("selected")%>>女</option>
								<option value='M' <%If gender="M" Then Response.Write("selected")%>>男</option>
							</select>
							</li>
                            <li class="sst1"><h3>所在城市：</h3>
							<script type="text/javascript" charset="gb2312">
								<!--
								var default_province = <%=default_province%>;
								var default_city = <%=default_city%>;
								var default_town = <%=default_town%>;
							  //-->
							  </script>
							  <!--#include file="../../common/js/city_select.asp"-->
							
							</li>
                            
                            <li><h3>手 机 号：</h3><h3><%=mobile%></h3>
                            <li><h3>&nbsp;</h3><p style="color:red;"></p></li>
                        </ul>
                     </div>
                	
                    <div class="wdxx_save font14_white">
                        <a href="#" onclick="document.userForm.submit();">保 存</a>
                    </div>
                    
                </div>
                
            </div>
        </div>
    </div>
    
    
    
</div>
</form>
<!--#include file="../../common/inc/footer_user.asp"-->
