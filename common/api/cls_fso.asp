<%
Class  Dream3_File

  	Public Function CreateMultiFolder(ByVal CFolder)
		Dim objFSO,PhCreateFolder,CreateFolderArray,CreateFolder
		Dim i,ii,CreateFolderSub,PhCreateFolderSub,BlInfo
		BlInfo = False
		CreateFolder = CFolder
		On Error Resume Next
		Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
		If Err Then
			Err.Clear()
			Exit Function
		End If
		CreateFolder = Replace(CreateFolder,"\","/")
		
		
		If Right(CreateFolder,1)="/" Then
			CreateFolder = Left(CreateFolder,Len(CreateFolder)-1)
		End If
		
		CreateFolderArray = Split(CreateFolder,"/")
		For i = 0 to UBound(CreateFolderArray)
			CreateFolderSub = ""
			For ii = 0 to i
				CreateFolderSub = CreateFolderSub & CreateFolderArray(ii) & "/"
			Next
		
			PhCreateFolderSub = Server.MapPath(CreateFolderSub)
			If Not objFSO.FolderExists(PhCreateFolderSub) Then
				
		
				objFSO.CreateFolder(PhCreateFolderSub)
			End If
		Next
		If Err Then
			Err.Clear()
		Else
			BlInfo = True
		End If
		Set objFSO=nothing
		CreateMultiFolder = BlInfo
	End Function
	
	Public Function CreateAbsoluteFolder(ByVal CFolder)
		Dim objFSO,PhCreateFolder,CreateFolderArray,CreateFolder
		Dim i,ii,CreateFolderSub,PhCreateFolderSub,BlInfo
		BlInfo = False
		CreateFolder = CFolder
		On Error Resume Next
		Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
		If Err Then
			Err.Clear()
			Exit Function
		End If
		CreateFolder = Replace(CreateFolder,"\","/")
		
		
		If Right(CreateFolder,1)="/" Then
			CreateFolder = Left(CreateFolder,Len(CreateFolder)-1)
		End If
		
		
		If Not objFSO.FolderExists(CreateFolder) Then
			objFSO.CreateFolder(CreateFolder)
		End If

		If Err Then
			Err.Clear()
		Else
			BlInfo = True
		End If
		
		Set objFSO=nothing
		CreateAbsoluteFolder = BlInfo
	End Function
	
	Function  LoadFile(s_file) 
	    on error resume next
		Dim  Str,A_W
		set A_W=server.CreateObject("adodb.Stream")
		A_W.Type=2 
		A_W.mode=3 
		A_W.charset="gb2312"
		A_W.open
		A_W.loadfromfile s_file
 		If Err.Number<>0 Then LoadFile ="" :Exit Function
		Str=A_W.readtext
		A_W.Close
		Set  A_W=nothing
		LoadFile=Str
	End  function
	
	Sub SaveToFile(ByVal strBody,ByVal FilePath) 
		Dim objStream 
		On Error Resume Next 
		Set objStream = Server.CreateObject("ADODB.Stream") 
		If Err.Number=-2147221005 Then 
		Response.Write "<div align='center'>非常遗憾,您的主机不支持ADODB.Stream,不能使用本程序</div>" 
		Err.Clear 
		Response.End 
		End If 
		With objStream 
		.Type = 2 
		.Open 
		.Charset = "GB2312" 
		.Position = objStream.Size 
		.WriteText = strBody 
		.SaveToFile FilePath,2 
		.Close 
		End With 
		Set objStream = Nothing 
		if err.number <> 0 Then
			t("MMMMMM"&err.description&"<>"&FilePath)
		end if
	End Sub
	
	Public Function DeleteFile(ByVal f_filepath)
		Dim BlInfo  , s_filePath
		BlInfo = False
		On Error Resume Next 
		Set objFSO = Server.CreateObject("Scripting.FileSystemObject")

		If objFSO.FileExists(f_filepath) Then
			objFSO.DeleteFile f_filepath
			If Err<>0 Then Err.Clear
			BlInfo = true
		End If
		Set objFSO = Nothing
		DeleteFile = BlInfo
	End Function

End Class

Dim Dream3File
Set Dream3File = New Dream3_File

%>