<%
Rem ************************************************
Rem ** ����: ���º�(xiaoyuehen)
Rem ** ASP ͨ�÷�ҳ��
Rem ** �汾: 1.2.00
Rem ** ����޸�: 2005-4-18
Rem ** ��Ȩ˵��: ���ĵ�������ǰ���¿����⸴��, ����.
Rem ** ��ϵ����: xiaoyuehen(at)msn.com
Rem ************************************************
'�˰汾�������޸�.��Ҫֱ�Ӹ���
Class Cls_PageView
	Private sbooInitState
	Private sstrPageUrl
	Private sstrPageVar
	Private sstrSql
	Private sstrSqlCount

	Private sintRecordCount
	Private sintPageSize
	Private sintPageNow
	Private sintPageMax

	Private sobjConn

	Private sstrPageInfo

	Private Sub Class_Initialize
		Call ClearVars()
	End Sub

	Private Sub class_terminate()
		Set sobjConn = nothing
	End Sub

	Public Sub ClearVars()
		sbooInitState = False
		sstrPageUrl = ""
		sstrPageVar = "page"

		sintRecordCount = 0
		sintPageSize = 20
		sintPageNow = 0
		sintPageMax = 0
	End Sub

	Private Sub ClearMainVars()
		sstrSql = ""
	End Sub

	Rem ## SQL���
	Public Property Let strSQL(Value)
		sstrSql = Value
	End Property

	Rem ## SQL���
	Public Property Let strSQLCount(Value)
		sstrSqlCount = Value
	End Property

	Rem ## ת���ַ
	Public Property Let strPageUrl(Value)
		sstrPageUrl = Value
	End Property

	Rem ## ÿҳ��ʾ�ļ�¼����
	Public Property Let intPageSize(Value)
		sintPageSize = toNum(Value, 20)
	End Property

	Rem ## ���ݿ����Ӷ���
	Public Property Let objConn(Value)
		Set sobjConn = Value
	End Property

	Rem ## ��ǰҳ
	Public Property Let intPageNow(Value)
		sintPageNow = toNum(Value, 1)
	End Property

	Rem ## ���ü�¼����
	Public Property Let intRecordCount(Value)
		sintRecordCount = toNum(Value, -1)
		If sintRecordCount < 0 Then sintRecordCount = -1
	End Property

	Rem ## ҳ�����
	Public Property Let strPageVar(Value)
		sstrPageVar = Value
	End Property

	Rem ## ��õ�ǰҳ
	Public Property Get intPageNow()
		intPageNow = singPageNow
	End Property

	Rem ## ��ҳ��Ϣ
	Public Property Get strPageInfo()
		strPageInfo = sstrPageInfo
	End Property
	
	Rem ## �ܼ�¼��
	Public Property Get strTotalRecord()
		strTotalRecord = sintRecordCount
	End Property

	Rem ## ȡ�ü�¼��, ��ά������ִ�, �ڽ���ѭ�����ʱ������ IsArray() �ж�
	Public Property Get arrRecordInfo()
		Call InitClass()
		If Not sbooInitState Then
			Response.Write("��ҳ���ʼ��ʧ��, ������������")
			Exit Property
		End If

		Dim rs, sql
		sql = sstrSql

		Set rs = Server.CreateObject("Adodb.RecordSet")

		Rem ����¼��ͳ����䲻Ϊ��, ��ȡ���ִ�к��һ���ֶ�ֵ��Ϊ��¼��
		If sstrSqlCount <> "" Then
			rs.Open sstrSqlCount, sobjConn, 1, 1
			If Not(rs.eof or rs.bof) Then
				sintRecordCount = rs(0)
			Else
				sintRecordCount = 0
			End If
			rs.Close
		End If

		rs.open sql, sobjConn, 1, 1

		Rem ���޼�¼ͳ�������δ�趨��¼����, ���ɼ�¼��RecordCount���Եó�.
		If sintRecordCount < 0 Then
			sintRecordCount = rs.RecordCount
		End If
		If sintRecordCount < 0 Then sintRecordCount = 0

		'���ɷ�ҳ��Ϣ
		Call InitPageInfo()

		If Not(rs.eof or rs.bof) Then
			rs.PageSize = sintPageSize
			If  sintPageNow =0 Then sintPageNow=1
 			rs.AbsolutePage = sintPageNow
			If Not(rs.eof or rs.bof) Then
				arrRecordInfo = rs.getrows(sintPageSize)
			Else
				arrRecordInfo = ""
			End If
		Else
			arrRecordInfo = ""
		End If
		rs.close
		Set rs = nothing

		Call ClearMainVars()
	End Property

	Rem ## ��ʼ����ҳ��Ϣ
	Private Sub InitPageInfo()
		sstrPageInfo = ""

		Dim surl
		surl = sstrPageUrl
		If Instr(1, surl, "?", 1) > 0 Then
			surl = surl & "&" & sstrPageVar & "="
		Else
			surl = surl & "?" & sstrPageVar & "="
		End If

		If sintPageNow <= 0 Then sintPageNow = 1
		If sintRecordCount mod sintPageSize = 0 Then
			sintPageMax = sintRecordCount \ sintPageSize
		Else
			sintPageMax = sintRecordCount \ sintPageSize + 1
		End If
		If sintPageNow > sintPageMax Then sintPageNow = sintPageMax

		If sintPageNow <= 1 then
			sstrPageInfo = "��ҳ ��һҳ"
		Else
			sstrPageInfo = sstrPageInfo & " <a href=""" & surl & "1"">��ҳ</a>"
			sstrPageInfo = sstrPageInfo & " <a href=""" & surl & (sintPageNow - 1) & """>��һҳ</a>"
		End If

		If sintPageMax - sintPageNow < 1 then
			sstrPageInfo = sstrPageInfo & " ��һҳ ĩҳ "
		Else
			sstrPageInfo = sstrPageInfo & " <a href=""" & surl & (sintPageNow + 1) & """>��һҳ</a> "
			sstrPageInfo = sstrPageInfo & " <a href=""" & surl & sintPageMax & """>ĩҳ</a> "
		End If

		sstrPageInfo = sstrPageInfo & " ҳ�Σ�<strong><font color=""#990000"">" & sintPageNow & "</font> / " & sintPageMax & " </strong>"
		sstrPageInfo = sstrPageInfo & " �� <strong>" & sintRecordCount & "</strong> ����¼ <strong>" & sintPageSize & "</strong> ��/ҳ "
		sstrPageInfo = sstrPageInfo &" ת��<INPUT id=page  size=1 name=page value="&sintPageNow + 1&">ҳ<INPUT id=go class=ACT_BTN onclick=""{location.href='"&surl&"' + page.value + '';}"" type=button value=' GO ' name=go> "
	End Sub

	Rem ## ������ת��
	Private function toNum(s, Default)
		s = s & ""
		If s <> "" And IsNumeric(s) Then
			toNum = CLng(s)
		Else
			toNum = Default
		End If
	End function

	Rem ## ���ʼ��
	Public Sub InitClass()
		sbooInitState = True
		If Not(IsObject(sobjConn)) Then
			sbooInitState = False

			response.write("���ݿ�����δָ��")
			response.End()
		End If
		If Trim(sstrSql) = "" Then
			sbooInitState = False

			response.write("SQL���δָ��")
			response.End()
		End If
		sintPageSize = toNum(sintPageSize, 20)
		If (sintPageSize < 1) Or (sintPageSize > 100) Then
			sbooInitState = False

			response.write("ÿҳ�Ǽ���δ���û򲻷��Ϲ���(1 - 100)")
			response.End()
		End If
		sintPageNow = toNum(sintPageNow, 1)

		sintRecordCount = -1
	End Sub
End Class
%>