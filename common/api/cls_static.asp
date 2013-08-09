<%
Class  Dream3_Static

  	Private Sub Class_Initialize()
 		
	End Sub
	
	'房屋类型数组
	public Function InitLodgeTypeArr()
		Dim s_arr(16,2)
		s_arr(0,0) = "house"
		s_arr(0,1) = "民居"
		s_arr(1,0) = "apartment"
		s_arr(1,1) = "公寓"
		s_arr(2,0) = "mcmansions"
		s_arr(2,1) = "独栋别墅"
		s_arr(3,0) = "hotel"
		s_arr(3,1) = "旅馆"
		s_arr(4,0) = "tavern"
		s_arr(4,1) = "客栈"
		s_arr(5,0) = "loft"
		s_arr(5,1) = "独栋别墅"
		s_arr(6,0) = "courtyard"
		s_arr(6,1) = "四合院"
		s_arr(7,0) = "seasidecottage"
		s_arr(7,1) = "海边小屋"
		s_arr(8,0) = "dormitory"
		s_arr(8,1) = "集体宿舍"
		s_arr(9,0) = "woodscottage"
		s_arr(9,1) = "林间小屋"
		s_arr(10,0) = "luxuryhouse"
		s_arr(10,1) = "豪宅"
		s_arr(11,0) = "castle"
		s_arr(11,1) = "城堡"
		s_arr(12,0) = "treehouse"
		s_arr(12,1) = "树屋"
		s_arr(13,0) = "cabin"
		s_arr(13,1) = "船舱"
		s_arr(14,0) = "carhouse"
		s_arr(14,1) = "房车"
		s_arr(15,0) = "icehouse"
		s_arr(15,1) = "冰屋"
        InitLodgeTypeArr =  s_arr  
	End Function
	
	'获取房屋类型下拉框
	public Function GetLodgeTypeCombo(s_selected)
		Dim s_str
		array_temp = InitLodgeTypeArr()
		For   s_i   =   0   to   UBound(array_temp,1)  -1 
			's_map.putv array_temp(s_i,0),array_temp(s_i,1)
			If array_temp(s_i,0) = CStr(s_selected) Then
				isSelected = "selected"
			Else
				isSelected = ""
			End If
			s_str = s_str & "<option "&isSelected&" value='"&array_temp(s_i,0)&"'>"&array_temp(s_i,1)&"</option>"
		Next
		GetLodgeTypeCombo = s_str            
	End Function
	
	'获取房屋类型
	private Function InitMap(s_map,s_arr)
		Dim array_temp
		array_temp = s_arr
		For   s_i   =   0   to   UBound(array_temp,1) -1
			s_map.putv array_temp(s_i,0),array_temp(s_i,1)
		Next
		               
	End Function
	
	'获取房屋类型
	Public Function GetLodgeType(f_lodgeType_key)
		Set logdgeTypeMap = new AspMap
		InitMap logdgeTypeMap,InitLodgeTypeArr()
		GetLodgeType = logdgeTypeMap.getv(f_lodgeType_key)
	End Function
	
	
	'出租类型数组
	public Function InitLeaseTypeArr()
		Dim s_arr(3,2)
		s_arr(0,0) = "whole"
		s_arr(0,1) = "整租"
		s_arr(1,0) = "room"
		s_arr(1,1) = "单间出租"
		s_arr(2,0) = "bed"
		s_arr(2,1) = "床位出租"
		
        InitLeaseTypeArr =  s_arr  
	End Function
	
	'获取房屋类型下拉框
	public Function GetLeaseTypeCombo(s_selected)
		Dim s_str
		array_temp = InitLeaseTypeArr()
		For   s_i   =   0   to   UBound(array_temp,1)  -1 
			's_map.putv array_temp(s_i,0),array_temp(s_i,1)
			If array_temp(s_i,0) = CStr(s_selected) Then
				isSelected = "selected"
			Else
				isSelected = ""
			End If
			s_str = s_str & "<option "&isSelected&" value='"&array_temp(s_i,0)&"'>"&array_temp(s_i,1)&"</option>"
		Next
		GetLeaseTypeCombo = s_str            
	End Function
	
	'获取出租类型
	Public Function GetLeaseType(f_leaseType_key)
		Set leaseTypeMap = new AspMap
		InitMap leaseTypeMap,InitLeaseTypeArr
		GetLeaseType = leaseTypeMap.getv(f_leaseType_key)
	End Function
	
	'出租床型数组
	public Function InitBedTypeArr()
		Dim s_arr(16,2)
		s_arr(0,0) = "double-max"
		s_arr(0,1) = "双人床（大）"
		s_arr(1,0) = "double-med"
		s_arr(1,1) = "双人床（中）"
		s_arr(2,0) = "double-small"
		s_arr(2,1) = "双人床（小）"
		s_arr(3,0) = "single"
		s_arr(3,1) = "单人床"
		s_arr(4,0) = "canopy"
		s_arr(4,1) = "架子床"
		s_arr(5,0) = "sofa"
		s_arr(5,1) = "沙发床"
		s_arr(6,0) = "tatami"
		s_arr(6,1) = "榻榻米"
		s_arr(7,0) = "airbed"
		s_arr(7,1) = "气垫床"
		s_arr(8,0) = "waterbed"
		s_arr(8,1) = "水床"
		
        InitBedTypeArr =  s_arr  
	End Function
	
	'获取床型
	Public Function GetBedType(f_bedType_key)
		Set bedTypeMap = new AspMap
		InitMap bedTypeMap,InitBedTypeArr
		GetBedType = bedTypeMap.getv(f_bedType_key)
	End Function
	
	

	

	
End Class

Dim Dream3Static
Set Dream3Static = New Dream3_Static

%>