<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<%

Server.ScriptTimeOut=9999999
Response.Buffer = True

dim FoundErr, ErrMsg, Action
dim MailServerUserName, MailServerPassWord, MailDomain, MailServer
dim MailtoAddress, MailtoName, Subject, MailBody, FromName, MailFrom, Priority

FoundErr = False
ErrMsg = ""
Action = Trim(Request("action"))
ComeUrl = ""
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>群发邮件系统</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<META content="Microsoft FrontPage 4.0" Name=GENERATOR>
<STYLE type=text/css>
a {text-decoration: none;} /* 链接无下划线,有为underline */ 
a:link {color: #000000;text-decoration: none;} /* 未访问的链接 */
a:visited {color: #000000;text-decoration: none;} /* 已访问的链接 */
a:hover {color: #ff6600;text-decoration: none;} /* 鼠标在链接上 */ 
a:active {color: #000000;text-decoration: none;} /* 点击激活链接 */
TD {
 FONT-SIZE: 18px; COLOR: #000000; FONT-FAMILY: '宋体';LINE-HEIGHT: 150%;
}
BODY {
 FONT-SIZE: 12px; COLOR: #000000; FONT-FAMILY: '宋体'
}
INPUT {
 FONT-SIZE: 12px; COLOR: #000000; FONT-FAMILY: '宋体'
}
SELECT {
 FONT-SIZE: 12px; COLOR: #000000; FONT-FAMILY: '宋体'
}
.title
{
 background:#0DB432;
 color: #ffffff;
 font-weight: normal;
}
.border
{
 border: 1px solid #0DB432;
}
.tdbg{
 background:#f0f0f0;
 line-height: 120%;
}
.tdbg1{
 background:#A3E2B1;
 line-height: 120%;
}
</STYLE>
</HEAD>

<BODY text=#000000 bgColor=#ffffff leftMargin=0 topMargin=0>
<br>
<%
Select Case Action
 Case "send"
  Call sendMail()
 Case Else
  Call Main()
End Select
If FoundErr = True Then
 Response.Write WriteErrMsg(ErrMsg, ComeUrl,"错误信息")
End If
Response.write"</BODY></HTML>"

sub main()

    If Not IsObjInstalled("JMail.Message") Then
  FoundErr=True
        ErrMsg = "服务器不支持JMail组件，请正确安装"
  Exit Sub
    End If       
  %>
 <form action="wssf.asp?Action=send" method=post>
   <table width="80%" class="border" border="0" cellspacing="1" cellpadding="4" align="center" height="589"> 
  <tr>  
    <td height="40" colspan="2" align="center" class="title">  
            <p><b> 群发邮件系统</b></p>        </td> 
  </tr>
  <tr>
    <td width='30%' class='tdbg1' height="25"><strong>邮件服务器地址：</strong> </td>
    <td class='tdbg' height="25">
   <input name='MailServer' type='text' id='MailServer' value='smtp.163.com' size='40'> <FONT color=#ff0000>*</FONT>
    </td>
  </tr>
  <tr>
    <td width='30%' class='tdbg1' height="25"><strong>登录用户名一：</strong>
   </td>
    <td class='tdbg' height="25">
   <input name='MailServerUserName1' type='text' id='MailServerUserName1' value='XXX' size='40'> <FONT color=#ff0000>*</FONT>
    </td>
  </tr>
  <tr>
    <td width='30%' class='tdbg1' height="25"><strong>登录密码一：</strong>
    </td>
    <td class='tdbg' height="25">
   <input name='MailServerPassWord1' type='password' id='MailServerPassWord1' value='***' size='40'> <FONT color=#ff0000>*</FONT>
    </td>
  </tr>
  
  <tr>
    <td width="30%" class="tdbg1" height="25">您的姓名：</td>
    <td class="tdbg" height="25"><input name="name" type=text id="name" size=30>
    <FONT color=#ff0000>*</FONT></td>                            
  </tr>
  <tr>
    <td width="30%" class="tdbg1" height="25">您的E-mail：</td>
    <td class="tdbg" height="25"><input name="email" type=text id="email" value="XXX@163.com" size=30>
    <FONT color=#ff0000>*</FONT></td>                            
  </tr>
  <tr>
    <td width="30%" class="tdbg1" height="25">收件人姓名：</td>
    <td class="tdbg" height="25"><input name="toname" type=text id="toname" size=30>
    <FONT color=#ff0000>*</FONT></td>                            
  </tr>
  <tr>
    <td width="30%" class="tdbg1" height="25">收件人Email:</td>
    <td class="tdbg" height="25"><input name="toemail" type="text" id="toemail" size="30" maxlength="100">
    <FONT color=#ff0000>*</FONT></td>
  </tr>
  <tr>
    <td width="30%" class="tdbg1" height="25">邮件标题：</td>
    <td class="tdbg" height="25"><input type=text name="topic" size=30>
    <FONT color=#ff0000>*</FONT></td>                            
  </tr>
  <tr>
    <td width="30%" class="tdbg1" height="500">邮件内容：</td>
    <td class="tdbg" height="500"><textarea name="body" cols=74 rows=34 id="body"></textarea>
    <FONT color=#ff0000>*</FONT></td>                            
  </tr>
  <tr>
    <td width="30%" class="tdbg" height="27"></td>
    <td height=27 class="tdbg">
   <input type="Submit" value="发送邮件" name="Submit">
    
   <input type="reset" name="Clear" value="重新填写">
    </td>
  </tr>
   </table>
 </form>
 <%
End Sub

Sub sendMail()
 MailServer = trim(Request("MailServer")) 'SMTP服务器地址：smtp.163.com, 请修改
 MailServerUserName = trim(Request("MailServerUserName")) 'SMTP登录用户名：XXX@163.com, 请修改
 MailServerPassWord = trim(Request("MailServerPassWord")) 'SMTP登录密码：***, 请修改,注意大小写
 MailDomain = trim(Request("MailDomain")) 'SMTP域名：163.com, 请修改

 FromName = trim(Request("name")) '发件人名字
 MailFrom = trim(Request("email")) '发件人邮箱
 MailtoName = trim(Request("toname")) '发件人名字
 MailtoAddress=trim(Request("toemail")) '收件人邮箱
 Subject = trim(Request("topic"))
 MailBody = trim(Request("body"))
 Priority=3
 If FromName="" or MailFrom="" or MailtoName=""  or Subject="" or MailBody="" then
  FoundErr = True
  ErrMsg = "请填写完整每一项信息！"
  Exit Sub
 End If
 ErrMsg = JSendMail()
 If ErrMsg<>"" Then 
  FoundErr = True
  Exit Sub
 Else
  Response.Write WriteErrMsg("", ComeUrl,"成功信息")
 End If
End Sub

Function JSendMail()
    On Error Resume Next
 
    
 JSendMail = ""
    Dim JMail,tempMessage
    Set JMail = Server.CreateObject("JMail.Message")
    JMail.silent=true 
    JMail.Logging = True 
    
    JMail.Charset = "gb2312"        '邮件编码
    JMail.silent = True
    JMail.ContentType = "text/html"     '邮件正文格式
    JMail.ServerAddress=MailServer     '用来发送邮件的SMTP服务器
    '如果服务器需要SMTP身份验证则还需指定以下参数
    JMail.MailServerUserName = MailServerUserName1    '登录用户名
    JMail.MailServerPassWord = MailServerPassWord1        '登录密码
    
    JMail.AddRecipient MailtoAddress, MailtoName    '收信人
    JMail.Subject = Subject       '主题
    JMail.HtmlBody = MailBody     '邮件正文（HTML格式）
    JMail.Body = MailBody        '邮件正文（纯文本格式）
    JMail.FromName = FromName       '发信人姓名
    JMail.From = MailFrom         '发信人Email
    JMail.Priority = Priority            '邮件等级，1为加急，3为普通，5为低级
    Dim emailArray
 If MailtoAddress="" then
 set fsObj = Server.CreateObject("Scripting.FileSystemObject")
    FilePath = Server.MapPath("email.txt")
    set txtsObj = fsObj.OpenTextFile(FilePath, 1, false)
    i = 0
    Do While Not txtsObj.atEndOfStream
    emailArray(i)=txtsObj.ReadLine
    JMail.AddRecipient Trim(emailArray(i)),MailtoName
    i=i+1
    loop
    Else
    JMail.AddRecipient MailtoAddress, MailtoName
    End If
    JMail.Send (MailServer)
    tempMessage = JMail.ErrorMessage
    JMail.Close
    Set JMail = Nothing
 If tempMessage<>"" then
  FoundErr = True
  JSendMail = tempMessage
 end if
 Set JMail = Nothing
End Function

Function IsObjInstalled(strClassString)
    On Error Resume Next
    IsObjInstalled = False
    Err = 0
    Dim xTestObj
    Set xTestObj = CreateObject(strClassString)
    If Err.Number = 0 Then IsObjInstalled = True
    Set xTestObj = Nothing
    Err = 0
End Function


Function WriteErrMsg(sMsg, sComeUrl,Massages)
    Dim strMsg
    strMsg = strMsg & "<html><head><title>"&Massages&"</title><meta http-equiv='Content-Type' content='text/html; charset=gb2312'>" & vbCrLf
    strMsg = strMsg & "</head><body><br><br>" & vbCrLf
    strMsg = strMsg & "<table cellpadding=2 cellspacing=1 border=0 width=400 class='border' align=center>" & vbCrLf
    strMsg = strMsg & "  <tr align='center' class='title'><td height='22'><strong>"&Massages&"</strong></td></tr>" & vbCrLf
 if FoundErr=True Then
  strMsg = strMsg & "  <tr class='tdbg'><td height='100' valign='top'><b>产生错误的可能原因：</b>" & sMsg & "</td></tr>" & vbCrLf
 Else
  strMsg = strMsg & "  <tr class='tdbg'><td height='100' valign='top'><br><b>恭喜，成功用JMail发送邮件！</b>" & sMsg & "</td></tr>" & vbCrLf
 End If
    strMsg = strMsg & "  <tr align='center' class='tdbg'><td>"
    If sComeUrl <> "" Then
        strMsg = strMsg & "<a href='javascript:history.go(-1)'><< 返回上一页</a>"
    Else
        strMsg = strMsg & "<a href='javascript:window.close();'>【关闭】</a>"
    End If
    strMsg = strMsg & "</td></tr>" & vbCrLf
    strMsg = strMsg & "</table>" & vbCrLf
    strMsg = strMsg & "</body></html>" & vbCrLf
    WriteErrMsg = strMsg
End Function
%>