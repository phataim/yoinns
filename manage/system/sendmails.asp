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
<TITLE>Ⱥ���ʼ�ϵͳ</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<META content="Microsoft FrontPage 4.0" Name=GENERATOR>
<STYLE type=text/css>
a {text-decoration: none;} /* �������»���,��Ϊunderline */ 
a:link {color: #000000;text-decoration: none;} /* δ���ʵ����� */
a:visited {color: #000000;text-decoration: none;} /* �ѷ��ʵ����� */
a:hover {color: #ff6600;text-decoration: none;} /* ����������� */ 
a:active {color: #000000;text-decoration: none;} /* ����������� */
TD {
 FONT-SIZE: 18px; COLOR: #000000; FONT-FAMILY: '����';LINE-HEIGHT: 150%;
}
BODY {
 FONT-SIZE: 12px; COLOR: #000000; FONT-FAMILY: '����'
}
INPUT {
 FONT-SIZE: 12px; COLOR: #000000; FONT-FAMILY: '����'
}
SELECT {
 FONT-SIZE: 12px; COLOR: #000000; FONT-FAMILY: '����'
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
 Response.Write WriteErrMsg(ErrMsg, ComeUrl,"������Ϣ")
End If
Response.write"</BODY></HTML>"

sub main()

    If Not IsObjInstalled("JMail.Message") Then
  FoundErr=True
        ErrMsg = "��������֧��JMail���������ȷ��װ"
  Exit Sub
    End If       
  %>
 <form action="wssf.asp?Action=send" method=post>
   <table width="80%" class="border" border="0" cellspacing="1" cellpadding="4" align="center" height="589"> 
  <tr>  
    <td height="40" colspan="2" align="center" class="title">  
            <p><b> Ⱥ���ʼ�ϵͳ</b></p>        </td> 
  </tr>
  <tr>
    <td width='30%' class='tdbg1' height="25"><strong>�ʼ���������ַ��</strong> </td>
    <td class='tdbg' height="25">
   <input name='MailServer' type='text' id='MailServer' value='smtp.163.com' size='40'> <FONT color=#ff0000>*</FONT>
    </td>
  </tr>
  <tr>
    <td width='30%' class='tdbg1' height="25"><strong>��¼�û���һ��</strong>
   </td>
    <td class='tdbg' height="25">
   <input name='MailServerUserName1' type='text' id='MailServerUserName1' value='XXX' size='40'> <FONT color=#ff0000>*</FONT>
    </td>
  </tr>
  <tr>
    <td width='30%' class='tdbg1' height="25"><strong>��¼����һ��</strong>
    </td>
    <td class='tdbg' height="25">
   <input name='MailServerPassWord1' type='password' id='MailServerPassWord1' value='***' size='40'> <FONT color=#ff0000>*</FONT>
    </td>
  </tr>
  
  <tr>
    <td width="30%" class="tdbg1" height="25">����������</td>
    <td class="tdbg" height="25"><input name="name" type=text id="name" size=30>
    <FONT color=#ff0000>*</FONT></td>                            
  </tr>
  <tr>
    <td width="30%" class="tdbg1" height="25">����E-mail��</td>
    <td class="tdbg" height="25"><input name="email" type=text id="email" value="XXX@163.com" size=30>
    <FONT color=#ff0000>*</FONT></td>                            
  </tr>
  <tr>
    <td width="30%" class="tdbg1" height="25">�ռ���������</td>
    <td class="tdbg" height="25"><input name="toname" type=text id="toname" size=30>
    <FONT color=#ff0000>*</FONT></td>                            
  </tr>
  <tr>
    <td width="30%" class="tdbg1" height="25">�ռ���Email:</td>
    <td class="tdbg" height="25"><input name="toemail" type="text" id="toemail" size="30" maxlength="100">
    <FONT color=#ff0000>*</FONT></td>
  </tr>
  <tr>
    <td width="30%" class="tdbg1" height="25">�ʼ����⣺</td>
    <td class="tdbg" height="25"><input type=text name="topic" size=30>
    <FONT color=#ff0000>*</FONT></td>                            
  </tr>
  <tr>
    <td width="30%" class="tdbg1" height="500">�ʼ����ݣ�</td>
    <td class="tdbg" height="500"><textarea name="body" cols=74 rows=34 id="body"></textarea>
    <FONT color=#ff0000>*</FONT></td>                            
  </tr>
  <tr>
    <td width="30%" class="tdbg" height="27"></td>
    <td height=27 class="tdbg">
   <input type="Submit" value="�����ʼ�" name="Submit">
    
   <input type="reset" name="Clear" value="������д">
    </td>
  </tr>
   </table>
 </form>
 <%
End Sub

Sub sendMail()
 MailServer = trim(Request("MailServer")) 'SMTP��������ַ��smtp.163.com, ���޸�
 MailServerUserName = trim(Request("MailServerUserName")) 'SMTP��¼�û�����XXX@163.com, ���޸�
 MailServerPassWord = trim(Request("MailServerPassWord")) 'SMTP��¼���룺***, ���޸�,ע���Сд
 MailDomain = trim(Request("MailDomain")) 'SMTP������163.com, ���޸�

 FromName = trim(Request("name")) '����������
 MailFrom = trim(Request("email")) '����������
 MailtoName = trim(Request("toname")) '����������
 MailtoAddress=trim(Request("toemail")) '�ռ�������
 Subject = trim(Request("topic"))
 MailBody = trim(Request("body"))
 Priority=3
 If FromName="" or MailFrom="" or MailtoName=""  or Subject="" or MailBody="" then
  FoundErr = True
  ErrMsg = "����д����ÿһ����Ϣ��"
  Exit Sub
 End If
 ErrMsg = JSendMail()
 If ErrMsg<>"" Then 
  FoundErr = True
  Exit Sub
 Else
  Response.Write WriteErrMsg("", ComeUrl,"�ɹ���Ϣ")
 End If
End Sub

Function JSendMail()
    On Error Resume Next
 
    
 JSendMail = ""
    Dim JMail,tempMessage
    Set JMail = Server.CreateObject("JMail.Message")
    JMail.silent=true 
    JMail.Logging = True 
    
    JMail.Charset = "gb2312"        '�ʼ�����
    JMail.silent = True
    JMail.ContentType = "text/html"     '�ʼ����ĸ�ʽ
    JMail.ServerAddress=MailServer     '���������ʼ���SMTP������
    '�����������ҪSMTP�����֤����ָ�����²���
    JMail.MailServerUserName = MailServerUserName1    '��¼�û���
    JMail.MailServerPassWord = MailServerPassWord1        '��¼����
    
    JMail.AddRecipient MailtoAddress, MailtoName    '������
    JMail.Subject = Subject       '����
    JMail.HtmlBody = MailBody     '�ʼ����ģ�HTML��ʽ��
    JMail.Body = MailBody        '�ʼ����ģ����ı���ʽ��
    JMail.FromName = FromName       '����������
    JMail.From = MailFrom         '������Email
    JMail.Priority = Priority            '�ʼ��ȼ���1Ϊ�Ӽ���3Ϊ��ͨ��5Ϊ�ͼ�
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
  strMsg = strMsg & "  <tr class='tdbg'><td height='100' valign='top'><b>��������Ŀ���ԭ��</b>" & sMsg & "</td></tr>" & vbCrLf
 Else
  strMsg = strMsg & "  <tr class='tdbg'><td height='100' valign='top'><br><b>��ϲ���ɹ���JMail�����ʼ���</b>" & sMsg & "</td></tr>" & vbCrLf
 End If
    strMsg = strMsg & "  <tr align='center' class='tdbg'><td>"
    If sComeUrl <> "" Then
        strMsg = strMsg & "<a href='javascript:history.go(-1)'><< ������һҳ</a>"
    Else
        strMsg = strMsg & "<a href='javascript:window.close();'>���رա�</a>"
    End If
    strMsg = strMsg & "</td></tr>" & vbCrLf
    strMsg = strMsg & "</table>" & vbCrLf
    strMsg = strMsg & "</body></html>" & vbCrLf
    WriteErrMsg = strMsg
End Function
%>