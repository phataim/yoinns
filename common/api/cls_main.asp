<%
Class  Dream3_Main
	Private LocalCacheName, Cache_Data,CacheData '用者用来缓存数据
	Public Reloadtime,Version,PathDoMain
	Public Dream3_Sys,Dream3_OtherPay,Dream3_QuartzDate,Dream3SDM
	Public SiteSettings,SiteSettingsXML,XMLDOM,SiteConfigXMLDOM
	
  	Private Sub Class_Initialize()
 		LoadConfig()
	End Sub
	
	Public Sub LoadConfig()
		Version="1.0 beta"
 		Reloadtime = 0 '分钟
		Call GetConfig()
		Dream3_Sys = CacheData(0,0)
		Dream3_OtherPay = CacheData(1,0)
		Dream3_QuartzDate = CacheData(2,0)
		
		Set SiteConfigXMLDOM=Server.CreateObject("Microsoft.XMLDOM")
		SiteConfigXMLDOM.loadxml("<Dream3>"&Dream3_Sys&"</Dream3>")
	End Sub
	
	Public Function GetConfig()'第一次起用系统或者重启IIS的时候加载缓存
		Name = "Config"
		If ObjIsEmpty() Then 
			ReloadConfig
		End If
		CacheData = Value
		Name = "Date"
		If ObjIsEmpty() Then
			Value = Date
		Else
			If CStr(Value) <> CStr(Date) Then
				Name = "Config"
				Call ReloadConfig
				CacheData = Value
			End If
		End If
		If Len(CacheData(0, 0)) = 0 Then
			Name = "Config"
			Call ReloadConfig
			CacheData = value
		End If
	
	End Function
	
	Public Property Let Name(ByVal vNewValue)
		LocalCacheName = LCase(vNewValue)
		Cache_Data = Application(Dream3Cache & "_" & LocalCacheName)
	End Property
	
	Public Property Let Value(ByVal vNewValue)
		If LocalCacheName <> "" Then
			ReDim Cache_Data(2)
			Cache_Data(0) = vNewValue
			Cache_Data(1) = Now()
			Application.Lock
			Application(Dream3Cache & "_" & LocalCacheName) = Cache_Data
			Application.UnLock
		End If
	End Property
	Public Property Get Value()
		If LocalCacheName <> "" Then
			If IsArray(Cache_Data) Then
				Value = Cache_Data(0)
			End If
		End If
	End Property
	Public Function ObjIsEmpty()
		ObjIsEmpty = True
		If Not IsArray(Cache_Data) Then Exit Function
		If Not IsDate(Cache_Data(1)) Then Exit Function
		If DateDiff("s", CDate(Cache_Data(1)), Now()) < (60 * Reloadtime) Then ObjIsEmpty = False
	End Function
	Public Sub DelCache(MyCaheName)
		Application.Lock
		Application.Contents.Remove (MyCaheName)
		Application.UnLock
	End Sub
	
	Public Sub ReloadConfigCache()
		Application.Lock
		Application.Contents.Remove (Dream3Cache & "_" &"Config")
		Application.UnLock
		LoadConfig()
	End Sub

	Public Sub ReloadConfig()
	   Dim RS
	   Set Rs = Exec("SELECT  sitesettingsxml,otherpay,quartzdate   from [T_Config]")
	   value=RS.GetRows(1)
	   Set RS=Nothing
	End Sub
	
	Public Sub ReloadSiteConfig()
		Reloadtime = 0
	End Sub
	
	Function SiteConfig(str)

		TextStr=SiteConfigXMLDOM.documentElement.SelectSingleNode(str).text
		if IsNumeric(TextStr) then
			str=int(TextStr)	'转化为数字类型
			if Len(str)<>Len(TextStr) then	str=TextStr	'防止数字前面的 0 消失掉
		else
			str=TextStr
		End If
		SiteConfig=str
	End Function

 	Function iCreateObject(str)
		'iis5创建对象方法Server.CreateObject(ObjectName);
		'iis6创建对象方法CreateObject(ObjectName);
		'默认为iis6，如果在iis5中使用，需要改为Server.CreateObject(str);
		Set iCreateObject=CreateObject(str)
	End Function
	
 	Private Sub Class_Terminate()
		If IsObject(Conn) Then Conn.Close : Set Conn = Nothing
		Call CloseConn()
		Set SiteConfigXMLDOM = Nothing
	End Sub
	
 	Public Function Exec(Command)
		If Not IsObject(Conn) Then ConnectionDatabase	
			on error resume next
			Set Exec = Conn.Execute(Command)
			If Err Then
				err.Clear
				Set Conn = Nothing
				Response.Write "<li>查询数据的时候发现错误，请检查您的查询代码是否正确。<br /><li>"
				Response.Write Command
				Response.End
			End If
    End Function
 	
 	Public Function GetRandomize(CMS_number)'随机字符串
		Randomize
		Dim CMS_Randchar,CMS_Randchararr,CMS_RandLen,CMS_Randomizecode,CMS_iR
		CMS_Randchar="0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
		CMS_Randchararr=split(CMS_Randchar,",") 
		CMS_RandLen=CMS_number 
		For CMS_iR=1 to CMS_RandLen
			CMS_Randomizecode=CMS_Randomizecode&CMS_Randchararr(Int((21*Rnd)))
		Next 
		GetRandomize = CMS_Randomizecode
	End Function
	
	Public Function GetRandomChar(CMS_number)'随机字符串
		Randomize
		Dim CMS_Randchar,CMS_Randchararr,CMS_RandLen,CMS_Randomizecode,CMS_iR
		CMS_Randchar="A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
		CMS_Randchararr=split(CMS_Randchar,",") 
		CMS_RandLen=CMS_number 
		For CMS_iR=1 to CMS_RandLen
			CMS_Randomizecode=CMS_Randomizecode&CMS_Randchararr(Int((21*Rnd)))
		Next 
		GetRandomChar = CMS_Randomizecode
	End Function

    Public Function Chkchars(Chars)'检测英文名称是否合法
		Dim Charname, i, c
		Charname = Chars
		Chkchars = True
		If Len(Charname) <= 0 Then
			Chkchars = False
			Exit Function
		End If
		For i = 1 To Len(Charname)
		   C = Mid(Charname, i, 1)
			If InStr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@,.0123456789|-_", c) <= 0  Then
			   Chkchars = False
			Exit Function
		   End If
	   Next
	End Function

	Function regexField(ByVal Str, ByVal Pattern)
		If trim(Str)="" Then regexField = False : Exit Function
		Dim Re,Pa
		Set Re = New RegExp
		Re.IgnoreCase = True
		Re.Global = True
		Pa = Pattern'正则代码
		Re.Pattern = Pa
		regexField = Re.Test(CStr(Str))
		Set Re = Nothing
	End Function
	 

	Function  strToAsc(strValue)
	 Dim  strTemp,i
 	 strTemp=""
	 for i=1 to len(strValue & "")
	 If session.codepage="65001" Then 
		  strTemp=strTemp & ascw(mid(strValue,i,1))&"_"
	  Else 
		  strTemp=strTemp & asc(mid(strValue,i,1))&"_"
	  End If 
	  Next 
	  strToAsc=strTemp
	End  Function  
	 Function toasc(strValue)
		Dim ThisAr,i
		ThisAr=split(strValue,"_") 
		for i=0 to Ubound(ThisAr) 
		if IsNumeric(ThisAr(i)) Then
		  If session.codepage="65001" Then 
			toasc=toasc&chrw(ThisAr(i)) 
		  Else
			toasc=toasc&chr(ThisAr(i)) 
		   End If 
		end if
		next 
	End Function 
	'参  数：RelativePath 数据库连接字段串
	'*********************************************************************************************************
	Function GetAbsolutePath(RelativePath)
		dim Exp_Path,Matches,tempStr
		tempStr=Replace(RelativePath,"\","/")
		if instr(tempStr,":/")>0 then
			GetAbsolutePath=RelativePath
			Exit Function
		End if
		set Exp_Path=new RegExp
		Exp_Path.Pattern="(Data Source=|dbq=)(.)*"
		Exp_Path.IgnoreCase=true
		Exp_Path.Global=true
		Set Matches=Exp_Path.Execute(tempStr)
		If instr(LCase(tempStr),"*.xls")<>0 Then
		GetAbsolutePath="driver={microsoft excel driver (*.xls)};dbq="&Server.MapPath(split(Matches(0).value,"=")(1))
		ElseIf Instr(Lcase(tempstr),"*.dbf")<>0 Then
		GetAbsolutePath="driver={microsoft dbase driver (*.dbf)};dbq="&Server.MapPath(split(Matches(0).value,"=")(1))
		Else
		GetAbsolutePath="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="&Server.MapPath(split(Matches(0).value,"=")(1))
		End If
	End Function


	Sub ACTCMSErr(Url)
	   If Url = "" Then
		 Response.Write ("<script>alert('错误提示:\n\n你没有此项操作的权限,请与系统管理员联系!');history.back();</script>")
	   Else
	    Response.Write ("<script>alert('错误提示:\n\n你没有此项操作的权限,请与系统管理员联系!');location.href='" & Url & "';</script>")
	   End If
	   Response.end
	End Sub
	Public Function IsValidEmail(Email)
		Dim names, name, I, c
		IsValidEmail = True
		names = Split(Email, "@")
		If UBound(names) <> 1 Then IsValidEmail = False: Exit Function
		For Each name In names
			If Len(name) <= 0 Then IsValidEmail = False:Exit Function
			For I = 1 To Len(name)
				c = LCase(Mid(name, I, 1))
				If InStr("abcdefghijklmnopqrstuvwxyz_-.", c) <= 0 And Not IsNumeric(c) Then IsValidEmail = False:Exit Function
		   Next
		   If Left(name, 1) = "." Or Right(name, 1) = "." Then IsValidEmail = False:Exit Function
		Next
		If InStr(names(1), ".") <= 0 Then IsValidEmail = False:Exit Function
		I = Len(names(1)) - InStrRev(names(1), ".")
		If I <> 2 And I <> 3 Then IsValidEmail = False:Exit Function
		If InStr(Email, "..") > 0 Then IsValidEmail = False
	End Function
	'检查一个数组中所有元素是否包含指定字符串
	Public Function FoundInArr(strArr, strToFind, strSplit)
		Dim arrTemp, i
		FoundInArr = False
		If InStr(strArr, strSplit) > 0 Then
			arrTemp = Split(strArr, strSplit)
			For i = 0 To UBound(arrTemp)
			If LCase(Trim(arrTemp(i))) = LCase(Trim(strToFind)) Then
				FoundInArr = True:Exit For
			End If
			Next
		Else
			If LCase(Trim(strArr)) = LCase(Trim(strToFind)) Then FoundInArr = True
		End If
	End Function
	

	Public Function ReplaceUrl(ReplaceContent, SaveFilePath)
		Dim re, BeyondFile, BFU, SaveFileName, SysDomain
		Set re = New RegExp
		re.IgnoreCase = True
		re.Global = True
		re.Pattern = "((http|https|ftp|rtsp|mms):(\/\/|\\\\){1}((\w)+[.]){1,}(net|com|cn|org|cc|tv|[0-9]{1,3})(\S*\/)((\S)+[.]{1}(gif|jpg|png|bmp)))"
		Set BeyondFile = re.Execute(ReplaceContent)
		Set re = Nothing
		For Each BFU In BeyondFile
		If InStr(BFU, ActCMS_Sys(2)) = 0 Then 
			SaveFileName = Year(Now()) & Month(Now()) & Day(Now()) & MakeRandom(10) & Mid(BFU, InStrRev(BFU, "."))
			 Call SaveFile(SaveFilePath&SaveFileName,BFU)
			 If  ActCMS_Other(9)="0" Then 
				ReplaceContent = Replace(ReplaceContent, BFU,  ACTCMS.PathDoMain&SaveFilePath & SaveFileName)
			 Else
				ReplaceContent = Replace(ReplaceContent, BFU,  SaveFilePath & SaveFileName)
			 End If 
		End If 
		Next
		ReplaceUrl = ReplaceContent
	End Function
	
	Function SaveFile(LocalFileName,RemoteFileUrl)
	    on error resume next
		Dim SaveRemoteFile:SaveRemoteFile=True
		dim Ads,Retrieval,GetRemoteData
		Set Retrieval = Server.CreateObject("Microsoft.XMLHTTP")
		With Retrieval
			.Open "Get", RemoteFileUrl, False, "", ""
			.Send
			If .Readystate<>4 then
				SaveRemoteFile=False
				Exit Function
			End If
			GetRemoteData = .ResponseBody
		End With
		Set Retrieval = Nothing
		Set Ads = Server.CreateObject("Adodb.Stream")
		With Ads
			.Type = 1
			.Open
			.Write GetRemoteData
			.SaveToFile server.MapPath(LocalFileName),2
			.Cancel()
			.Close()
		End With
		Set Ads=nothing
		SaveFile=SaveRemoteFile
		Dim W:Set W = New CreateView
		Call  W.SY(LocalFileName,LocalFileName)'-----------------
 		Set W=Nothing
	End Function
	
	'生成指定位数的随机数
	Public Function MakeRandom(ByVal maxLen)
	  Dim strNewPass,whatsNext, upper, lower, intCounter
	  Randomize
	 For intCounter = 1 To maxLen
	   upper = 57:lower = 48:strNewPass = strNewPass & Chr(Int((upper - lower + 1) * Rnd + lower))
	 Next
	   MakeRandom = strNewPass
	End Function


	'**************************************************
	'函数名：strLength
	'作  用：求字符串长度。汉字算两个字符，英文算一个字符。
	'参  数：str  ----要求长度的字符串
	'返回值：字符串长度
	'**************************************************
	Public Function strLength(Str)
		On Error Resume Next
		Dim WINNT_CHINESE:WINNT_CHINESE = (Len("中国") = 2)
		If WINNT_CHINESE Then
			Dim l, T, c,I
			l = Len(Str)
			T = l
			For I = 1 To l
				c = Asc(Mid(Str, I, 1))
				If c < 0 Then c = c + 65536
				If c > 255 Then
					T = T + 1
				End If
			Next
			strLength = T
		Else
			strLength = Len(Str)
		End If
		If Err.Number <> 0 Then Err.Clear
	End Function




   Public Function GetStrValue(ByVal strs, ByVal strlen)
   		If IsNull(strs) Then GetStrValue = "":Exit Function
		If strs = "" Then GetStrValue = "":Exit Function
		If strlen=0 Then GetStrValue=strs:Exit Function
		Dim l, T, c, I, strTemp
		Dim str
		str=CloseHtml(strs)
		l = Len(Str)
		T = 0
		strTemp = Str
		strlen = CLng(strlen)
		For I = 1 To l
			c = Abs(Asc(Mid(Str, I, 1)))
			If c > 255 Then
				T = T + 2
			Else
				T = T + 1
			End If
			If T >= strlen Then
				strTemp = Left(Str, I)
				Exit For
			End If
		Next
		If strTemp <> Str Then	strTemp = strTemp
		
		GetStrValue=Replace(strs,str,strTemp)
  End Function
  
  Public Function FormatStrValue(ByVal strs, ByVal strlen)
   		If IsNull(strs) Then FormatStrValue = "":Exit Function
		If strs = "" Then FormatStrValue = "":Exit Function
		If strlen=0 Then FormatStrValue=strs:Exit Function
		Dim l, T, c, I, strTemp
		Dim str
		str=CloseHtml(strs)
		l = Len(Str)
		T = 0
		strTemp = Str
		strlen = CLng(strlen)
		For I = 1 To l
			c = Abs(Asc(Mid(Str, I, 1)))
			If c > 255 Then
				T = T + 2
			Else
				T = T + 1
			End If
			If T >= strlen Then
				strTemp = Left(Str, I)&"..."
				Exit For
			End If
		Next
		If strTemp <> Str Then	strTemp = strTemp
		
		FormatStrValue=Replace(strs,str,strTemp)
  End Function


	Function  LTemplate(temppath) 
 		on error resume next
		Dim  Str,A_W
		set A_W=server.CreateObject("adodb.Stream")
		A_W.Type=2 
		A_W.mode=3 
		A_W.charset="utf-8"
		A_W.open
		A_W.loadfromfile server.MapPath(temppath)
		If Err.Number<>0 Then Err.Clear:LTemplate="":Exit Function
		Str=A_W.readtext
		A_W.Close
		Set  A_W=nothing
		LTemplate=Str
	End  function


	Public Function HTMLCode(fString)
		If Not IsNull(fString) then
		fString = replace(fString, "&gt;", ">")
		fString = replace(fString, "&lt;", "<")
		fString = Replace(fString,  "&nbsp;"," ")
		fString = Replace(fString, "&quot;", CHR(34))
		fString = Replace(fString, "&#39;", CHR(39))
		fString = Replace(fString, "</P><P> ",CHR(10) & CHR(10))
		fString = Replace(fString, "<BR> ", CHR(10))
		HTMLCode = fString
		End If
	End Function
	Public Function HTMLEncode(fString)
		If Not IsNull(fString) Then
			'fString = Replace(fString, "&", "&amp;")
			fString = Replace(fString, "'", "&#39;")
			fString = Replace(fString, ">", "&gt;")
			fString = Replace(fString, "<", "&lt;")
			fString = Replace(fString, Chr(32), " ")
			fString = Replace(fString, Chr(9), " ")
			fString = Replace(fString, Chr(34), "&quot;")
			fString = Replace(fString, Chr(39), "&#39;")
			fString = Replace(fString, Chr(13), "")
			fString = Replace(fString, " ", "&nbsp;")
			fString = Replace(fString, Chr(10), "<br />")
			HTMLEncode = fString
		End If
	End Function

	Public Function CloseHtml(ContentStr)
		On Error Resume Next
		Dim TempLoseStr, regEx
		If Trim(ContentStr)="" Then Exit Function
		TempLoseStr = CStr(ContentStr)
		Set regEx = New RegExp
		regEx.Pattern = "<\/*[^<>]*>"
		regEx.IgnoreCase = True
		regEx.Global = True
		TempLoseStr = regEx.Replace(TempLoseStr, "")
		CloseHtml = TempLoseStr
	End Function

		Function DelSql(Str)
			Dim SplitSqlStr,SplitSqlArr,I
			SplitSqlStr="*|and |exec |insert |select |delete |update |count |master |truncate |declare |and	|exec	|insert	|select	|delete	|update	|count	|master	|truncate	|declare	|char(|mid(|chr("
			SplitSqlArr = Split(SplitSqlStr,"|")
			For I=LBound(SplitSqlArr) To Ubound(SplitSqlArr)
				If Instr(LCase(Str),SplitSqlArr(I))<>0 Then
					Call Alert ("系统警告！\n\n1、您提交的数据有恶意字符;\n2、您的数据已经被记录;\n3、操作日期："&Now&";\n		Powered By ActCMS.Com!","")
					Response.End
				End if
			Next
			DelSql = Str
		End Function


		Public Function S(Str)
		 S = Request(Str)
		End Function
		Public Function G(Str)
		 G = Request(Str)
		End Function

		Public Function Alert(SuccessStr, Url)
		 If Url <> "" Then
		  Response.Write ("<script language=""Javascript""> alert('" & SuccessStr & "');location.href='" & Url & "';</script>")
		 Else
		  Response.Write ("<script language=""Javascript""> alert('" & SuccessStr & "');history.back(-1);</script>")
		 End If
		 response.end
		End Function

		
		Public Function ChkNumeric(ByVal CheckID)
			If CheckID <> "" And IsNumeric(CheckID) Then
				CheckID = CLng(CheckID)
				If CheckID < 0 Then CheckID = 0
			Else
				CheckID = 0
			End If
			ChkNumeric = CheckID
		End Function
		
		Public Function RNum(strChar)
			CheckID = Request(strChar)
			RNum = ChkNumeric(CheckID)
		End Function
		
		'过滤非法的SQL字符
		Public Function RSQL(strChar)
			strChar = Request(strChar)
			If strChar = "" Or IsNull(strChar) Then RSQL = "":Exit Function
			Dim strBadChar, arrBadChar, tempChar, I
			strBadChar = "$,#,',%,^,&,?,(,),<,>,[,],{,},/,\,;,:," & Chr(34) & "," & Chr(0) & ""
			arrBadChar = Split(strBadChar, ",")
			tempChar = strChar
			For I = 0 To UBound(arrBadChar)
				tempChar = Replace(tempChar, arrBadChar(I), "")
			Next
			RSQL = tempChar
		End Function
		
		'过滤参数，防止sql注入
		Public Function RParam(param) 
			Dim oriValue 
			oriValue = Trim(Request(param))
			
			RParam = oriValue
		End Function


		Public Function GetIP() 
			Dim strIPAddr 
			If Request.ServerVariables("HTTP_X_FORWARDED_FOR") = "" Or InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), "unknown") > 0 Then 
				strIPAddr = Request.ServerVariables("REMOTE_ADDR") 
			ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",") > 0 Then 
				strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",")-1) 
			ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";") > 0 Then 
				strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";")-1)
			Else 
				strIPAddr = Request.ServerVariables("HTTP_X_FORWARDED_FOR") 
			End If 
			getIP = Replace(Trim(Mid(strIPAddr, 1, 30)), "'", "")
			getIP = Replace(getIP,";","")
			getIP = Replace(getIP,"-","")
			getIP = Replace(getIP,"(","")
			getIP = Replace(getIP,")","")
			getIP = Replace(getIP,">","")
			getIP = Replace(getIP,"<","")
			getIP = Replace(getIP,"=","")
			getIP = Replace(getIP,"*","")
		End Function


	Public  Function  GetEn(EnStr)
		Dim  EnStr4,EnStr3,EnStr2,EnStr1
		Set  EnStr1=new regexp
			EnStr1.ignorecase=true
			EnStr1.global=true
			EnStr1.pattern="[a-zA-Z0-9\- ]"
			Set  EnStr3=EnStr1.execute(EnStr)
				For  each EnStr2 in EnStr3
					EnStr4=EnStr4&EnStr2.value
				Next 
			Set  EnStr3= Nothing 
		Set  EnStr1=nothing
		EnStr4=trim(EnStr4)
		If  len(EnStr4)>0 then EnStr4=replace(EnStr4," ","-")
		While  (instr(EnStr4,"--")>0)
			EnStr4=replace(EnStr4,"--","-")
		Wend 
		GetEn =EnStr4
	End  Function 


	Public Function IsObjInstalled(strClassString)
		on error resume next
		IsObjInstalled = False
		Err = 0
		Dim xTestObj:Set xTestObj = Server.CreateObject(strClassString)
		If 0 = Err Then IsObjInstalled = True
		Set xTestObj = Nothing
		Err = 0
	End Function
	
	Sub ShowMsg(message,flag,url)
		response.Write("<form method='post' id='gMessageForm' action='"&url&"'>")
		response.Write("<input id='gMessage' name='gMessage' type='hidden' value='"&message&"'>")
		response.Write("<input id='gMessageFlag' name='gMessageFlag' type='hidden' value='"&flag&"'>")
		response.Write("</form>")
		response.Write("<script language='JavaScript'>")
		response.Write("document.forms['gMessageForm'].submit();")
		response.Write("</script>")
	End Sub
	  
	  '提示。。
	Public Function MsgBox2(HintText,HintType,GoWhere)
		Dim Hint,HintTypeText
		Select Case HintType
			Case "0"
				Hint=16
				HintTypeText="出错啦！"
			Case "1" 
				Hint=48
				HintTypeText="警告!"
			Case "2" 
				Hint=64
				HintTypeText="提示!"
		End Select
		'Response.Write "<Script Language=VBScript>"
		'Response.Write "MsgBox """ & Replace(HintText,"'","") &_
			'"""," & Hint & ",""" & HintTypeText & """ "
		Response.Write "<Script type=""text/javascript"">"
		Response.Write "alert( """ & Replace(HintText,"'","") &""");"
		Response.Write "</Script>"
		if GoWhere<>"" then
			if GoWhere = "0" then
				Response.Write "<Script Language=JavaScript>history.back();</Script>"
			else
				Response.Write "<Script Language=JavaScript>location.href='" & GoWhere & "';</Script>"
			end if
		end if
		Response.End()
	End Function
	
	'该函数作用：按指定参数格式化显示时间。
	'numformat=1:将时间转化为yyyy-mm-dd hh:nn格式。
	'numformat=2:将时间转化为yyyy-mm-dd格式。
	'numformat=3:将时间转化为hh:nn格式。
	'numformat=4:将时间转化为yyyy年mm月dd日 hh时nn分格式。
	'numformat=5:将时间转化为yyyy年mm月dd日格式。
	'numformat=6:将时间转化为hh时nn分格式。
	'numformat=7:将时间转化为yyyy年mm月dd日 星期×格式。
	'numformat=8:将时间转化为yyyymmdd格式。
	'numformat=9:将时间转化为mmdd格式。
	'numformat=10:将时间转化为yyyy-mm-dd hh:nn:ss格式。
	'numformat=11:将时间转化为mm月dd日格式。
	
	function Formatdate(shijian,numformat)
	dim ystr,mstr,dstr,hstr,nstr '变量含义分别为年字符串，月字符串，日字符串，时字符串，分字符串
	
	if isnull(shijian) then
	numformat=0
	else
	ystr=DatePart("yyyy",shijian)
	
	if DatePart("m",shijian)>9 then
	mstr=DatePart("m",shijian)
	else
	mstr="0"&DatePart("m",shijian)
	end if
	
	if DatePart("d",shijian)>9 then
	dstr=DatePart("d",shijian)
	else
	dstr="0"&DatePart("d",shijian)
	end if
	
	if DatePart("h",shijian)>9 then
	hstr=DatePart("h",shijian)
	else
	hstr="0"&DatePart("h",shijian)
	end if
	
	if DatePart("n",shijian)>9 then
	nstr=DatePart("n",shijian)
	else
	nstr="0"&DatePart("n",shijian)
	end if
	
	if DatePart("s",shijian)>9 then
		sstr=DatePart("s",shijian)
	else
		sstr="0"&DatePart("s",shijian)
	end if
	
	end if
	
	select case numformat
	case 0
	formatdate=""
	case 1
	formatdate=ystr&"-"&mstr&"-"&dstr&" "&hstr&":"&nstr
	case 2
	formatdate=ystr&"-"&mstr&"-"&dstr
	
	case 3
	formatdate=hstr&":"&nstr
	case 4
	formatdate=ystr&"年"&mstr&"月"&dstr&"日 "&hstr&"时"&nstr&"分"
	
	case 5
	formatdate=ystr&"年"&mstr&"月"&dstr&"日"
	case 6
	formatdate=hstr&"时"&nstr&"分"
	case 7
	formatdate=ystr&"年"&mstr&"月"&dstr&"日 "&WeekdayName(Weekday(shijian))
	case 8
	formatdate=ystr&mstr&dstr
	case 9
	formatdate=mstr&dstr
	case 10
	formatdate=ystr&"-"&mstr&"-"&dstr&" "&hstr&":"&nstr&":"&sstr
	case 11
	formatdate=mstr&"月"&dstr&"日"
	end select
	end function

'截取定义长度的字符。。。。
	Public Function get_StrLen(str,len2)
		if str = "" or isNull(str) or len2 = 0 then
			get_StrLen = ""
		else
			if len(str) < len2 then
				get_strLen = str
			else
				get_strLen = left(str,len2) & "。。。 "
			end if
		end if
	End Function

	'专门用来去除内容中的文本害码。。。
	Public Function DecodeFilter(html, filter)
		html=LCase(html)
		If filter = "" then
			filter="SCRIPT,TABLE,CLASS,XML,NAMESPACE,MARQUEE,OBJECT,STYLE,EMBED,DIV,ONLOAD,ONCLICK,ONDBCLICK,FONT,IMG"
		End If
		filter=split(filter,",")
		For Each i In filter
			Select Case i
				Case "SCRIPT"		' 去除所有客户端脚本javascipt,vbscript,jscript,js,vbs,event,...
					html = exeRE("(javascript|jscript|vbscript|vbs):", "#", html)
					html = exeRE("</?script[^>]*>", "", html)
					html = exeRE("on(mouse|exit|error|click|key)", "", html)
				Case "TABLE":		' 去除表格<table><tr><td><th>
					html = exeRE("</?table[^>]*>", "", html)
					html = exeRE("</?tr[^>]*>", "", html)
					html = exeRE("</?th[^>]*>", "", html)
					html = exeRE("</?td[^>]*>", "", html)
					html = exeRE("</?tbody[^>]*>", "", html)
					html = exeRE("</?textarea[^>]*>", "", html)
					html = exeRE("</?select[^>]*>", "", html)
					html = exeRE("</?button[^>]*>", "", html)
				Case "CLASS"		' 去除样式类class=""
					html = exeRE("(<[^>]+) class=[^ |^>]*([^>]*>)", "$1 $2", html) 
				Case "STYLE"		' 去除样式style=""
					html = exeRE("(<[^>]+) style=""[^""]*""([^>]*>)", "$1 $2", html)
					html = exeRE("(<[^>]+) style='[^']*'([^>]*>)", "$1 $2", html)
				Case "IMG"		' 去除样式style=""
					html = exeRE("</?img[^>]*>", "", html)
				Case "XML"		' 去除XML<?xml>
					html = exeRE("<\\?xml[^>]*>", "", html)
				Case "NAMESPACE"	' 去除命名空间<o:p></o:p>
					html = exeRE("<\/?[a-z]+:[^>]*>", "", html)
				Case "FONT"		' 去除字体<font></font>
					html = exeRE("</?font[^>]*>", "", html)
					html = exeRE("</?a[^>]*>", "", html)
					html = exeRE("</?span[^>]*>", "", html)
					html = exeRE("</?br[^>]*>", "", html)
				Case "MARQUEE"		' 去除字幕<marquee></marquee>
					html = exeRE("</?marquee[^>]*>", "", html)
				Case "OBJECT"		' 去除对象<object><param><embed></object>
					html = exeRE("</?object[^>]*>", "", html)
					html = exeRE("</?param[^>]*>", "", html)
					'html = exeRE("</?embed[^>]*>", "", html)
				Case "EMBED"
				   html =  exeRE("</?embed[^>]*>", "", html)
				Case "DIV"		' 去除对象<object><param><embed></object>
					html = exeRE("</?div([^>])*>", "$1", html)
					html = exeRE("</?p([^>])*>", "$1", html)
				Case "ONLOAD"		' 去除样式style=""
					html = exeRE("(<[^>]+) onload=""[^""]*""([^>]*>)", "$1 $2", html)
					html = exeRE("(<[^>]+) onload='[^']*'([^>]*>)", "$1 $2", html)
				Case "ONCLICK"		' 去除样式style=""
					html = exeRE("(<[^>]+) onclick=""[^""]*""([^>]*>)", "$1 $2", html)
					html = exeRE("(<[^>]+) onclick='[^']*'([^>]*>)", "$1 $2", html)
				Case "ONDBCLICK"		' 去除样式style=""
					html = exeRE("(<[^>]+) ondbclick=""[^""]*""([^>]*>)", "$1 $2", html)
					html = exeRE("(<[^>]+) ondbclick='[^']*'([^>]*>)", "$1 $2", html)
					
			End Select
		Next
		'html = Replace(html,"<table","<")
		'html = Replace(html,"<tr","<")
		'html = Replace(html,"<td","<")
		DecodeFilter = html
	End Function
	
	'正则替换。。。
	Public Function exeRE(re, rp, content)
		Set oReg = New RegExp
		oReg.IgnoreCase =True
		oReg.Global=True	
		oReg.Pattern=re
		r = oReg.Replace(content,rp)
		Set oReg = Nothing	
		exeRE = r
	End Function
	
	
	'判断是否为正整数
	Public Function isInteger(num)
		If Not IsNumeric(num) Then 
			isInteger = false
			Exit Function
		End If
		num=CDbl(num)
    	b=split(num,".")
 		If ubound(b)>0 then
			isInteger = false
			Exit Function
		Else
			If num <=0 Then
				isInteger = false
				Exit Function
			End If
		End If
		isInteger = true
	End Function
	
	
	'得到当天23点59分59秒的时间
	Public Function GetLastTime(fcurdate)
		Dim fdatestr 
		fdatestr = Formatdate(fcurdate,2)
		fdatestr = fdatestr &" 23:59:59"
		getLastTime = CDate(fdatestr)
	End Function
	
	'得到当天0:0:0的时间
	Public Function GetStartTime(fcurdate)
		Dim fdatestr 
		fdatestr = Formatdate(fcurdate,2)
		fdatestr = fdatestr &" 00:00:00"
		GetStartTime = CDate(fdatestr)
	End Function
	
	Function validate(ByVal str,ByVal number) 

		Dim temp,reg 
		
		Set reg = new regexp 
		
		reg.ignorecase=true 
		
		reg.global=true 
		
		Select Case CStr(number) 
		
		' 英文+空格 
		
		Case "0" temp = "^[a-zA-Z ]+$" 
		
		' 数字+横杠 
		
		Case "1" temp = "^[0-9\-]+$" 
		
		' 半角数字 
		
		Case "2" temp = "^\d+$" 
		
		' 邮箱地址 
		
		Case "3" temp = "^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" 
		
		' 手机号码格式 
		
		Case "4" temp = "^(((13[0-9]{1})|(14[0-9]{1})|(15[0-9]{1})|(18[0-9]{1}))+\d{8})$" 
		
		' 电话号码格式1 
		
		Case "5" temp = "^(([0\+]\d{2,3}-)?(0\d{2,3})-)?(\d{7,8})(-(\d{3,}))?$" 
		
		' 电话号码格式2 
		
		Case "6" temp = "^(([0\+]\d{2,3}-)?(0\d{2,3}))?(\d{7,8})(-(\d{3,}))?$" 
		
		Case Else temp = number 
		
		End Select 
		
		reg.pattern = temp 
		
		validate = reg.test(Trim(str)) 
		
		Set reg = Nothing 
	
	End Function 
	
	Function FormatNumbersNil(str,floatcount) 
		if str <>"" and instr(str,".")>0 then 
			str = FormatNumber(str,floatcount,-1,0,0) 
			while right(str,1)="0" 
				str=left(str,len(str)-1) 
			wend 
			If Right(str,1) = "." Then str = Left(str,len(str)-1)
		end if 
		FormatNumbersNil = str 
	end function 
	
	Function  encodeUrl(paraString,Encoding1,Encoding2)
	 '  不同编码的urlencode函数
	 '  Encoding1  程序使用的编码  utf-8=65001,GB2312=936
	 '  Encoding2  需要得到的编码
	 '  by  fisker  07.02.07
	  Session.CodePage=Encoding2
	  encodeUrl  =  server.urlencode(paraString)
	  Session.CodePage=Encoding1
	 End  Function 


	Public Function CreateAXObject(str)
		Set CreateAXObject = CreateObject(str)
	End Function
	
	Function vbsUnEscape(str)'解密
    dim i,s,c
    s=""
    For i=1 to Len(str)
        c=Mid(str,i,1)
        If Mid(str,i,2)="%u" and i<=Len(str)-5 Then
            If IsNumeric("&H" & Mid(str,i+2,4)) Then
                s = s & CHRW(CInt("&H" & Mid(str,i+2,4)))
                i = i+5
            Else
                s = s & c
            End If
        ElseIf c="%" and i<=Len(str)-2 Then
            If IsNumeric("&H" & Mid(str,i+1,2)) Then
                s = s & CHRW(CInt("&H" & Mid(str,i+1,2)))
                i = i+2
            Else
                s = s & c
            End If
        Else
            s = s & c
        End If
    Next
    vbsUnEscape = s
End Function

Function isValidReferer() 
	Dim server_v1, server_v2
	IsValidReferer = False
	server_v1 = CStr(Request.ServerVariables("HTTP_REFERER"))
	server_v2 = CStr(Request.ServerVariables("SERVER_NAME"))
	t(server_v1&"<>"&server_v2)
	If Mid(server_v1, 8, Len(server_v2)) <> server_v2 Then
	isValidReferer = False
	Else
	isValidReferer = True
	End If
End Function


Function   getTime(s_date) 
	getTime   =   DateDiff( "s",   "1970-01-01   08:00:00",   s_date)   
End   Function 

Function   parseTime(s_time) 
	'getTime   =   DateDiff( "s",   "1970-01-01   08:00:00",   s_date)   
	parseTime = DateAdd("s",s_time,"1970-01-01 08:00:00")
End   Function 

Function getTimeInterval(s_time)
	s_interval = DateDiff("d",s_time,Now())
	If  s_interval > 0 Then
		getTimeInterval = s_interval & "天前"
		Exit Function
	End If
	
	s_interval = DateDiff("h",s_time,Now())
	If  s_interval > 0 Then
		getTimeInterval = s_interval & "小时前"
		Exit Function
	End If
	
	s_interval = DateDiff("n",s_time,Now())
	If  s_interval > 0 Then
		getTimeInterval = s_interval & "分钟前"
		Exit Function
	End If
	
	s_interval = DateDiff("s",s_time,Now())
	If  s_interval > 0 Then
		getTimeInterval = s_interval & "秒前"
		Exit Function
	End If
	
	getTimeInterval = "刚才"
	
End Function

Function GetMailTitle(s_title)
	if IsNull(s_title) Then s_title = ""
	if len(s_title) > 80 Then s_title = left(s_title,80)
	GetMailTitle = s_title
End Function

Function GetStylePath()
	GetStylePath = VirtualPath & "/common/themes/"& Dream3CLS.SiteConfig("DefaultSiteStyle")
End Function

Function CheckFileContent(FileName)

    Dim ClientFile, ClientText, ClientContent, DangerString, DSArray, AttackFlag, k
    Set ClientFile = Server.CreateObject("Scripting.FileSystemObject")
    Set ClientText = ClientFile.OpenTextFile(Server.MapPath(FileName), 1)
    ClientContent = LCase(ClientText.ReadAll)
    Set ClientText = Nothing
    Set ClientFile = Nothing
    AttackFlag = False
    DangerString = ".getfolder|.createfolder|.deletefolder|.createdirectory|.deletedirectory|saveas|wscript.shell|script.encode|server.|.createobject|execute|activexobject|language=|include|filesystemobject|shell.application"
    DSArray = Split(DangerString, "|")
    For k = 0 To UBound(DSArray)
        If InStr(ClientContent, DSArray(k))>0 Then '判断文件内容中是否包含有危险的操作字符，如有，则必须删除该文件。
            AttackFlag = True
            Exit For
        End If
    Next
    CheckFileContent = AttackFlag
End Function

Function TimeFormateToTwoBits(t)
	TimeFormateToTwoBits=Year(t) & "-" & Right("0" & Month(t),2) & "-" & Right("0" & Day(t),2)
End Function

End Class





Dim Dream3CLS
Set Dream3CLS = New Dream3_Main

%>