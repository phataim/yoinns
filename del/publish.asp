<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<%
Dim Action
Dim town_select
Dim default_province,default_city,default_town

Dim pid
Dim city_code,lodgeType,leaseType,houseTitle,address,invoice,userid

Action = Request.QueryString("act")
Select Case Action
	Case "save"
		Call SaveRecord()
	Case "showedit"
		Call ShowEdit()
	Case Else
		Call Main()
End Select

Sub SaveRecord()
 	pid = Dream3CLS.ChkNumeric(Request.Form("pid"))

	city_code = Dream3CLS.RParam("town_select")
	default_province = Dream3CLS.RParam("province_select")
	default_city = Dream3CLS.RParam("city_select")
	default_town = Dream3CLS.RParam("town_select")
	
	leaseType = Dream3CLS.RParam("leaseType")
	lodgeType = Dream3CLS.RParam("lodgeType")
	houseTitle = Dream3CLS.RParam("houseTitle")
	address = Dream3CLS.RParam("address")
	invoice = Dream3CLS.RParam("invoice")
	
	
	'��֤��
	Call validateSubmit()

	
	
	If len(gMsgArr) > 0 Then 
		gMsgFlag = "E"
		
		Exit Sub
	End If
	
	'��ʼ����
	
	
	Set Rs = Server.CreateObject("Adodb.recordset")
	Sql = "Select * from T_Product"
	If pid <> 0 Then
		If Session("_IsManager") = "Y" Then
			Sql = Sql & " Where ID="& pid
		Else
			Sql = Sql & " Where ID="& pid & " and user_id="&Session("_UserID")
		End If
	End If
	
	Rs.open Sql,conn,1,2
	If pid = 0  Then 
		Rs.AddNew
		Rs("user_id") = session("_UserID")
		Rs("create_time") = Now()
	End If
	Rs("lodgeType") = lodgeType
	Rs("leaseType") = leaseType
	Rs("houseTitle") = houseTitle
	Rs("invoice") = invoice
	Rs("address") = address
	Rs("city_code") = city_code
	Rs("state") = "pending" 


	
	Rs.Update
	pid = Rs("id")
	userid = Rs("user_id")
	Rs.Close
	Set Rs = Nothing
	'��������
	Set Rs = Server.CreateObject("Adodb.recordset")
	Sql = "Select * from T_hotel where  h_uid=" &userid
	
	Rs.open Sql,conn,1,2
	Rs("h_housenum") = Rs("h_housenum")+1
	Rs.Update
	Rs.Close
	Set Rs = Nothing
	
	'���Ϊ�༭������������δ֧���Ķ���
	If pid > 0  Then 
		Dream3Product.setInvalidOrderWhenReedit pid,  session("_UserID"), Session("_IsManager")
	End If
	
	'directPage = "pstep1.asp?pid="&pid
	directPage = "pmap.asp?pid="&pid
	
	'Dream3CLS.showMsg "����ɹ�","S",directPage
	response.Redirect(directPage)
	
End Sub

Sub ShowEdit()

	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	
	If Session("_IsManager") = "Y" Then
		Sql = "Select * from T_Product Where id="&Pid
	Else
		Sql = "Select * from T_Product Where id="&Pid&" and user_id="&Session("_UserID")
	End If
	Set Rs = Dream3CLS.Exec(Sql)
	If Rs.EOF Then
		Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
		response.End()
	End If
	
	city_code = Rs("city_code") 
	lodgeType = Rs("lodgeType")
	leaseType = Rs("leaseType")
	houseTitle = Rs("houseTitle")
	invoice = Rs("invoice")
	address = Rs("address")

	default_province = mid(cstr(city_code),1,2) & "0000"
	default_city = mid(cstr(city_code),1,4) & "00"
	default_town = city_code

	'Call Main()
End Sub

Sub validateSubmit()
	If Trim(houseTitle) = "" Then
		gMsgArr = gMsgArr&"|�����뷿�ݱ��⣡"
	End If
	
	If  Len(houseTitle) > 22   Then
		gMsgArr = gMsgArr&"|���ݱ��ⲻ�ܳ���22���ַ���"
	End If
	
	If Trim(city_code) = "" Then
		gMsgArr = gMsgArr&"|��������Ҫ����ķ������ڵأ�"
	End If
	
	If Trim(address) = "" Then
		gMsgArr = gMsgArr&"|��������ϸ��ַ��"
	End If
	
	If  Len(address) > 40   Then
		gMsgArr = gMsgArr&"|��ϸ��ַ���ܳ���40���ַ���"
	End If
	
End Sub

Sub validateDraft()

End Sub




Sub Main()	
	
	default_province = 440000
	default_city = 440300
	default_town = 440303
	
	lodgeType = "house"
	leaseType="whole"
	invoice="n"
						
	seqno = 0
	

End Sub

