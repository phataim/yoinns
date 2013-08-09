<%
Class  Dream3_Static

  	Private Sub Class_Initialize()
 		
	End Sub
	
	'������������
	public Function InitLodgeTypeArr()
		Dim s_arr(16,2)
		s_arr(0,0) = "house"
		s_arr(0,1) = "���"
		s_arr(1,0) = "apartment"
		s_arr(1,1) = "��Ԣ"
		s_arr(2,0) = "mcmansions"
		s_arr(2,1) = "��������"
		s_arr(3,0) = "hotel"
		s_arr(3,1) = "�ù�"
		s_arr(4,0) = "tavern"
		s_arr(4,1) = "��ջ"
		s_arr(5,0) = "loft"
		s_arr(5,1) = "��������"
		s_arr(6,0) = "courtyard"
		s_arr(6,1) = "�ĺ�Ժ"
		s_arr(7,0) = "seasidecottage"
		s_arr(7,1) = "����С��"
		s_arr(8,0) = "dormitory"
		s_arr(8,1) = "��������"
		s_arr(9,0) = "woodscottage"
		s_arr(9,1) = "�ּ�С��"
		s_arr(10,0) = "luxuryhouse"
		s_arr(10,1) = "��լ"
		s_arr(11,0) = "castle"
		s_arr(11,1) = "�Ǳ�"
		s_arr(12,0) = "treehouse"
		s_arr(12,1) = "����"
		s_arr(13,0) = "cabin"
		s_arr(13,1) = "����"
		s_arr(14,0) = "carhouse"
		s_arr(14,1) = "����"
		s_arr(15,0) = "icehouse"
		s_arr(15,1) = "����"
        InitLodgeTypeArr =  s_arr  
	End Function
	
	'��ȡ��������������
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
	
	'��ȡ��������
	private Function InitMap(s_map,s_arr)
		Dim array_temp
		array_temp = s_arr
		For   s_i   =   0   to   UBound(array_temp,1) -1
			s_map.putv array_temp(s_i,0),array_temp(s_i,1)
		Next
		               
	End Function
	
	'��ȡ��������
	Public Function GetLodgeType(f_lodgeType_key)
		Set logdgeTypeMap = new AspMap
		InitMap logdgeTypeMap,InitLodgeTypeArr()
		GetLodgeType = logdgeTypeMap.getv(f_lodgeType_key)
	End Function
	
	
	'������������
	public Function InitLeaseTypeArr()
		Dim s_arr(3,2)
		s_arr(0,0) = "whole"
		s_arr(0,1) = "����"
		s_arr(1,0) = "room"
		s_arr(1,1) = "�������"
		s_arr(2,0) = "bed"
		s_arr(2,1) = "��λ����"
		
        InitLeaseTypeArr =  s_arr  
	End Function
	
	'��ȡ��������������
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
	
	'��ȡ��������
	Public Function GetLeaseType(f_leaseType_key)
		Set leaseTypeMap = new AspMap
		InitMap leaseTypeMap,InitLeaseTypeArr
		GetLeaseType = leaseTypeMap.getv(f_leaseType_key)
	End Function
	
	'���ⴲ������
	public Function InitBedTypeArr()
		Dim s_arr(16,2)
		s_arr(0,0) = "double-max"
		s_arr(0,1) = "˫�˴�����"
		s_arr(1,0) = "double-med"
		s_arr(1,1) = "˫�˴����У�"
		s_arr(2,0) = "double-small"
		s_arr(2,1) = "˫�˴���С��"
		s_arr(3,0) = "single"
		s_arr(3,1) = "���˴�"
		s_arr(4,0) = "canopy"
		s_arr(4,1) = "���Ӵ�"
		s_arr(5,0) = "sofa"
		s_arr(5,1) = "ɳ����"
		s_arr(6,0) = "tatami"
		s_arr(6,1) = "����"
		s_arr(7,0) = "airbed"
		s_arr(7,1) = "���洲"
		s_arr(8,0) = "waterbed"
		s_arr(8,1) = "ˮ��"
		
        InitBedTypeArr =  s_arr  
	End Function
	
	'��ȡ����
	Public Function GetBedType(f_bedType_key)
		Set bedTypeMap = new AspMap
		InitMap bedTypeMap,InitBedTypeArr
		GetBedType = bedTypeMap.getv(f_bedType_key)
	End Function
	
	

	

	
End Class

Dim Dream3Static
Set Dream3Static = New Dream3_Static

%>