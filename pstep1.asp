<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<%
Dim Action
Dim pid
Dim leaseType
Dim houseTitle,area,guestnum,toiletnum,roomdesc,userule,bedtype,roomsnum,bednum,expireDate,startDate,userid
dim hid,hotelname,searchr,r_pid,states

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
	r_pid=Dream3CLS.ChkNumeric(Request.Form("r_pid"))
	hid = Dream3CLS.RParam("hotelname")
	houseTitle = Dream3CLS.RParam("houseTitle")
	area = Dream3CLS.RParam("area")
	guestnum = Dream3CLS.RParam("guestnum")
	bednum = Dream3CLS.RParam("bednum")
	roomsnum = Dream3CLS.RParam("roomsnum")
	bedtype = Dream3CLS.RParam("bedtype")
	toiletnum = Dream3CLS.RParam("toiletnum")
	
	startDate = Dream3CLS.RParam("startDate")
	expireDate= Dream3CLS.RParam("expireDate")
	
	roomdesc = Dream3CLS.RParam("roomdesc")
	userule = Dream3CLS.RParam("userule")
	
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
			Sql = Sql & " Where ID="&pid
		Else
			Sql = Sql & " Where ID="&pid&" and user_id="&Session("_UserID")
		End If
	End If
	
	Rs.open Sql,conn,1,2
	If pid = 0  Then 
		Rs.AddNew
	End If
	Rs("hid") =hid
	Rs("user_id") =Session("_UserID")
	Rs("houseTitle") = houseTitle
	Rs("area") = area
	Rs("guestnum") = guestnum
	Rs("toiletnum") = toiletnum
	Rs("roomdesc") = roomdesc
	Rs("userule") = userule
	Rs("bedtype") = bedtype
	Rs("roomsnum") = roomsnum
	Rs("bednum") = bednum
	Rs("expireDate") =expireDate 
	Rs("startDate") = startDate
	Rs("create_time") = now()
	Rs("state") = "pending" 
	
	Rs.Update
	pid=Rs("id")
	Rs.Close
	Set Rs = Nothing
	
	
	
	
	if states=0 then
	Set Rs = Server.CreateObject("Adodb.recordset")
		if r_pid<>"" then
			Sql = "delete from T_room where r_pid="&r_pid
			Dream3CLS.Exec(sql)
		end if
		If roomsnum <> 0  Then
			Sql = "Select * from T_room"
			Rs.open Sql,conn,1,2 
			for i = 1 to roomsnum
				Rs.AddNew
				Rs("r_pid") =pid
				Rs.Update
			next
		
		Rs.Close
		Set Rs = Nothing
		end if
	end if
	
	
	directPage = "pstep2.asp?pid="&pid
	
	response.Redirect(directPage)
	
End Sub

Sub ShowEdit()
	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	states=0
	if pid=0 then
		Sql = "Select * from T_hotel where h_uid="&Session("_UserID")
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			directPage = VirtualPath&"/hotelsend.asp"
			response.Redirect(directPage)
			response.End()
		End If
	End If
	if pid<>0 then
		Sql = "Select * from T_Product Where id="&pid
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��"&pid,0,"0")
			response.End()
		End If
		hid = Rs("hid")
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
		startDate = Rs("startDate")
		Sqls = "Select * from T_hotel Where h_id="&hid
		Set Rss = Dream3CLS.Exec(Sqls)
		hotelname=Rss("h_hotelname")
		userid=Rss("h_uid")
		Sql = "Select r_pid,r_state from T_room where r_pid="&pid
		Set Rs = Dream3CLS.Exec(Sql)
		do while not Rs.eof
			states=Rs("r_state")
			r_pid=Rs("r_pid")
			If states=1 then
				Rs.movelast
			end if
			Rs.movenext
		loop
		
	end if
End Sub

