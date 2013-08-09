<!--#include file="conn.asp"-->
<%
'全局城市ID
city_id = Request.QueryString("city_id")
G_City_ID = city_id
Response.Cookies(DREAM3C).Expires = Date + 365
Response.Cookies(DREAM3C)("_UserCityID") = city_id
Response.Redirect("index.asp")
%>
