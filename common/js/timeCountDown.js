var SysSecond;   
var InterValObj;   
var arr = new Array();
 
var parseStr = "";

    
 $(document).ready(function() {   
	parseStr = $("#remainSeconds").html(); //�����ȡ����ʱ����ʼʱ��   
	var arr1 = parseStr.split(":")
	for(var i = 0;i < arr1.length;i ++){
		arr[i] = arr1[i].split(",")
	}
	SetRemainTime();
    InterValObj = window.setInterval(SetRemainTime, 1000); //���������1��ִ��   
 });   
  
 //��ʱ���ȥ1�룬�����졢ʱ���֡���   
 function SetRemainTime() {   
 	for(var i = 0;i < arr.length;i ++){
		if (arr[i][1] > 0) {   
		   arr[i][1] = arr[i][1] - 1;   
		   var second = Math.floor(arr[i][1] % 60);             // ������       
		   var minite = Math.floor((arr[i][1] / 60) % 60);      //�����   
		   var hour = Math.floor((arr[i][1] / 3600) % 24);      //����Сʱ   
		   var day = Math.floor((arr[i][1] / 3600) / 24);        //������   
		  
		   //$("#remainTime_"+ arr[i][0]).html(day + "��" + hour + "Сʱ" + minite + "��" + second + "��");  
		   $("#remainTime_"+ arr[i][0]).html("<span class='item'><span class='day_num'>"+day+"</span>��</span><span class='item'><span class='hour_num'>"+hour+"</span>Сʱ</span><span class='item'><span class='minute_num'>"+minite+"</span>��</span><span class='item'><span class='second_num'>"+second+"</span>��</span>");  
							
		  } else {//ʣ��ʱ��С�ڻ����0��ʱ�򣬾�ֹͣ�������   
		   window.clearInterval(InterValObj);   
		   //���������ӵ���ʱʱ��Ϊ0����Ҫִ�е��¼�   
		  }   
	}
 } 