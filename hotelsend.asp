<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<%
Dim Action
Dim town_select
Dim default_province,default_city,default_town
'Dim fabuzhuangtai

Dim pid
Dim city_code,h_star,hotelname,headname,h_img,discription,h_line,address,userid,facilities

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
	
	hotelname = Dream3CLS.RParam("hotelname")
	headname = Dream3CLS.RParam("headname")
	h_star = Dream3CLS.RParam("h_star")
	h_img = Dream3CLS.RParam("src_img_1")
	if Dream3CLS.RParam("src_img_h1")<>"" then
	h_img = Dream3CLS.RParam("src_img_h1")
	end if
	discription = Dream3CLS.RParam("discription")
	h_line = Dream3CLS.RParam("h_line")
	address = Dream3CLS.RParam("address")
	facilities = Dream3CLS.RParam("facilities")
	
	
	'��֤��
	Call validateSubmit()

	
	
	If len(gMsgArr) > 0 Then 
		gMsgFlag = "E"
		
		Exit Sub
	End If
	
	If(len(trim(facilities)) > 0 ) Then	
		facilityArr = Split(facilities,",")
		facilities = ""
		For i = 0 To UBound(facilityArr)
			If i = 0 Then 
				facilities = Trim(facilityArr(i))
			Else
				facilities = facilities & "," & Trim(facilityArr(i))
			End If
			
		Next
	End If
	
	'��ʼ����
	
	
	Set Rs = Server.CreateObject("Adodb.recordset")
	Sql = "Select * from T_hotel"
	If pid <> 0 Then
		
			Sql = Sql & " Where h_id="& pid
		
	End If
		
	Rs.open Sql,conn,1,2
	 if pid=0 then
		Rs.AddNew
	end if
		Rs("h_uid") = session("_UserID")
		Rs("h_createtime") = Now()
		Rs("h_hotelname") = hotelname
		Rs("h_headname") = headname
		Rs("h_citycode") = city_code
		Rs("h_address") = address
		Rs("h_img") = h_img
		Rs("h_discription") = discription
		Rs("h_star") = h_star
		Rs("h_line") = h_line
		Rs("h_facility") = facilities
	Rs.Update
	pid = Rs("h_id")
	userid = Rs("h_uid")
	Rs.Close
	Set Rs = Nothing
	
	
	
	directPage = "hmap.asp?pid="&pid
	
	'Dream3CLS.showMsg "����ɹ�","S",directPage
	response.Redirect(directPage)
	
End Sub

Sub ShowEdit()

	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	Sql = "Select * from T_hotel Where h_id="&pid&" and h_uid="&Session("_UserID")
	
	Set Rs = Dream3CLS.Exec(Sql)
	If Rs.EOF Then
		Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
		response.End()
	End If
	
	city_code = Rs("h_citycode") 
	hotelname = Rs("h_hotelname")
	headname = Rs("h_headname")
	h_star = Rs("h_star")
	h_img = Rs("h_img")
	discription= Rs("h_discription")
	h_line= Rs("h_line")
	address = Rs("h_address")
	pid= Rs("h_id")
	facilities =Rs("h_facility")
	
	default_province = mid(cstr(city_code),1,2) & "0000"
	default_city = mid(cstr(city_code),1,4) & "00"
	default_town = city_code

	'Call Main()
End Sub

Sub validateSubmit()
	If Trim(hotelname) = "" Then
		gMsgArr = "������Ƶ�/�õ����ƣ�"
	End If
	
	If len(Trim(hotelname)) >49 Then
		gMsgArr = gMsgArr&"�Ƶ�/�õ�����̫����"
	End If
	
	If Trim(h_line) = "" Then
		gMsgArr = gMsgArr&"|�����뽻ͨ��·��"
	End If
	If len(Trim(h_line)) >50 Then
		gMsgArr = gMsgArr&"|��ͨ��·��ַ������"
	End If
	
	If Trim(discription) = "" Then
		gMsgArr = gMsgArr&"|������Ƶ�/�õ���ܣ�"
	End If
	
	If  Len(headname) > 22   Then
		gMsgArr = gMsgArr&"|�Ƶ�/�õ꾭��������д���Ȳ���ȷ��"
	End If
	
	''If Trim(city_code) = "" Then
	''	gMsgArr = gMsgArr&"|���������Ƶ�/�õ�����ڵأ�"
	''End If
	
	If Trim(address) = "" Then
		gMsgArr = gMsgArr&"|��������ϸ��ַ��"
	End If
	
	If  Len(address) > 80  Then
		gMsgArr = gMsgArr&"|��ϸ��ַ���ܳ���80���ַ���"
	End If
	
	If  Trim(facilities) = "" Then
		gMsgArr = gMsgArr&"|��ѡ����ʩ����"
	End If
End Sub

Sub validateDraft()

End Sub


