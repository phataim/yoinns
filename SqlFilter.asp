<%


dim filter

filter= "'|and|exec|insert|select|delete|update|count|*|%|chr|mid|master|truncate|char|declare|,"
SQL_inj = split(filter,"|")
If Request.QueryString<>"" Then
 For Each SQL_Get In Request.QueryString
  For SQL_Data=0 To Ubound(SQL_inj)
   if instr(Request.QueryString(SQL_Get),Sql_Inj(Sql_DATA))>0 Then
    Response.Write "<Script Language=javascript>alert('内容含有非法字符！\r请重新输入！');history.back(-1);</Script>"
    Response.end
   end if
  next
 Next
End If

If Request.Form<>"" Then
 For Each Sql_Post In Request.Form
  For SQL_Data=0 To Ubound(SQL_inj)
   if instr(Request.Form(Sql_Post),Sql_Inj(Sql_DATA))>0 Then
    Response.Write "<Script Language=javascript>alert('内容含有非法字符!\r请重新输入！');history.back(-1);</Script>"
    Response.end
   end if
  next
 next
end if 


%>
