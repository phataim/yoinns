<%
	'���ܣ������ʻ��й���Ϣ������·������������ҳ�棩
	'�汾��3.1
	'���ڣ�2010-11-23
	'˵����
	'���´���ֻ��Ϊ�˷����̻����Զ��ṩ���������룬�̻����Ը����Լ���վ����Ҫ�����ռ����ĵ���д,����һ��Ҫʹ�øô��롣
	'�ô������ѧϰ���о�֧�����ӿ�ʹ�ã�ֻ���ṩһ���ο���

'��ʾ����λ�ȡ��ȫУ����ͺ���������ID
'1.����֧�����̻���������(b.alipay.com)��Ȼ��������ǩԼ֧�����˺ŵ�½.
'2.���ʡ��������񡱡������ؼ��������ĵ�����https://b.alipay.com/support/helperApply.htm?action=selfIntegration��
'3.�ڡ��������ɰ������У����������������(Partner ID)��ѯ��������ȫУ����(Key)��ѯ��

'��ȫУ����鿴ʱ������֧�������ҳ��ʻ�ɫ��������ô�죿
'���������
'1�������������ã������������������������
'2���������������ԣ����µ�¼��ѯ��

'�����������������������������������Ļ�����Ϣ������������������������������
'����������ID����2088��ͷ��16λ������
partner         = Dream3CLS.SiteConfig("AlipayID")

'��ȫ�����룬�����ֺ���ĸ��ɵ�32λ�ַ�
key   			= Dream3CLS.SiteConfig("AlipayKey")

'ǩԼ֧�����˺Ż�����֧�����ʻ�
seller_email    = Dream3CLS.SiteConfig("AlipayAccount")

'���׹����з�����֪ͨ��ҳ�� Ҫ�� http://��ʽ������·������������?id=123�����Զ������
notify_url      = GetSiteUrl&"/onlinepay/alipay/notify_url.asp"

'��������ת��ҳ�� Ҫ�� http://��ʽ������·������������?id=123�����Զ������
return_url      = GetSiteUrl&"/onlinepay/return_alipay.asp"

'��վ��Ʒ��չʾ��ַ����������?id=123�����Զ������
show_url        = GetSiteUrl

'�տ���ƣ��磺��˾���ơ���վ���ơ��տ���������
mainname		= Dream3CLS.SiteConfig("SiteName")

'�����������������������������������Ļ�����Ϣ������������������������������



'�ַ������ʽ Ŀǰ֧�� gbk �� utf-8
input_charset	= "gbk"

'ǩ����ʽ �����޸�
sign_type       = "MD5"


%>