Sub Main()	
'
 '    Sql2 = "Select * from T_User Where id="&Session("_UserID")
  '   Set rs2 = Dream3CLS.Exec(Sql2)
   '  fabuzhuangtai=rs2("zipcode")
    ' if fabuzhuangtai=1 then
     '   Call Dream3CLS.MsgBox2("���Ѿ��������ù��(�ѣ���)�����ٷ���\n\n������Ҫ������� \\(^o^)/ ��Ϳͷ�QQ��ϵ\n���µ�����020-34726441.\n\n����֮�������½⣡#^_^#",0,"0")
      '  response.End
    ' end if

	
	default_province = 120000
	default_city = 120100
	default_town = 120101
	
	h_star = "����"
	
End Sub

%>
<%
G_Title_Content = "���ùݾƵ�/�õ귢��ϵͳ"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="common/js/city_common.js"></script>
<form class="validator"  action="?act=save" method="post" id="userForm" name="userForm">
<div class="area">
<br><a href="user\account\zhifubiangeng.html" target="_blank"><strong><span style="color:red">�����ùݡ�֧����ʽ���!</span></strong> </a></br>
	
	<!--#include file="common/inc/hotelsend_header.asp"-->
	
	
    <div class="layer2">
        <div class="side-top"></div>
      <div class="side-center">
		
        <table cellspacing="0" cellpadding="0" border="0" width="622" class="table">
                <tr>
                    <td class="title" colspan="3">�����Ƶ�/�õ�</td>
                </tr>
				<tr>
                    <td><span>�Ƶ�/�õ����ƣ�</span>
                        <span ></span>
                        <input type="text" class="radius input" style="width:229px;" value="<%=hotelname%>" name="hotelname" id="hotelname">                    </td>
                    <td width="88" rowspan="3"></td>
				    <td width="177" rowspan="3" align=center style="border:double;"><p><a href="common/upload/upload_image.asp?formname=userForm&ImgSrc=src_img_1&editname=src_img_h1" target=_blank><img name='src_img_1' width="150" height="150" src="<%If IsNull(h_img) or h_img="" Then response.Write("../../images/noimage.gif") else response.Write("../../"&h_img)%>"></a></p>
                            <h3>
                                <span style=cursor:hand onclick="window.open('../../common/upload/upload_image.asp?formname=userForm&amp;ImgSrc=src_img_1&amp;editname=src_img_h1','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')" ><strong><span style="color:#ff0000">~~����ϴ��Ƶ�ͷ��~~</span></strong></span> 
                              <INPUT type=hidden name=src_img_h1 value="<%=h_img%>">
                    </h3></td>
			    </tr>
				<tr>
                    <td><span>�Ƶ�/�õ꾭��</span>
                        <span></span>
                        <input type="text" class="radius input" style="width:229px;" value="<%=headname%>" name="headname" id="headname">                    </td>
                </tr>
                <tr> 
                    <td width="357"> ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����
                      <select name="h_star"> 
                        
                        <option <%If h_star="����" then Response.Write("selected")%> value="����">����</option>
                     </select>
					 </td>
					 </tr>
                 <tr>
                    <td colspan="3">�Ƶ�/�õ���ܣ�
                       
                        <textarea name="discription" rows="10" class="radius input" id="discription" style="width:500px; height:100px;"><%=discription%></textarea></td>
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
                    <td class="title">�Ƶ�/�õ�λ��</td>
                  
                </tr>
                <tr>
                    <td>��ͨ·�ߣ�50�������ڣ���</td>
                </tr>
                <tr>
                    <td>
                        <input class="radius input" style="width:280px;" value="<%=h_line%>" name="h_line" type="text">
                        
                    </td>
                </tr>
                <tr>
                    <td>���ľƵ�/�õ��ڣ�</td>
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
	<div class="layer2">
        <div class="side-top"></div>
        <div class="side-center">
            <table cellspacing="0" cellpadding="0" border="0" width="622" style="TABLE-LAYOUT:fixed" class="table">
                <tbody><tr>
                    <td class="title">�Ƶ�/�õ���ʩ</td>
                  
                </tr>
			 </tbody></table>
			 <%
					Set facilityRs = Server.CreateObject("adodb.recordset")			
					Sql = "select id,cname from T_Hfacility Where  enabled='Y' order by seqno desc"
					facilityRs.open Sql,conn,1,2
					i = 0
					Do While Not facilityRs.EOF 
						
						If instr(facilities,facilityRs("id")) Then
							isChecked = "checked"
						Else
							isChecked = ""
						End If
						response.Write("<span><input type=""checkbox"" "&isChecked&" name=""facilities"" value="&facilityRs("id")&"><label>"&facilityRs("cname")&"</label>&nbsp;&nbsp;</span>")
						facilityRs.Movenext
						i = i + 1
					Loop
					%>   
                
            <div style="display:none;text-align:center;" id="iframesub_message"></div>
        </div>
        <div class="side-bottom"></div>
    </div>
    <div class="tj-btn">
        <dl class="right">
            <dd class="font14_white"><a class="btn2" href="/user/account/setting.asp">��������</a></dd>
			<dd><input type="submit" id="searchBt" value="���沢����" class="input_next"></dd>
        </dl>
        <div class="clear"></div>
    </div>
	
	<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
</div>
</form>
<!--#include file="common/inc/footer_user.asp"-->