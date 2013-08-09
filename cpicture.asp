<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<%
Dim Action
Dim pid
Dim img1,img2,img3,img4,img5,img6,img7,img8,img9,img10

Action = Request.QueryString("act")
Select Case Action
	Case "save"
		Call SaveRecord()
	Case "showedit"
		Call ShowEdit()
	Case Else
		Call Main()
End Select

Sub SaveRecord()
 	pid = Dream3CLS.ChkNumeric(Request.Form("pid"))
	
	img1 = Dream3CLS.RParam("src_img_h1")
	img2 = Dream3CLS.RParam("src_img_h2")
	img3 = Dream3CLS.RParam("src_img_h3")
	img4 = Dream3CLS.RParam("src_img_h4")
	img5 = Dream3CLS.RParam("src_img_h5")
	img6 = Dream3CLS.RParam("src_img_h6")
	img7 = Dream3CLS.RParam("src_img_h7")
	img8 = Dream3CLS.RParam("src_img_h8")
	img9 = Dream3CLS.RParam("src_img_h9")
	img10 = Dream3CLS.RParam("src_img_h10")
	
	'验证表单
	Call validateSubmit()

	
	
	If len(gMsgArr) > 0 Then 
		gMsgFlag = "E"
		
		Exit Sub
	End If
	
	'开始保存
	
	
	Set Rs = Server.CreateObject("Adodb.recordset")
	Sql = "Select * from T_Product"
	If pid <> 0 Then
		If Session("_IsManager") = "Y" Then
			Sql = Sql & " Where ID="&pid
		Else
			Sql = Sql & " Where ID="&pid&" and user_id="&Session("_UserID")
		End If
	End If
	
	Rs.open Sql,conn,1,2
	Rs("image") = img1
	Rs("image1") = img2
	Rs("image2") = img3
	Rs("image3") = img4
	Rs("image4") = img5
	Rs("image5") = img6
	Rs("image6") = img7
	Rs("image7") = img8
	Rs("image8") = img9
	Rs("image9") = img10
	Rs("state") = "auditing" 
	
	Rs.Update

	Rs.Close
	Set Rs = Nothing
	
	
	directPage = VirtualPath&"/user/company/myroom.asp"
	
	'response.Redirect(directPage)
	Dream3CLS.showMsg "图片已提交审核,请耐心等候！","S", directPage
	
End Sub

Sub ShowEdit()
	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	If Session("_IsManager") = "Y" Then
		Sql = "Select * from T_Product Where id="&pid
	Else
		Sql = "Select * from T_Product Where id="&pid&"  and user_id="&Session("_UserID")
	End If
	Set Rs = Dream3CLS.Exec(Sql)
	If Rs.EOF Then
		Call Dream3CLS.MsgBox2("无法找到资源！"&Sql,0,"0")
		response.End()
	End If

	
	img1 = Rs("image")  
	img2 = Rs("image1")  
	img3 = Rs("image2")  
	img4 = Rs("image3")  
	img5 = Rs("image4")  
	img6 = Rs("image5")  
	img7 = Rs("image6")  
	img8 = Rs("image7")  
	img9 = Rs("image8")  
	img10 = Rs("image9") 
	
	if Isnull(img1) Then img1 = ""
	if Isnull(img2) Then img2 = ""
	if Isnull(img3) Then img3 = ""
	if Isnull(img4) Then img4 = ""
	if Isnull(img5) Then img5 = ""
	if Isnull(img6) Then img6 = ""
	if Isnull(img7) Then img7 = ""
	if Isnull(img8) Then img8 = ""
	if Isnull(img9) Then img9 = ""
	if Isnull(img10) Then img10 = ""


End Sub

Sub validateSubmit()
	'图片必须至少上传一个
	If img1="" Then
		gMsgArr = gMsgArr&"|图片必须至少上传第一个！"
	End If

	
End Sub

Sub validateDraft()

End Sub




