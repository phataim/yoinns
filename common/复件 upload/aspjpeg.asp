<%
Function f1(path1,path2)
Set Jpeg = Server.CreateObject("Persits.Jpeg")
' �������
Jpeg.Open Server.MapPath(path1)
' ��ͼƬ
'Ҳ������OpenBinary��ȡ����������
' ������д��ˮӡ����
Jpeg.Canvas.Font.Color = &Hffffff ' ��ɫ,���������ó�:��
Jpeg.Canvas.Font.Family = "��Բ" 'family��������
Jpeg.Canvas.Font.Bold = True '�Ƿ����óɴ���
Jpeg.Canvas.Font.Size = 20 '�����С
Jpeg.Canvas.Print Jpeg.width-80, Jpeg.height-30, "���ù�" '����Ӧ��λ�ô�ӡ���֣�������ҿ�����Jpeg.Canvas.Print Jpeg.width-160, Jpeg.height-30, "863171.COM"Jpeg.Canvas.Print 20, 20,
Jpeg.Save Server.MapPath(path2) 'OK,�󹦸��,���뱣��!
End Function

response.write "���"
%> 

<%
Function f(oldpath,newpath)
Set Jpeg = Server.CreateObject("Persits.Jpeg")
Path = Server.MapPath(oldpath)
Jpeg.Open Path
Jpeg.Width = Jpeg.OriginalWidth / 2 
Jpeg.Height = Jpeg.OriginalHeight / 2 
'�ı��ԭ����50%,Jpeg.Width,Jpeg.HeightҲ���Ը���׼ȷ����ֵ������Jpeg.Width=120
Jpeg.Save Server.MapPath(newpath)
End function
%> 