<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_user.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<%
Dim Action
Dim oripassword, password,confirm

	Action = Request.QueryString("act")
	Select Case Action
		Case "save"
			Call SaveRecord()
		Case Else
				Call Main()
	End Select
	
	Sub SaveRecord()
		id = session("_UserID")
		oripassword=  Dream3CLS.RParam("oripassword")
		password=  Dream3CLS.RParam("password")
		confirm=  Dream3CLS.RParam("confirm")
		

		'validate Form
		If oripassword = ""  Then
			gMsgArr = gMsgArr&"|������ԭ�����룡"
			gMsgFlag = "E"
			Exit Sub
		End If
		
		If password = "" Then
			gMsgArr = gMsgArr&"|�����������룡"
			gMsgFlag = "E"
			Exit Sub
		End If

		If  password<>confirm Then
			gMsgArr = gMsgArr&"|�����ȷ�����벻����"
		End If
		
		
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		

		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_User Where id= "&id
		Rs.open Sql,conn,1,2
		If md5(oripassword) <> Rs("password") Then
			gMsgArr = gMsgArr&"|ԭ�����벻��ȷ��"
			gMsgFlag = "E"
			Exit Sub
		End If

		Rs("password") 	= md5(password)
		
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		
		gMsgFlag = "S"
		'Response.Redirect("index.asp")
		Dream3CLS.showMsg "�����޸ĳɹ�","S","pwdsetting.asp"
		
	End Sub
	

	
	Sub Main()
		
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=Dream3CLS.SiteConfig("SiteName")%>-�û���̨����- �޸�����</title>

<form id="userForm" name="userForm" method="post" action="?act=save"  class="validator">
<div class="area">
	
    
    <!--#include file="../inc/top.asp"-->
    
    
	<!--#include file="../inc/menu.asp"-->
	
    
    
    <div class="layoutright mt9">
    	<div class="bor">
        	<div class="innr">
            	
                <div class="discbox"><p>�޸�����</p></div>
            	
                <div class="sortbox">
                    <div class="sort_innr">
                        <div class="tags">
                            <!--#include file="menu.asp"-->
                        </div>                   
                    </div>
                </div>
                
                <div class="search_con clearfix">
                	
                    <div class="pass_con">
                        <ul class="pass_cont">
                            <li><h3>ԭ�����룺</h3><input type="password" autocomplete="off" name="oripassword" class="input_bg2"><span></span></li>
                            <li><h3>�� �� �룺</h3><input type="password" autocomplete="off" name="password" class="input_bg2"><span></span></li>
                            <li><h3>ȷ�����룺</h3><input type="password" autocomplete="off" name="confirm" class="input_bg2"><span>�ظ�����һ������</span></li>
                        </ul>
                    </div>
                    
                    <div class="wdxx_qd">
                        <span class="quxiao font14_white"><a href="#" onclick="document.userForm.submit();">ȷ  ��</a></span>
                        <span class="queding font14_white"><a href="#" onclick="">ȡ  ��</a></span>
                    </div>
                    
                </div>
                
            </div>
        </div>
    </div>
    
    
    
</div>
</form>
<!--#include file="../../common/inc/footer_user.asp"-->