Sub Main()	
	
	Call ShowEdit()

End Sub

%>
<%
G_Title_Content = "发布系统"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link href="<%=VirtualPath%>/common/themes/<%=Dream3CLS.SiteConfig("DefaultSiteStyle")%>/style/upload.css" rel="stylesheet" type="text/css" />
<form class="validator"  action="?act=save" method="post" id="productForm" name="productForm">
<div class="area">
	
    <div class="Details-tit">
        <span class="t6"><b><a href="pstep1.asp?pid=<%=pid%>">房间详情</a></b></span>
        <span class="t7"><b>上传照片</b></span>
        <span class="t3"><b>设施服务</b></span>
        <span class="t4"><b>入住与价格</b></span>
        <span class="t5"><b>预览</b></span>
    </div>
    
	<!--#include file="common/inc/publish_header.asp"-->
    
    <div class="layer2">
        <div class="side-top"></div>
        <div class="side-center">
            <div class="upload-l">
                <h4 class="title">上传照片</h4>
                <b>至少需要上传1张照片！</b><br>
                <b>图片要求</b>:
                <div>1、图片高度在476像素之上</div>
                <div>2、图片大小必须小于3M，大于3M的将无法上传成功，请先自行压缩</div>
                <div>3、图片大小在3M以内</div>
            </div>
          <div id="upi_showSmallImg" class="upload-r">
                <div id="thumbnails">
                
                </div>
                
            </div>
            
            <table width="100%" border="0" cellspacing="5" cellpadding="5">
              <tr>
                <td style="line-height:80px;">
                    <label style="padding-left:15px;">第1张</label>
                    <IMG src="<%If img1="" Then response.Write("images/noimage.gif") else response.Write(img1)%>" height=80 align=left name='src_img_1'>
                    <span style=cursor:hand onclick="window.open('common/upload/upload_image.asp?formname=productForm&amp;ImgSrc=src_img_1&amp;editname=src_img_h1','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')" >&gt;&gt;上传图片......</span> 
                          <INPUT type=hidden name=src_img_h1 value="<%=img1%>">
                </td>
                <td style="line-height:80px;">
                    <label style="padding-left:15px;">第2张</label>
                    <IMG src="<%If img2="" Then response.Write("images/noimage.gif") else response.Write(img2)%>" height=80 align=left name='src_img_2'>
<span style=cursor:hand onclick="window.open('common/upload/upload_image.asp?formname=productForm&amp;ImgSrc=src_img_2&amp;editname=src_img_h2','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')"  >&gt;&gt;上传图片......</span> 
                          <INPUT type=hidden name=src_img_h2 value="<%=img2%>">
                </td>
              </tr>
              <tr>
                <td style="line-height:80px;">
                    <label style="padding-left:15px;">第3张</label>
                    <IMG src="<%If img3="" Then response.Write("images/noimage.gif") else response.Write(img3)%>" height=80 align=left name='src_img_3'>
<span style=cursor:hand onclick="window.open('common/upload/upload_image.asp?formname=productForm&amp;ImgSrc=src_img_3&amp;editname=src_img_h3','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')"  >&gt;&gt;上传图片......</span> 
                          <INPUT type=hidden name=src_img_h3 value="<%=img3%>">
                </td>
                <td style="line-height:80px;">
                	<label style="padding-left:15px;">第4张</label>
                    <IMG src="<%If img4="" Then response.Write("images/noimage.gif") else response.Write(img4)%>" height=80 align=left name='src_img_4'>
<span style=cursor:hand onclick="window.open('common/upload/upload_image.asp?formname=productForm&amp;ImgSrc=src_img_4&amp;editname=src_img_h4','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')"  >&gt;&gt;上传图片......</span> 
                          <INPUT type=hidden name=src_img_h4 value="<%=img4%>">                    
                </td>
              </tr>
              <tr>
                <td style="line-height:80px;">
                	<label style="padding-left:15px;">第5张</label>
                    <IMG src="<%If img5="" Then response.Write("images/noimage.gif") else response.Write(img5)%>" height=80 align=left name='src_img_5'>
