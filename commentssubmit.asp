<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="SqlFilter.asp"-->
<!--#include file="common/api/cls_user.asp"-->
<%

dim content
dim userid

dim roomid
dim comstate
dim timenow
dim hid 
dim fangdong
dim houseTitle
dim href

timenow=now()
href = request.form("href")
fangdong =request.form("fangdong")
content =request.form("pinglunarea")

houseTitle = request.form("houseTitle")
roomid = request.form("roomid")
username = request.form("username")
hid =request.form("hid")
hotelname =request.form("hotelname")
if session("checkcode") <>"" then

  if Not Dream3User.CodeIsTrue Then
			    
			gMsgArr ="|您输入的认证码和系统产生的不一致，请重新输入!"
		
		   Call Dream3CLS.MsgBox2(gMsgArr,0,"0")
			End If
			end if
set rs =Dream3CLS.Exec("select face from T_User where username='"&username&"'")
 
if  not rs.eof then
if  username ="/"  then
sql = "insert into T_Comments (roomid,username,contents,state,createtime,userface,hotelname,hid,owner,houseTitle) values('"&roomid&"','游客','"&content&"','N','"&now()&"','images/youke.gif','"&hotelname&"' ,'"&hid&"' ,'"&fangdong&"' ,'"&houseTitle&"' )"

Dream3CLS.Exec(sql)
elseif isnull(rs(0)) then
sql = "insert into T_Comments (roomid,username,contents,state,createtime,userface,hotelname,hid,owner,houseTitle) values('"&roomid&"','"&username&"','"&content&"','N','"&now()&"','images/noimage.gif' ,'"&hotelname&"','"&hid&"'  ,'"&fangdong&"','"&houseTitle&"' )"

Dream3CLS.Exec(sql)
else
sql = "insert into T_Comments (roomid,username,contents,state,createtime,userface,hotelname,hid,owner,houseTitle) values('"&roomid&"','"&username&"','"&content&"','N','"&now()&"','"&rs(0)&"','"&hotelname&"','"&hid&"' ,'"&fangdong&"' ,'"&houseTitle&"' )"
Dream3CLS.Exec(sql)
end if

end if
response.redirect(href)

%>