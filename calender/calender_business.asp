
<%
Dim yearDetect,monthDetect
		if month(now)=12 then		
		yearDetect = cstr(year(now)+1)
		monthDetect = cstr(1)
		Else
		yearDetect = cstr(year(now))
		monthDetect = cstr(month(now)+1)
		End if
		'response.write( " <script   language=vbscript> msgbox("&monthDetect&")</script> ") 

		Sql = "Select * from T_SpecialPrice Where product_id="+cstr(pid)
		Sql = Sql&" and  date< '"&Dateadd("d",62,date())&"' and date> = '"&date()&"'"
		
		
		Set priceRs = Dream3CLS.Exec(Sql)
		
		
		Sub dislplayCalender(monthIndex)	
			Dim dateCount ,priceString,firstDatePosition,dateString
			Dim monthDay, dt1, dt2,dt3
			
			monthIndex=cint(monthIndex)
			if monthIndex = 1 then
			''���µ����ݴ���
				dateString = year(now)&"-"&month(now)&"-1"	
				priceFirstDatePosition = day(now)
				'��ñ�������
				dt1 = Date
				dt1 = CDate(Year(dt1) & "-" & Month(dt1) & "-1") ' �õ����µ�һ��
				dt2 = DateAdd("m", 1, dt1) ' �õ��¸��µ�һ��
				monthDay = DateDiff("d", dt1, dt2) ' �õ������µĲ�
				
			else if monthIndex = 2 then
			''���µ����ݴ���
				dateString = yearDetect&"-"&monthDetect&"-1"
				priceFirstDatePosition = 0
				'�����������
				dt1 = Date
				dt1 = CDate(Year(dt1) & "-" & Month(dt1) & "-1") ' �õ����µ�һ��
				dt2 = DateAdd("m", 1, dt1) ' �õ��¸��µ�һ��
				dt3 = DateAdd("m", 2, dt1) ' �õ����¸��µ�һ��
				monthDay = DateDiff("d", dt2, dt3) ' �õ������µĲ�
				
				end if
			end if
		
			'���ÿ���µĵ�һ�������ڼ� ���ڶ�λ��һ���λ��
			monthFirstDatePosition = Weekday(CDate(dateString))-1
			
			'ÿ�µ�һ��ǰ�ĸ�����Ϊ��
			dateCount = 0			
			For K = 0 To monthFirstDatePosition - 1
				response.write"<td ><span class=dom></span></td>"
			Next
				
						
			
			Do While dateCount < monthDay
			
			If CLng(monthFirstDatePosition+dateCount) mod 7 =0 Then
				response.write("<tr></tr>")
			End If
			
	
			If dateCount < priceFirstDatePosition - 1 Then
			response.write"<td class=in_the_past><span class=dom>"	
			Else
			'��ĩ��ʾ��ͬ��ɫ
				if  CLng(monthFirstDatePosition+dateCount) mod 7 =5 or  CLng(monthFirstDatePosition+dateCount) mod 7 = 6 then
				response.write"<td class=available_weekend><span class=dom>"
				else
				response.write"<td class=available><span class=dom>"
				end if
			End If		
			
			response.write(dateCount+1)
			
			If dateCount < priceFirstDatePosition - 1 Then
			response.write"</span></td>"
			Else
				If Not priceRs.EOF then
				
				priceString = Cstr( priceRs("price"))	
				priceRs.Movenext
				end if
			
			response.write"</span><div class=extra01>&nbsp;</div><div class=extra02><span class=dom03>��</span>"
			response.write"<input id="+Cstr(monthIndex)+Cstr(dateCount)+"  type=text value="+priceString+" style=width:30px "
			
				If monthIndex = 1 then
				response.write"onchange='change_price_commit("+Cstr(pid)+","""+Cstr(DateAdd("d", dateCount, dt1))+""","+Cstr(monthIndex)+Cstr(dateCount)+","+priceString+")'></div></td>"
				Else 
				response.write"onchange='change_price_commit("+Cstr(pid)+","""+Cstr(DateAdd("d", dateCount, dt2))+""","+Cstr(monthIndex)+Cstr(dateCount)+","+priceString+")'></div></td>"
				End if
			
			End If
			
			dateCount = dateCount + 1
			Loop
			
		End Sub
		
		
		
		%>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link href="./calender/calender.css" style="text/css" rel="stylesheet"/>
<script type="text/javascript" src="./calender/calender.js"></script>


<div class="fyxqy_main_left">
  <div class="fyxqy_m_r_box">
  
<div class="fyxqy_m_r_b_rl" id="rilishow" style="display: block;">
 <div class="fyxqy_m_r_b_rl_left">
  <div class="ri_com">

<div class="ri_com_sele">

 
 <div class="datemid">
 <form name="monthSelectForm" >
 <input type="radio" name="month_select" id="month_select1" checked="true" onclick ="preMonth()" value="1"/><label for="month_select1" ><%=year(now)%>��<%=month(now)%>��</label>
 <input type="radio" name="month_select" id="month_select2" onclick="postMonth()" value="2"/><label for="month_select2" ><%=yearDetect%>��<%=monthDetect%>��</label>
 </form>
 </div>

  
 
</div>

<div class="ri_com_ripic" name = "preMonth" id = "preMonth">
 <table cellspacing="0">
 	<tbody>
 		<tr><th>������</th><th>����һ</th><th>���ڶ�</th><th>������</th><th>������</th><th>������</th><th>������</th></tr>

		<tr>
		<%
		dislplayCalender(1)	
		%>
		</tr>	
	 
    </tbody>
 </table>

</div>

<div class="ri_com_ripic" name = "postMonth" id = "postMonth" style="display:none">
 <table cellspacing="0">
 	<tbody>
 		<tr><th>������</th><th>����һ</th><th>���ڶ�</th><th>������</th><th>������</th><th>������</th><th>������</th></tr>
 		
		<tr>
		<%		
		dislplayCalender(2)		
		%>
		</tr>	
	 
        </tbody>
 </table>

</div>

  </div>
 </div>


</div>
</div>
</div>
 
 
<script type="text/javascript">
function preMonth(){
	
	document.getElementById("postMonth").style.display = "none";
	document.getElementById("preMonth").style.display = "";
}
function postMonth(){
	
	document.getElementById("preMonth").style.display = "none";
	document.getElementById("postMonth").style.display = "";
}

</script>