<span style=cursor:hand onclick="window.open('common/upload/upload_image.asp?formname=productForm&amp;ImgSrc=src_img_5&amp;editname=src_img_h5','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')"  >&gt;&gt;上传图片......</span> 
                          <INPUT type=hidden name=src_img_h5 value="<%=img5%>"> 
                </td>
                <td style="line-height:80px;">
                	<label style="padding-left:15px;">第6张</label>
                    <IMG src="<%If img6="" Then response.Write("images/noimage.gif") else response.Write(img6)%>" height=80 align=left name='src_img_6'>
<span style=cursor:hand onclick="window.open('common/upload/upload_image.asp?formname=productForm&amp;ImgSrc=src_img_6&amp;editname=src_img_h6','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')"  >&gt;&gt;上传图片......</span> 
                          <INPUT type=hidden name=src_img_h6 value="<%=img6%>"> 
                </td>
              </tr>
              <tr>
                <td style="line-height:80px;">
                	<label style="padding-left:15px;">第7张</label>
                    <IMG src="<%If img7="" Then response.Write("images/noimage.gif") else response.Write(img7)%>" height=80 align=left name='src_img_7'>
<span style=cursor:hand onclick="window.open('common/upload/upload_image.asp?formname=productForm&amp;ImgSrc=src_img_7&amp;editname=src_img_h7','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')"  >&gt;&gt;上传图片......</span> 
                          <INPUT type=hidden name=src_img_h7 value="<%=img7%>"> 
                </td>
                <td style="line-height:80px;">
                	<label style="padding-left:15px;">第8张</label>
                    <IMG src="<%If img8="" Then response.Write("images/noimage.gif") else response.Write(img8)%>" height=80 align=left name='src_img_8'>
<span style=cursor:hand onclick="window.open('common/upload/upload_image.asp?formname=productForm&amp;ImgSrc=src_img_8&amp;editname=src_img_h8','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')"  >&gt;&gt;上传图片......</span> 
                          <INPUT type=hidden name=src_img_h8 value="<%=img8%>"> 
                </td>
              </tr>
              <tr>
                <td style="line-height:80px;">
                	<label style="padding-left:15px;">第9张</label>
                    <IMG src="<%If img9="" Then response.Write("images/noimage.gif") else response.Write(img9)%>" height=80 align=left name='src_img_9'>
<span style=cursor:hand onclick="window.open('common/upload/upload_image.asp?formname=productForm&amp;ImgSrc=src_img_9&amp;editname=src_img_h9','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')"  >&gt;&gt;上传图片......</span> 
                          <INPUT type=hidden name=src_img_h9 value="<%=img9%>"> 
                </td>
                <td style="line-height:80px;">
                	<label style="padding-left:15px;">第10张</label>
                    <IMG src="<%If img10="" Then response.Write("images/noimage.gif") else response.Write(img10)%>" height=80 align=left name='src_img_10'>
<span style=cursor:hand onclick="window.open('common/upload/upload_image.asp?formname=productForm&amp;ImgSrc=src_img_10&amp;editname=src_img_h10','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')"  >&gt;&gt;上传图片......</span> 
                          <INPUT type=hidden name=src_img_h10 value="<%=img10%>"> 
                </td>
              </tr>
            </table>
            
            <div class="clear"></div>
        </div>
        <div class="side-bottom"></div>
	</div>
	
    <div class="next">
        <dl>
        	<!--<dt class="Button-3 font14_white"><a href="pstep1.asp?pid=<%=pid%>"><上一步</a></dt>-->
        	<dd><input type="submit" id="searchBt" value="提交" class="input_next"></dd>
        </dl>
    </div>
    
    <div class="clear"></div>
    
</div>
<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
</form>
<!--#include file="common/inc/footer_user.asp"-->