<%

dim act
dim pageid
act=request.QueryString("action")
pageid = request.QueryString("id")
select case act
   case "tongguo"
   call tongguo()
   case "shanchu"
   call shanchu()
   case "chongshen"
   call chongshen()
end select
sub tongguo()
 Dream3CLS.Exec("update  T_Comments set state='Y' where id='"&pageid&"'")
 Call Main()
end sub
sub shanchu()
Dream3CLS.Exec("delete from T_Comments where id='"&pageid&"'")
Call Main()
end sub
sub chongshen()
Dream3CLS.Exec("update  T_Comments set state='N' where id='"&pageid&"'")

Call Main()
end sub




%>