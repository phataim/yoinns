<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_fso.asp"-->
<%
Web_DigLogin=0
Web_SrcUrlShow=True
Web_ContentRecordNum=10
Web_ContentTxtNum=500
Web_RevertRecordNum=10
Web_RevertTxtNum=100
Web_SysTagsShowNum=30
Web_SysTagsColNum=3
Web_SysTagsDCount=0
Web_WebTagsDCount=0
Web_WebTagsShowNum=30
Web_WebTagsColNum=4
Web_MessageNum=5
Web_HotNum=10
Web_IsUploadShowImg=1
Web_Noimage="images/noimage.gif"
Web_ContentImgLocation="Right"
Web_ContentImgMaxWidth=150
Web_ContentImgMaxHeight=1000
%>
<%


'if Request.Cookies(DREAM3C)("_UserID") = "" then
	'Response.Write("请登录系统！")
	'Response.End()
'end if


'如果网站不是放在根目录下，请在/UploadFile前加上你存放的目录名，如放在wodig文件夹，就在前面加上/dream3 注意最前面要有/
Session("uppath")=loadsrc

filelx	= request("filelx")				'文件上传类型
formName= request("formName")			'回传到上页面编辑框所在Form的Name
EditName= request("EditName")			'回传到上页面编辑框的Name
ImgSrc	= request("ImgSrc")

%>
<html>
<head>
<title>文件上传工具</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script language="javascript">
<!--
function mysub()
{
		esave.style.visibility="visible";
}
-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="../../common/upload/upfile_image.asp" enctype="multipart/form-data" >
  <div id="esave" style="position:absolute; top:18px; left:40px; z-index:10; visibility:hidden"> 
    <TABLE WIDTH=340 BORDER=0 CELLSPACING=0 CELLPADDING=0>
      <TR><td width=20%></td>
	<TD bgcolor=#104A7B width="60%"> 
	<TABLE WIDTH=100% height=120 BORDER=0 CELLSPACING=1 CELLPADDING=0>
	<TR> 
	          <td bgcolor=#eeeeee align=center><font color=red>正在上传文件，请稍候...</font></td>
	</tr>
	</table>
	</td><td width=20%></td>
	</tr>
</table></div>

<table width="400" border="0" cellspacing="1" cellpadding="1" align="center" bgcolor="#CCCCCC">
    <tr> 
      <td height="22" align="left" valign="middle" bgcolor="#f1f1f1" width="400">&nbsp;<font size="2">图片上传</font> 
        <input type="hidden" name="filelx" value="<%=filelx%>">
        <input type="hidden" name="EditName" value="<%=EditName%>">
        <input type="hidden" name="FormName" value="<%=formName%>">
		<input type="hidden" name="ImgSrc" value="<%=ImgSrc%>">
        <input type="hidden" name="act" value="uploadfile">
      </td>
    </tr>
    <tr align="center" valign="middle"> 
      <td align="left" id="upid" height="80" width="400" bgcolor="#FFFFFF" style="padding-left:5px"> <font size="2">选择文件:</font> 
        <input type="file" name="file1" style="width:300'"  class="wenbenkuang" value="">
		<br>
		<font size="2">只支持对 &nbsp;[ <font color="#ff0000">gif,jpg,png,bmp</font> ] 文件的上传！</font>
      </td>
    </tr>
    <tr align="center" valign="middle"> 
      <td bgcolor="#f1f1f1" height="24" width="400"> 
        <input type="submit" name="Submit" value="开始上传" class="go-wenbenkuang" onClick="javascript:mysub()">
      </td>
    </tr>
  </table>
</form>
</body>
</html>
