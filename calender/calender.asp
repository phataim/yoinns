
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

		Sql = "Select * from T_SpecialPrice Where product_id="+cstr(detail_id)
		Sql = Sql&" and  date< '"&Dateadd("d",62,date())&"' and date> = '"&date()&"'"
		
		
		Set priceRs = Dream3CLS.Exec(Sql)
		
		
		Sub dislplayCalender(monthIndex)	
			Dim dateCount ,priceString,firstDatePosition,dateString
			Dim monthDay, dt1, dt2,dt3
			
			monthIndex=cint(monthIndex)
			if monthIndex = 0 then
			''本月的数据处理
				dateString = year(now)&"-"&month(now)&"-1"	
				priceFirstDatePosition = day(now)
				'获得本月天数
				dt1 = Date
				dt1 = CDate(Year(dt1) & "-" & Month(dt1) & "-1") ' 得到本月第一天
				dt2 = DateAdd("m", 1, dt1) ' 得到下个月第一天
				monthDay = DateDiff("d", dt1, dt2) ' 得到两个月的差
				
			else if monthIndex = 1 then
			''下月的数据处理
				dateString = yearDetect&"-"&monthDetect&"-1"
				priceFirstDatePosition = 0
				'获得下月天数
				dt1 = Date
				dt1 = CDate(Year(dt1) & "-" & Month(dt1) & "-1") ' 得到本月第一天
				dt2 = DateAdd("m", 1, dt1) ' 得到下个月第一天
				dt3 = DateAdd("m", 2, dt1) ' 得到下下个月第一天
				monthDay = DateDiff("d", dt2, dt3) ' 得到两个月的差
				
				end if
			end if
		
			monthFirstDatePosition = Weekday(CDate(dateString))-1
			
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
			'周末显示不同颜色
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
			
			response.write"</span><div class=extra01>&nbsp;</div><div class=extra02><span class=dom03>￥</span>"+priceString+"</div></td>"
			End If
			
			dateCount = dateCount + 1
			Loop
			
		End Sub
		
		
		
		%>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link href="./calender.css" style="text/css" rel="stylesheet"/>
<script type="text/javascript" src="./calender.js"></script>




<div class="fyxqy_main_left">
  <div class="fyxqy_m_r_box">
  
<div class="fyxqy_m_r_b_rl" id="rilishow" style="display: block;">
 <div class="fyxqy_m_r_b_rl_left">
  <div class="ri_com">

<div class="ri_com_sele">

 
 <div class="datemid">
 <form name="monthSelectForm" >
 <input type="radio" name="month_select" id="month_select1" checked="true" onclick ="preMonth()" value="1"/><label for="month_select1" ><%=year(now)%>年<%=month(now)%>月</label>
 <input type="radio" name="month_select" id="month_select2" onclick="postMonth()" value="2"/><label for="month_select2" ><%=yearDetect%>年<%=monthDetect%>月</label>
 </form>
 </div>

  
 
</div>

  <div class="ri_com_sele" >
	<div class="iconright">
			<img src="../calender/calender_roomstate01.png" style="width:20px;height:20px;margin-top:5px"> 平时价
			<img src="../calender/calender_roomstate02.png" style="width:20px;height:20px;margin-top:5px"> 周末价
			<img src="../calender/calender_roomstate03.png" style="width:20px;height:20px;margin-top:5px"> 无房
     
	  </div>
 </div>

<div class="ri_com_ripic" name = "preMonth" id = "preMonth">
 <table cellspacing="0">
 	<tbody>
 		<tr><th>星期日</th><th>星期一</th><th>星期二</th><th>星期三</th><th>星期四</th><th>星期五</th><th>星期六</th></tr>

		<tr>
		<%
		dislplayCalender(0)	
		%>
		</tr>	
	 
    </tbody>
 </table>

</div>

<div class="ri_com_ripic" name = "postMonth" id = "postMonth" style="display:none">
 <table cellspacing="0">
 	<tbody>
 		<tr><th>星期日</th><th>星期一</th><th>星期二</th><th>星期三</th><th>星期四</th><th>星期五</th><th>星期六</th></tr>
 		
		<tr>
		<%		
		dislplayCalender(1)		
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