<!--#include file="../../conn.asp"-->
<%
' 后面加个来路检测
reg_code=ConvertHTML(request("reg_code")) '验证码
t_no=ConvertHTML(request("t_no")) '手机号码

back_z="n" '默认为失败值
session("r_no")="" '清零

if len(t_no)<>11 and  IsNum_pro(t_no)=false then '如果验证码有错时
	response.Write "n" '返回失败值
	response.End
end if

if len(reg_code)<>4 and IsNum_pro(reg_code)=false then '如果手机号码有错时
	response.Write "n" '返回失败值
	response.End
end if

call mdb_name(user_mdb) '打开SMS数据库

sql="select * from sms where t_no='"&t_no&"' order by id desc " '只检验该号码最后一次的验证号
ps.open sql,comm,1,1
if ps.recordcount<>0 then
	if ps("r_no1")=reg_code then '验证码
		back_z="y" '成功值
		session("r_no")=reg_code '存储验证码
	end if
end if
ps.close	
set ps=nothing
comm.close
set comm=nothing
response.Write back_z '输出值
%>