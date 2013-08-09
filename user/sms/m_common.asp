<%
Rem ==========共用函数=========
dim comm
dim ps
user_mdb="db.mdb" '数据库

Function check_power3(comeclass) '检测权限是否通过 comeclass:测试权限
	check_power3=true
End Function


Function js_jump(str1,url) '错误提示 str1: 显示数据内容 url:空就返回原来的页面,有值就值跳转
	if url="" then
		Response.Write "<script language=JavaScript>" & chr(13) & "alert('"&str1&"');" & "history.back(1)" & "</script>" 
	else
		Response.Write "<script language=JavaScript>" & chr(13) & "alert('"&str1&"');" & "location.href='"&url&"';" & "</script>" 
	end if
	response.end
End Function


Function IsNum_pro(str) '能检测包括空的数字类型
	if str="" then
		IsNum_pro=false
	else
		IsNum_pro=IsNumeric(str)
	end if
End Function


Function no_long(aa) '防止重复添加信息

	'############   防止重复留言
	session("time")=now()
	const atime=#0:0:05# '定义相隔之间的秒数
	if session("time2") >0 then
		if session("time2")+atime > session("time") then
			session("time2")=now()
			if aa=1 then
				call js_jump("╮(╯_╰)╭ 发信息不要这么快哦～","")
			else
				response.Write "4"
			end if
			response.end
		end if 
	end if
	session("time2")=now()
	'############
End Function


Function mdb_name(m_n) '连接数据库
	set comm=Server.CreateObject("ADODB.Connection")
	comm.open "Provider=Microsoft.JET.OLEDB.4.0;Data Source= "&server.MapPath (m_n)
	Set ps= Server.CreateObject("ADODB.Recordset")
End Function

function ConvertHTML(str) '过滤字符串
	'if IsObject(str) then
		ConvertHTML=trim(str)
		'ConvertHTML=replace(str, "&", "&#38")
		'ConvertHTML=replace(ConvertHTML, ";", "&#59")
		ConvertHTML=replace(ConvertHTML, "(", "（")
		ConvertHTML=replace(ConvertHTML, ")", "）")
		ConvertHTML=replace(ConvertHTML, "<", "＜")
		ConvertHTML=replace(ConvertHTML, ">", "＞")
		ConvertHTML=replace(ConvertHTML,chr(34), "＂")
		ConvertHTML=replace(ConvertHTML,chr(34),"&quot;")
		ConvertHTML=replace(ConvertHTML,chr(39), "&#39")
		ConvertHTML=replace(convertHTML,vbCrLf, "<br />")
'要增加过滤%号
		'ConvertHTML=replace(convertHTML," ", "&nbsp;")
		if len(ConvertHTML)< 30 then
			ConvertHTML=replace(ConvertHTML, "	", "______")
		else
			ConvertHTML=replace(ConvertHTML, "	", "&nbsp;&nbsp;")
		end if
		'ConvertHTML=replace(ConvertHTML, "&", "&amp;")
		'ConvertHTML=replace(str, vbCrLf, "<br>")
	'else
	'	ConvertHTML="??"
	'end if
end function



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



Function Rnd_no(n) '随机数 , n 为多少位
	Randomize '初始化随机数
	for i=1 to n
		mn = Int((9 * Rnd) + 1)' 产生 1 到 6 之间的随机数。
		tt=mn&tt
	next
	Rnd_no=tt
end function




















%>