Sub validateSubmit()
	If Trim(houseTitle) = "" Then
		gMsgArr = gMsgArr&"|�����뷿����⣡"
	End If
	
	If  Len(houseTitle) > 20   Then
		gMsgArr = gMsgArr&"|������ⲻ�ܳ���20���ַ���"
	End If
	
	If Trim(area) = "" Then
		gMsgArr = gMsgArr&"|�����뷿�������"
	End If
	
	If Trim(startDate) = "" Then
		gMsgArr = gMsgArr&"|��������Ч���ڣ�"
	End If
	
	If Trim(expireDate) = "" Then
		gMsgArr = gMsgArr&"|��������Ч�ڣ�"
	Else
		If DateDiff("d",expireDate,now) >0   Then
			gMsgArr = gMsgArr&"|ʧЧ���ڲ���С�ڵ�ǰʱ�䣡"
		End If
	End If
	
	If DateDiff("d",startDate,expireDate) < 1 Then
		gMsgArr = gMsgArr&"|ʧЧ���ڲ���С����Ч���ڣ�"
	End If
	
	If Trim(roomdesc) = "" Then
		gMsgArr = gMsgArr&"|�����뷿��������"
	End If
	If  Len(roomdesc) < 20   Then
		gMsgArr = gMsgArr&"|����������������20���ַ���"
	End If
	
	If  Len(userule) > 100   Then
		gMsgArr = gMsgArr&"|ʹ�ù����ܳ���100���ַ���"
	End If
	

	
End Sub

Sub validateDraft()

End Sub

