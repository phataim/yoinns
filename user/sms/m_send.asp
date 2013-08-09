<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="m_codepublic.asp"-->

<%
' 后面加个来路检测
call no_long(2) '防止重量发送
s_time=60 '定义相隔之间的时间 60秒

t_no=ConvertHTML(request("t_no")) '手机号码
sort=ConvertHTML(request("sort")) '验证来源

if len(t_no)<>11 and  IsNum_pro(t_no)=false then '如果手机号码有错时
	response.Write "1" '返回失败值
	response.End
end if

if sort="" then '注册用户时

	Sql = "select id from T_User Where mobile='"&t_no&"'" '检测手机是否已存在 
	Set Rs = Dream3CLS.Exec(Sql)
	If Not Rs.EOF Then
		response.Write "3" '返回失败值
		response.End
	End If
	
	r_no1=Rnd_no(4) '需要4位随机码
	
	ext=""
	stime=""
	rrid=""
	
	text_r_no1="欢迎使用[有旅馆]短信服务, 您的验证码是 "&r_no1&" ,请在页面正确填写完成验证, 谢谢!【有旅馆】"
	sort_name="reg"
elseif sort=1 then '忘记密码时

	Sql = "select id from T_User Where mobile='"&t_no&"'" '检测手机是否存在 
	rs.open sql,conn,1,1
	if rs.recordcount=0 then '找不到记录
		response.Write "3" '返回失败值
		response.End
	end if 
	
	r_no1=Rnd_no(6) '需要6位随机码
	
	ext=""
	stime=""
	rrid=""
	
	text_r_no1="欢迎使用[有旅馆]短信服务, 您的验证码是 "&r_no1&" ,请在页面正确填写完成验证, 谢谢!【有旅馆】"
	sort_name="forgetPW"
end if

call mdb_name(user_mdb) '打开SMS数据库

sql="select * from sms where t_no='"&t_no&"' order by id desc " '只检验该号码最后一次的验证号
ps.open sql,comm,1,1
if ps.recordcount<>0 then
	send_time=ps("send_time")
	aa=datediff("s",send_time, now())  ' n, 大 ,小
	if aa<s_time then  '小于规定时间里
		response.Write "2" '返回失败值
		response.End
	end if
end if
ps.close	

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''				
if sms_open=0 then
	at=mt(t_no,text_r_no1,ext,stime,rrid) '给远程地址发短信
	session("r_no")=r_no1
end if
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

sql="select * from sms"
ps.open sql,comm,1,3
ps.addnew
	ps("r_no1")=r_no1 '验证码
	ps("t_no")=t_no '手机号
	ps("mt")=at '短信服务器返回值
	ps("sort_name")=sort_name '
ps.update
ps.close	
set ps=nothing
comm.close
set comm=nothing 
response.Write "0" '返回成功值









%>