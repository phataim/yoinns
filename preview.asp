<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->
<%
Dim Action
Dim pid
Dim city_code,lodgeType,leaseType,houseTitle,address,invoice
Dim roomtitle,area,guestnum,toiletnum,roomdesc,userule,bedtype,roomsnum,bednum,expireDate,startDate
Dim img1,img2,img3,img4,img5,img6,img7,img8,img9,img10
Dim facilities
Dim checkintime,checkouttime,minday,maxday,refundday,paymentRules,dayrentprice,weekrentprice,monthrentprice
dim hid,hotelname


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
	
	'��ʼ����
	
	
	Set Rs = Server.CreateObject("Adodb.recordset")
	Sql = "Select * from T_Product"
	If pid <> 0 Then
		If Session("_IsManager") = "Y" Then
			Sql = Sql & " Where ID="&pid
		Else
			Sql = Sql & " Where ID="&pid&" and user_id="&Session("_UserID")
		End If
	End If
	
	Rs.open Sql,conn,1,2
	if Rs.EOF Then
		gMsgArr = "����Ȩ�޸ĸò�Ʒ��"
		gMsgFlag = "E"
		Call Main()
	End If

	Rs("state") = "auditing"
	
	Rs.Update

	Rs.Close
	Set Rs = Nothing
	
	
	directPage = VirtualPath&"/user/company/myroom.asp"
	
	'response.Redirect(directPage)
	Dream3CLS.showMsg "���Ķ����Ʒ���ύ����Ա��ˣ������ĵȴ���лл��","S", directPage
	
End Sub

Sub ShowEdit()
	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	If Session("_IsManager") = "Y" Then
		Sql = "Select * from T_Product Where id="&Pid
	Else
		Sql = "Select * from T_Product Where id="&Pid&"  and user_id="&Session("_UserID")
	End If
	Set Rs = Dream3CLS.Exec(Sql)
	If Rs.EOF Then
		Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
		response.End()
	End If
	
	'publish
	'city_code = Rs("city_code") 
	'lodgeType = Rs("lodgeType")
	'leaseType = Rs("leaseType")
	'houseTitle = Rs("houseTitle")
	'invoice = Rs("invoice")
	'address = Rs("address")
	
	'step1
	hid=Rs("hid")
	houseTitle = Rs("houseTitle") 
	area = Rs("area")
	guestnum  = Rs("guestnum")
	toiletnum  = Rs("toiletnum")
	roomdesc  = Rs("roomdesc")
	userule  = Rs("userule")
	bedtype  = Rs("bedtype")
	roomsnum  = Rs("roomsnum")
	bednum = Rs("bednum")
	expireDate = Rs("expireDate")
	startDate  = Rs("startDate")
	
	'step2
	img1 = Rs("image")  
	img2 = Rs("image1")  
	img3 = Rs("image2")  
	img4 = Rs("image3")  
	img5 = Rs("image4")  
	img6 = Rs("image5")  
	img7 = Rs("image6")  
	img8 = Rs("image7")  
	img9 = Rs("image8")  
	img10 = Rs("image9") 
	'step3
	facilities = Rs("facilities") 
	facilities = ","&facilities&","
	
	'step4
	checkintime = Rs("checkintime")
	checkouttime = Rs("checkouttime") 
	minday= Rs("minday")
	maxday = Rs("maxday")
	refundday = Rs("refundday")
	paymentRules = Rs("paymentRules")
	dayrentprice = Rs("dayrentprice")
	weekrentprice = Rs("weekrentprice")
	monthrentprice = Rs("monthrentprice")

End Sub

Sub validateSubmit()

End Sub

Sub validateDraft()

End Sub




Sub Main()	
	
	Call ShowEdit()

End Sub

