<%
Function f1(path1,path2)
Set Jpeg = Server.CreateObject("Persits.Jpeg")
' 创建组件
Jpeg.Open Server.MapPath(path1)
' 打开图片
'也可以用OpenBinary读取二进制数据
' 以下是写入水印文字
Jpeg.Canvas.Font.Color = &Hffffff ' 颜色,这里是设置成:黑
Jpeg.Canvas.Font.Family = "幼圆" 'family设置字体
Jpeg.Canvas.Font.Bold = True '是否设置成粗体
Jpeg.Canvas.Font.Size = 20 '字体大小
Jpeg.Canvas.Print Jpeg.width-80, Jpeg.height-30, "有旅馆" '在相应的位置打印文字，如果靠右可以用Jpeg.Canvas.Print Jpeg.width-160, Jpeg.height-30, "863171.COM"Jpeg.Canvas.Print 20, 20,
Jpeg.Save Server.MapPath(path2) 'OK,大功告成,输入保存!
End Function

response.write "完成"
%> 

<%
Function f(oldpath,newpath)
Set Jpeg = Server.CreateObject("Persits.Jpeg")
Path = Server.MapPath(oldpath)
Jpeg.Open Path
Jpeg.Width = Jpeg.OriginalWidth / 2 
Jpeg.Height = Jpeg.OriginalHeight / 2 
'改变成原来的50%,Jpeg.Width,Jpeg.Height也可以给他准确的数值，比如Jpeg.Width=120
Jpeg.Save Server.MapPath(newpath)
End function
%> 