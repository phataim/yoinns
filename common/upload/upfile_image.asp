<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_fso.asp"-->
<!--#include file="../../common/upload/upload_wj.inc"-->
<!--#include file="../../common/upload/aspjpeg.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<%
'if Request.Cookies(DREAM3C)("_UserID") = "" then
'If Session("_UserID") = "" Then
	'response.Write("���¼ϵͳ")
	'Response.End()
'end if

Dim UploadFile 
Dim displayFile
UploadFile = "UploadFile"
dataStr = Dream3CLS.Formatdate(now,8)

Dream3File.CreateAbsoluteFolder(Server.mappath("../../"&UploadFile))

loadsrc=UploadFile&"/"&dataStr&"/"  


set upload=new upload_file 'upload����һ������
if upload.form("act")="uploadfile" then

	'filepath	= Session("uppath") '����,�ϴ�ǰ�ļ����ڵ�·��
	filepath = loadsrc
	filelx		= trim(upload.form("filelx"))
	EditName    = trim(upload.form("EditName"))


   Dream3File.CreateAbsoluteFolder(Server.mappath("../../"&filepath))
		
	i = 0
	for each formName in upload.File
		 set file=upload.File(formName)
		 fileExt=lcase(file.FileExt)	'�õ����ļ���չ��������.
		 fileExt=lcase(fileExt)
		
		 if fileExt <> "gif" and fileExt <> "jpg" and  fileExt <>"png" and fileExt <> "bmp" then	'�������ļ�����
		 	Response.Write("<span style=""font-family: ����; font-size: 9pt"">��ֻ���ϴ� [gif/jpg/png/bmp] ���͵��ļ�����[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]</span>")
		 	Response.End()
		 end if
		 
		 if file.filesize<100 then
			response.write "<span style=""font-family: ����; font-size: 9pt"">����ѡ����Ҫ�ϴ����ļ�����[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]</span>"
			response.end
		 end if
		 if file.filesize>(3000*1024) then
				response.write "<span style=""font-family: ����; font-size: 9pt"">���ֻ���ϴ�3M ��ͼƬ�ļ�����[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]</span>"
				response.end
			end if
		 if (filelx="asp") or filelx="aspx"  then 
			response.write "<span style=""font-family: ����; font-size: 9pt"">���ļ����Ͳ����ϴ�����[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]</span>"
			response.end
		 end if
		 if filelx="swf" then
			if fileext<>"swf"  then
				response.write "<span style=""font-family: ����; font-size: 9pt"">ֻ���ϴ�swf��ʽ��Flash�ļ�����[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]</span>"
				response.end
			end if
		 end if
		 if filelx="jpg" then
			if fileext<>"gif" and fileext<>"jpg"  then
				response.write "<span style=""font-family: ����; font-size: 9pt"">ֻ���ϴ�jpg��gif��ʽ��ͼƬ����[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]</span>"
				response.end
				end if
		 end if
		 if filelx="swf" then
			if file.filesize>(3000*1024) then
				response.write "<span style=""font-family: ����; font-size: 9pt"">���ֻ���ϴ� 3M ��Flash�ļ�����[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]</span>"
				response.end
			end if
		 end if
		 if filelx="jpg" then
			if file.filesize>(1000*1024) then
				response.write "<span style=""font-family: ����; font-size: 9pt"">���ֻ���ϴ� 1000K ��ͼƬ�ļ�����[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]</span>"
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
    ' ������ʾ��ͼƬ
	displayFile =GetSiteUrl()&"/"&filename&"."&fileExt
	' ���ڴ���DB��ֵ
	dbfilename = filename&"."&fileExt
	
	filename="../../"&filename&"."&fileExt
	

	

'response.Write(">>>"&Server.mappath(FileName))
'response.End()
		
		 if file.FileSize>0 then         ''��� FileSize > 0 ˵�����ļ�����
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
//window.alert("�ļ��ϴ��ɹ�!�벻Ҫ�޸����ɵ����ӵ�ַ��");
window.close();
</script>