Sub Main()	
	 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''��ү����������'''''''''''''''''''''''''''''''''''''''
	        Sql = "Select * From T_User Where id = "&session("_UserID")
	  		Set Rs = Dream3CLS.Exec(Sql)
			states = Rs("state")
			if states=1 then response.Redirect("../../index.asp")
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Call ShowEdit()

End Sub

%>
<%
G_Title_Content = "���ùݷ��䷢��ϵͳ"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="common/js/tools.js"></script>
<script type="text/javascript" src="common/js/time.js"></script> 
<script type="text/javascript" src="<%=VirtualPath%>/xheditor/xheditor-zh-cn.min.js"></script>
<form class="validator"  action="?act=save" method="post" id="productForm" name="productForm">
<div class="area">
	<br><a href="user\account\zhifubiangeng.html" target="_blank"><strong><span style="color:red">�����ùݡ�֧����ʽ���!</span></strong> </a></br>
    <div class="Details-tit">
        <span class="t1"><b>��������</b></span>
        <span class="t2"><b>�ϴ���Ƭ</b></span>
        <span class="t3"><b>��ʩ����</b></span>
        <span class="t4"><b>��ס��۸�</b></span>
        <span class="t5"><b>Ԥ��</b></span>
    </div>
    
	<!--#include file="common/inc/publish_header.asp"-->
	
    <div class="layer2">
        <div class="side-top"></div>
        <div class="side-center">
            <div class="detail-left">
                <h4 class="title">��������</h4>
                <dl>
				<%
				Sql = "Select * from T_hotel where h_uid="&Session("_UserID")
				Set Rs = Dream3CLS.Exec(Sql)
				if hid=0 then
				%>
					<dd>
                    <label>�����Ƶ꣺</label>
                    <select name="hotelname">
						<%do while not Rs.EOF%>
                    	<option value ="<%=Rs("h_id")%>"><%=Rs("h_hotelname")%></option>
						<%
						Rs.movenext
						loop
						Rs.close
						%>
                    </select>
                    </dd>
				<%else
				Sql = "Select * from T_hotel where h_uid="&Session("_UserID")
				Set Rs = Dream3CLS.Exec(Sql)
				%>
				<dd>
                    <label>�����Ƶ꣺</label>
                    <select name="hotelname">
					<%do while not Rs.EOF%>
                    	<option value ="<%=Rs("h_id")%>"<% if hid = Rs("h_id") then %> selected="selected" <%end if%>><%=Rs("h_hotelname")%></option>
						<%
						Rs.movenext
						loop
						Rs.close
						%>
                    </select></dd>
				<%end if%>
                   
				<dd>
                    <label>�������ͣ�</label>
                    <input type="txt" class="radius input" value="<%=houseTitle%>" name="houseTitle"><span style="color:red">&nbsp;&nbsp;*��󴲷������Է���˫�˷���</span> <span id="tip_roomtitle"></span>
                    </dd>
					
                    <dd>
                    <label>�����</label>
                    <input type="txt" onkeypress="NumericKeyPress(10,2)" onkeyup="NumericKeyUp(10,2)"
 onblur="NumericKeyUp(10,2)" style="width:54px" class="radius input" value="<%=area%>" name="area"> ƽ��<span style="color:red">&nbsp;&nbsp;*</span><span id="tip_area"></span>
                    </dd>
                    <dd>
                    <label>��ס������</label>
                    <select name="guestnum">
                    	<option value ="1" <%If guestnum="1" then Response.Write("selected")%>>1</option>
						<option value ="2" <%If guestnum="2" then Response.Write("selected")%>>2</option>
						<option value ="3" <%If guestnum="3" then Response.Write("selected")%>>3</option>
						<option value ="4" <%If guestnum="4" then Response.Write("selected")%>>4</option>
						<option value ="5" <%If guestnum="5" then Response.Write("selected")%>>5</option>
						<option value ="6" <%If guestnum="6" then Response.Write("selected")%>>6</option>
						<option value ="7" <%If guestnum="7" then Response.Write("selected")%>>7</option>
						<option value ="8" <%If guestnum="8" then Response.Write("selected")%>>8</option>
						<option value ="9" <%If guestnum="9" then Response.Write("selected")%>>9</option>
						<option value ="10" <%If guestnum="10" then Response.Write("selected")%>>10</option>
                        <option value ="11" <%If guestnum="11" then Response.Write("selected")%>>����10</option>
                    </select><span style="color:red">&nbsp;&nbsp;*</span>
                    </dd>
                    <dd>
                    <label>��λ����</label>
                    <select name="bednum" autocomplete="off">
                    	<option value ="1" <%If bednum="1" then Response.Write("selected")%>>1</option>
						<option value ="2" <%If bednum="2" then Response.Write("selected")%>>2</option>
						<option value ="3" <%If bednum="3" then Response.Write("selected")%>>3</option>
						<option value ="4" <%If bednum="4" then Response.Write("selected")%>>4</option>
						<option value ="5" <%If bednum="5" then Response.Write("selected")%>>5</option>
						<option value ="6" <%If bednum="6" then Response.Write("selected")%>>6</option>
						<option value ="7" <%If bednum="7" then Response.Write("selected")%>>7</option>
						<option value ="8" <%If bednum="8" then Response.Write("selected")%>>8</option>
						<option value ="9" <%If bednum="9" then Response.Write("selected")%>>9</option>
						<option value ="10" <%If bednum="10" then Response.Write("selected")%>>10</option>
                        <option value ="11" <%If bednum="11" then Response.Write("selected")%>>����10</option>
                    </select><span style="color:red">&nbsp;&nbsp;*</span><span id="tip_bednum"></span>
                    </dd>
                    <input style="display:none;" value="1" id="bedroomnum" name="bedroomnum">
                    <dd>
                        <label>��������</label>
                        <input  type="text"  class="radius input" value="<%=roomsnum%>" name="roomsnum" id="roomsnum" onkeypress="NumericKeyPress(2,0)" onkeyup="NumericKeyUp(2,0)"
 onblur="NumericKeyUp(2,0)">
                         <span style="color:red">&nbsp;&nbsp;*</span><span id="tip_roomsnum"></span>
                 </dd>
                    <dd>
                    <label>���ͣ�</label>
                    <select name="bedtype">
                       <option value ="double-max"  <%If bedtype="double-max" then Response.Write("selected")%>>˫�˴�����</option>
					   <option value ="double-med"  <%If bedtype="double-med" then Response.Write("selected")%>>˫�˴����У�</option>
					   <option value ="double-small"  <%If bedtype="double-small" then Response.Write("selected")%>>˫�˴���С��</option>
					   <option value ="single"  <%If bedtype="single" then Response.Write("selected")%>>���˴�</option>
					   <option value ="canopy"  <%If bedtype="canopy" then Response.Write("selected")%>>���Ӵ�</option>
					   <option value ="sofa"  <%If bedtype="sofa" then Response.Write("selected")%>>ɳ����</option>
					   <option value ="tatami" <%If bedtype="tatami" then Response.Write("selected")%> >����</option>
					   <option value ="airbed"  <%If bedtype="airbed" then Response.Write("selected")%>>���洲</option>
					   <option value ="waterbed"  <%If bedtype="waterbed" then Response.Write("selected")%>>ˮ��</option>
                    </select><span style="color:red">&nbsp;&nbsp;*</span>
                    </dd>
                    <dd>
                    <label>����������</label>
                     <select name="toiletnum">
                        <option value="0" <%If toiletnum="0" then Response.Write("selected")%>>0</option>
					    <option value ="1" <%If toiletnum="1" then Response.Write("selected")%>>1</option>
						<option value ="2" <%If toiletnum="2" then Response.Write("selected")%>>2</option>
						<option value ="3" <%If toiletnum="3" then Response.Write("selected")%> >3</option>
						<option value ="4" <%If toiletnum="4" then Response.Write("selected")%>>4</option>
						<option value ="5" <%If toiletnum="5" then Response.Write("selected")%>>5</option>
						<option value ="6" <%If toiletnum="6" then Response.Write("selected")%>>6</option>
						<option value ="7" <%If toiletnum="7" then Response.Write("selected")%>>7</option>
						<option value ="8" <%If toiletnum="8" then Response.Write("selected")%>>8</option>
						<option value ="9" <%If toiletnum="9" then Response.Write("selected")%>>9</option>
						<option value ="10" <%If toiletnum="10" then Response.Write("selected")%>>10</option>
                     </select><span style="color:red">&nbsp;&nbsp;*ÿ�䷿����������</span><span id="tip_toiletnum"></span>
                    </dd>
					<dd>
                    <label>��ʼ���ڣ�</label>

					<input type="text" readonly="readonly"  id="startDate" name="startDate" value="<%=Date%>" onclick="WdatePicker({minDate:'%y-%M-%d'})"/>
					<!--class="hasDatepicker" onclick="return showCalendar('startDate', 'y-mm-dd');"  />-->
					<span style="color:red">&nbsp;&nbsp;*</span>
                    
                    </dd>
                    <dd>
                    <label>��Ч������</label>
					<input type="text" readonly="readonly"  id="expireDate" name="expireDate" value="<%=Date+365%>" onclick="WdatePicker({minDate:'#F{$dp.$D(\'startDate\',{d:+1})}'})"/>
					<!--class="hasDatepicker" onclick="return showCalendar('expireDate', 'y-mm-dd');"  />-->
					<span style="color:red">&nbsp;&nbsp;*</span>
                    
                    </dd>
                    <dd>
                    <span>��ʼ���ڱ�ʾ�÷�������쿪ʼ����Ԥ������Ϊ�����ں󷿼��Զ�ʧЧ������չʾ��</span>
                    </dd>
                </dl>
            </div>
            <div class="detail-right">
                <dl>
                    <dd>
                    <label>����������</label>
                    <textarea style="font-size:12px;" name="roomdesc" class="radius"><%=roomdesc%></textarea>
                    </dd>
                    <span><span style="color:red">*</span>����20����</span>
                    <dd style="margin-left:60px;width:150px;" id="tip_roomdesc"></dd>
                    <dd class="grade_dd" id="_RoomDesc"></dd>
                    
                    <dd>
                    <span><span style="color:red">*</span>Ϊ������</span>
                    </dd>
                </dl>
            </div>
            <div class="clear"></div>
            <div style="display:none;text-align:center;" id="iframesub_message"></div>
        </div>
        <div class="side-bottom"></div>
    </div>
	
    <div class="next">
        <dl>
        	<dt class="Button-3 font14_white"><a href="user/company/myhotel.asp">��������</a></dt>
        	<dd><input type="submit" id="searchBt" value="��һ��" class="input_next"></dd>
        </dl>
    </div>
    
    <div class="clear"></div>
    
</div>
<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
<input type="hidden" id="r_pid" name="r_pid" value="<%=r_pid%>"/>
</form>
<!--#include file="common/inc/footer_user.asp"-->