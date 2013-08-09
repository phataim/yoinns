<%
Class AspMap

private arr()
private arr_len

'构造函数
private Sub Class_Initialize
'其中 arr(0,n)为key,arr(1,n)为value
arr_len = 0
redim arr(1,arr_len)
end sub

'赋值,如果存在则覆盖
public sub putv(k,v)
dim is_update
is_update = false
arr_len = ubound(arr,2)
for mapi=0 to arr_len-1
if k=arr(0,mapi) then
arr(1,mapi) = v
is_update = true
exit for
end if
next
if not is_update then
arr_len = arr_len +1
redim preserve arr(1,arr_len)
arr(0,arr_len) = k
arr(1,arr_len) = v
end if
end sub

'取得key为"k"的键值
public function getv(k)
dim v
v = ""
for mapi=0 to arr_len
if k=arr(0,mapi) then
v = arr(1,mapi)
exit for
end if
next
getv = v 
end function

'删除key为"k"的键值
public sub delv(k)
arr_len = ubound(arr,2)
for mapi=0 to arr_len
if k=arr(0,mapi) then
v = arr(1,mapi)
for k = mapi to arr_len-1
arr(0,k) = arr(0,k+1)
arr(1,k) = arr(1,k+1)
next 
arr_len = arr_len - 1
redim preserve arr(1,arr_len)
exit for
end if
next
end sub

'获得MtMap中键值的数量
public property get count()
count = arr_len
end property


'清空MtMap中所有的键值
public sub clear()
arr_len = 0
redim arr(1,1)
end sub
end class

%>