%>
<%
G_Title_Content = "Ԥ��"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<form class="validator"  action="?act=save" method="post" id="productForm" name="productForm">
<div class="area">
	
    <div class="Details-tit">
    	<span class="t6"><b><a href="pstep1.asp?pid=<%=pid%>">��������</a></b></span>
        <span class="t8"><b><a href="pstep2.asp?pid=<%=pid%>">�ϴ���Ƭ</a></b></span>
        <span class="t10"><b><a href="pstep3.asp?pid=<%=pid%>">��ʩ����</a></b></span>
        <span class="t12"><b><a href="pstep4.asp?pid=<%=pid%>">��ʩ����</a></b></span>
        <span class="t13"><b>Ԥ��</b></span>
    </div>
    
	<!--#include file="common/inc/publish_header.asp"-->
    
    <div class="layer2">
   
        <div class="side-top"></div>
        <div class="side-center">
            <div class="Preview-1">
                <h4 class="title"><span>��������</span><a href="pstep1.asp?pid=<%=pid%>">�޸�</a>
                    <div class="grade_view" id="_View_Detail" style="display:none;"><span class="grade_word">�÷֣�</span><span class="grade_score">49.2��</span></div>
                </h4>
                <div class="roomcon-l">
                    <ul>
					<%
					if hid<>0 then
						Sql = "Select * from T_hotel where h_uid="&Session("_UserID")&" and h_id="&hid
						Set Rs = Dream3CLS.Exec(Sql)
						if not Rs.eof then
					%>
						<li><span>�Ƶ����ƣ�</span><%=Rs("h_hotelname")%></li>
					<%end if
					end if
					%>
						<li><span>������⣺</span><%=houseTitle%></li>
				
                        <li><span>�����</span><%=area%>ƽ��</li>
                        <li><span>��ס������</span><%=guestnum%>��</li>
                        <li><span>��������</span><%=roomsnum%>��</li>
                        <li><span>������</span><%=bednum%>��</li>
                        <li><span>���ͣ�</span>˫�˴����У�</li>
                        <li><span>����������</span><%=toiletnum%>��</li>
						<li><span>��Ч���ڣ�</span><%=startDate%></li>
                        <li><span>��Ч������</span><%=expireDate%></li>
                    </ul>
                </div>
                <div class="roomcon-r">
                    <p>������ܣ�<span id="_DataScore_View_RoomIntroduce"><%=roomdesc%></span></p>
                    <!--<p>��ͨ·�ߣ�<%=userule%></p>-->
                </div>
            </div>
            <div class="clear"></div>
        </div>
        <div class="side-bottom"></div>
        
        <div class="side-top"></div>
        <div class="side-center">
            <div class="Preview-1">
                <h4 class="title"><span>�ϴ���Ƭ</span><a href="pstep2.asp?pid=<%=pid%>">�޸�</a>
                    <div class="grade_view" id="_View_Imgs" style="display:none;"><span class="grade_word">�÷֣�</span><span class="grade_score">37.39��</span></div>
                </h4>
                <div style="position: relative; border: 1px solid #ccc; padding:2px; float:left;">
                    <img width="284px" height="211px" id="bigImage" src="<%=img1%>">
                </div>
                <dl class="Preview-pic">
					<%
					If img1 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img1%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img2 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img2%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img3 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img3%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img4 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img4%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img5 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img5%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img6 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img6%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img7 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img7%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img8 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img8%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img9 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img9%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img10 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img10%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
            	</dl>
            </div>
            <div class="clear"></div>
        </div>
        <div class="side-bottom"></div>
        
        <div class="side-top"></div>
        <div class="side-center">
           <div class="Preview-1">
           		<h4 class="title"><span>��ʩ����</span><a href="pstep3.asp?pid=<%=pid%>">�޸�</a></h4>
                <div class="ser-checkin">
					<%
					Set f_Rs = Server.CreateObject("adodb.recordset")	
					Sql = "select id,cname from T_Facility Where enabled='Y' order by seqno desc"		
					f_Rs.open Sql,conn,1,1
					
					Do While Not f_rs.EOF
						If instr(facilities,","&f_Rs("id")&",") Then
							facilitySelect = true
						Else
							facilitySelect = false
						End If
					%>
                    <span <%If Not facilitySelect Then%>class="no"<%End If%>><%=f_rs("cname")%></span>
                    <%
						f_rs.Movenext
					Loop
					%>
                </div>
            </div>
            <div class="clear"></div>
        </div>
        <div class="side-bottom"></div>
        
        <div class="side-top"></div>
        <div class="side-center">
           <div class="Preview-1">
                <h4 class="title">
                    <span>��ס��۸�</span>
                    <a href="pstep4.asp?pid=<%=pid%>">�޸�</a>
                    <div class="grade_view" id="_View_Days" style="display:none;"><span class="grade_word">�÷֣�</span><span class="grade_score">100.00��</span><span class="grade_score">&nbsp;̫����!</span></div>
                </h4>
                <div class="roomcon-l">
                    <ul>
                        <li><span>��סʱ�䣺</span><%=checkintime%></li>
                        <li><span>�˷�ʱ��:</span><%=checkouttime%></li>
                        <li><span>����������</span><%=minday%></li>
                        <li><span>���������</span>
                        <%If maxday=0 Then%>������<%Else%><%=maxday%><%End If%>
                        </li>
                        <li style="display:none "><span>ȫ���˿��գ�</span><%=refundday%>��</li> 
                        <li>
						<span style="display:none ">�������</span>
						<%
						if paymentRules = "moststrict" Then
							'response.Write("�ϸ�")
						Elseif paymentRules = "morestrict" Then
							'response.Write("�Ƚ��ϸ�")
						Elseif paymentRules = "middle" Then
							'response.Write("�е�")
						Elseif paymentRules = "moreloose" Then
							'response.Write("�ȽϿ���")
						Elseif paymentRules = "mostloose" Then
							'response.Write("����")
						End If
						%>
						
						</li> 
                    </ul>
                </div>
                <div class="roomcon-r">
                    <p>����ۣ�<b class="blue"><%=dayrentprice%>Ԫ</b>/ÿ��</p>
                    <p>��ĩ�ۣ�
					<%If weekrentprice = 0 Then%>
					δ����
					<%Else%>
					<b class="blue"><%=weekrentprice%></b>Ԫ/ÿ��
					<%End If%>
					</p>
                    <p>����ۣ�
					<%If monthrentprice = 0 Then%>
					δ����
					<%Else%>
					<b class="blue"><%=monthrentprice%>Ԫ</b>/ÿ��
					<%End If%>
					
					</p>
            	</div>
            </div>
            <div class="clear"></div>
        </div>
        <div class="side-bottom"></div>
        
        <div class="side-top"></div>
        <div class="side-center">
            <b>���׹���</b>��<br>
            <ul style="list-style-type:disc;">
                <li>����ķ�����ú�Ѻ�𲻰������ܷ����ڣ��ɷ���������ȡ��</li>
            </ul> 
        </div>
        <div class="clear"></div>
        <div class="side-bottom"></div>
        
    </div>
    
    <div class="tj-btn">
        <dl class="right">
            <dd class="font14_white"><a class="btn2" href="pstep4.asp?act=showedit&pid=<%=pid%>">��һ��</a></dd>
			<dd><input type="submit" id="searchBt" value="�ύ" class="input_next"></dd>
        </dl>
        <div class="clear"></div>
    </div>
    
</div>
<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
</form>
<!--#include file="common/inc/footer_user.asp"-->