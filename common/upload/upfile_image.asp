<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_fso.asp"-->
<!--#include file="../../common/upload/upload_wj.inc"-->
<!--#include file="../../common/upload/aspjpeg.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<%
'if Request.Cookies(DREAM3C)("_UserID") = "" then
'If Session("_UserID") = "" Then
	'response.Write("请登录系统")
	'Response.End()
'end if

Dim UploadFile 
Dim displayFile
UploadFile = "UploadFile"
dataStr = Dream3CLS.Formatdate(now,8)

Dream3File.CreateAbsoluteFolder(Server.mappath("../../"&UploadFile))

loadsrc=UploadFile&"/"&dataStr&"/"  


set upload=new upload_file 'upload就是一个对象
if upload.form("act")="uploadfile" then

	'filepath	= Session("uppath") '属性,上传前文件所在的路径
	filepath = loadsrc
	filelx		= trim(upload.form("filelx"))
	EditName    = trim(upload.form("EditName"))


   Dream3File.CreateAbsoluteFolder(Server.mappath("../../"&filepath))
		
	i = 0
	for each formName in upload.File
		 set file=upload.File(formName)
		 fileExt=lcase(file.FileExt)	'得到的文件扩展名不含有.
		 fileExt=lcase(fileExt)
		
		 if fileExt <> "gif" and fileExt <> "jpg" and  fileExt <>"png" and fileExt <> "bmp" then	'限死了文件类型
		 	Response.Write("<span style=""font-family: 宋体; font-size: 9pt"">您只能上传 [gif/jpg/png/bmp] 类型的文件！　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</span>")
		 	Response.End()
		 end if
		 
		 if file.filesize<100 then
			response.write "<span style=""font-family: 宋体; font-size: 9pt"">请先选择你要上传的文件！　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</span>"
			response.end
		 end if
		 if file.filesize>(3000*1024) then
				response.write "<span style=""font-family: 宋体; font-size: 9pt"">最大只能上传3M 的图片文件！　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</span>"
				response.end
			end if
		 if (filelx="asp") or filelx="aspx"  then 
			response.write "<span style=""font-family: 宋体; font-size: 9pt"">该文件类型不能上传！　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</span>"
			response.end
		 end if
		 if filelx="swf" then
			if fileext<>"swf"  then
				response.write "<span style=""font-family: 宋体; font-size: 9pt"">只能上传swf格式的Flash文件！　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</span>"
				response.end
			end if
		 end if
		 if filelx="jpg" then
			if fileext<>"gif" and fileext<>"jpg"  then
				response.write "<span style=""font-family: 宋体; font-size: 9pt"">只能上传jpg或gif格式的图片！　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</span>"
				response.end
				end if
		 end if
		 if filelx="swf" then
			if file.filesize>(3000*1024) then
				response.write "<span style=""font-family: 宋体; font-size: 9pt"">最大只能上传 3M 的Flash文件！　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</span>"
				response.end
			end if
		 end if
		 if filelx="jpg" then
			if file.filesize>(1000*1024) then
				response.write "<span style=""font-family: 宋体; font-size: 9pt"">最大只能上传 1000K 的图片文件！　[ <a href=# onclick=history.go(-1)>重新上传</a> ]</span>"
				response.end
			end if		
		 end if
				
		 randomize
		 ranNum=int(90000*rnd)+10000
		
	if EditName="src_img" then
	filename=filepath&"s"&filepre&right(year(now),2)&month(now)&day(now)&hour(now)&minute(now)&second(now)&ranNum
	elseif EditName="user_photo" then
	filename=filepath&"userphoto"
	else	filename=filepath&filepre&right(year(now),2)&month(now)&day(now)&hour(now)&minute(now)&second(now)&ranNum
	end if
    ' 用于显示的图片
	displayFile =GetSiteUrl()&"/"&filename&"."&fileExt
	' 用于存于DB的值
	dbfilename = filename&"."&fileExt
	
	filename="../../"&filename&"."&fileExt
	

	

'response.Write(">>>"&Server.mappath(FileName))
'response.End()
		
		 if file.FileSize>0 then         ''如果 FileSize > 0 说明有文件数据
			  file.SaveToFile Server.mappath(FileName)			 
			  if filelx="swf" then
				  response.write "<script>window.opener.document."&upload.form("FormName")&".size.value='"&int(file.FileSize/1024)&" K'</script>"
			  end if  
			  response.write "<script>window.opener.document."&upload.form("FormName")&"."&upload.form("EditName")&".value='"&dbfilename&"'</script>"
			  if upload.form("ImgSrc") <> "" and not isNull(upload.form("ImgSrc")) then
			
				  response.write "<script>window.opener.document."&upload.form("FormName")&"."&upload.form("ImgSrc")&".src='"&displayFile&" '</script>"
			  end if
		 end if
		 set file=nothing
	next
	set upload=nothing

end if
	
%>


 
<script language="javascript">
//window.alert("文件上传成功!请不要修改生成的链接地址！");
window.close();
</script>