%>
<%
G_Title_Content = "����ϵͳ"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="common/js/city_common.js"></script>
<form class="validator"  action="?act=save" method="post" id="productForm" name="productForm">
<div class="area">

	
	<!--#include file="common/inc/publish_header.asp"-->
	
	
    <div class="layer2">
        <div class="side-top"></div>
        <div class="side-center">
		
            <table cellspacing="0" cellpadding="0" border="0" width="622" class="table">
                <tr>
                    <td class="title" colspan="2">��������</td>
                </tr>
                <tr>
                    <td width="100">�������ͣ�</td>
                    <td>
                    <select name="lodgeType">
                    <option <%If lodgeType="house" then Response.Write("selected")%> value="house">���</option>                    
                    <option <%If lodgeType="apartment" then Response.Write("selected")%> value="apartment">��Ԣ</option>                    
                    <option <%If lodgeType="mcmansions" then Response.Write("selected")%> value="mcmansions">��������</option>                    
                    <option <%If lodgeType="hotel" then Response.Write("selected")%> value="hotel">�ù�</option>                    
                    <option <%If lodgeType="tavern" then Response.Write("selected")%> value="tavern">��ջ</option>                    
                    <option <%If lodgeType="loft" then Response.Write("selected")%> value="loft">��¥</option>                    
                    <option <%If lodgeType="courtyard" then Response.Write("selected")%> value="courtyard">�ĺ�Ժ</option>                    
                    <option <%If lodgeType="seasidecottage" then Response.Write("selected")%> value="seasidecottage">����С��</option>                    
                    <option <%If lodgeType="dormitory" then Response.Write("selected")%> value="dormitory">��������</option>                    
                    <option <%If lodgeType="woodscottage" then Response.Write("selected")%> value="woodscottage">�ּ�С��</option>                    
                    <option <%If lodgeType="luxuryhouse" then Response.Write("selected")%> value="luxuryhouse">��լ</option>                    
                    <option <%If lodgeType="castle" then Response.Write("selected")%> value="castle">�Ǳ�</option>                    
                    <option <%If lodgeType="treehouse" then Response.Write("selected")%> value="treehouse">����</option>                    
                    <option <%If lodgeType="cabin" then Response.Write("selected")%> value="cabin">����</option>                    
                    <option <%If lodgeType="carhouse" then Response.Write("selected")%> value="carhouse">����</option>                    
                    <option <%If lodgeType="icehouse" then Response.Write("selected")%> value="icehouse">����</option>                    
                    </select>
                    </td>
                </tr>
                <tr>
                    <td width="100">�������ͣ�</td>
                    <td>
                    	<input type="radio" value="whole" <%If leaseType="whole" then Response.Write("checked=""checked""")%> name="leaseType"> ����
                        <input type="radio" value="room" <%If leaseType="room" then Response.Write("checked=""checked""")%> name="leaseType"> �������
                        <input type="radio" value="bed" <%If leaseType="bed" then Response.Write("checked=""checked""")%> name="leaseType"> ��λ����
                    </td>
                </tr>
                                            <tr>
                    <td width="100">��Ʊ��</td>
                    <td>
                       <input type="radio" value="y" <%If invoice="y" then Response.Write("checked=""checked""")%>  name="invoice" /> 
                      �ṩ
                      <input type="radio" value="n" <%If invoice="n" then Response.Write("checked=""checked""")%>  name="invoice"> ���ṩ
                    </td>
                </tr>
            </tbody></table>
			
        </div>
        <div class="side-bottom"></div>
    </div>
    <div class="layer2">
        <div class="side-top"></div>
        <div class="side-center">
            <table cellspacing="0" cellpadding="0" border="0" width="622" style="TABLE-LAYOUT:fixed" class="table">
                <tbody><tr>
                    <td class="title">����λ��</td>
                  
                </tr>
                <tr>
                    <td>���ݱ��⣨22�������ڣ���</td>
                </tr>
                <tr>
                    <td>
                        <input class="radius input" style="width:280px;" value="<%=houseTitle%>" name="houseTitle" type-"text"="">
                        <span id="tip_housetitle"></span>
                    </td>
                </tr>
                <tr>
                    <td>��Ҫ����ķ����ڣ�</td>
                </tr>
                <tr>
                    <td><span></span>
                        <script type="text/javascript" charset="gb2312">
						<!--
						var default_province = <%=default_province%>;
						var default_city = <%=default_city%>;
						var default_town = <%=default_town%>;
					  //-->
					  </script>
					  <!--#include file="common/js/city_select.asp"-->
                    </td>
                </tr>
                
                <tr>
                    <td colspan="2"><span>��ϸ��ַ��</span>
                        <span id="fullAddress"></span>
                        <input type="text" class="radius input" style="width:229px;" value="<%=address%>" name="address" id="address"><span id="tip_address"><span class="validatorMsg validatorInit">40��������</span></span>
                    </td>
                </tr>
               
            </tbody></table>
            <div style="display:none;text-align:center;" id="iframesub_message"></div>
        </div>
        <div class="side-bottom"></div>
    </div>
    <div class="tj-btn">
        <dl class="right">
            <dd class="font14_white"><a class="btn2" href="/admin.php?op=MyRentRooms">��������</a></dd>
			<dd><input type="submit" id="searchBt" value="���沢����" class="input_next"></dd>
        </dl>
        <div class="clear"></div>
    </div>
	
	
</div>
<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
</form>
<!--#include file="common/inc/footer_user.asp"-->